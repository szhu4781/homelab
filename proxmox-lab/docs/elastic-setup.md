# Elastic SIEM Deployment & Active Directory Monitoring Setup
This guide contains a step-by-step deployment of a resource-optimized, secure Elastic SIEM cluster inside an Ubuntu Server VM on Proxmox VE, configured to ingest and alert on telemetry from a Windows Server Active Directory Domain Controller.

## Stack
* **Elastic Host VM:** Ubuntu Server 24.04 LTS (4GB RAM, 2 Cores)
* **Telemetry Source:** Windows Server 2022 Domain Controller (DC) VM
* **Log Pipeline:** Windows Security Event Logs -> Winlogbeat -> Elasticsearch (Port 9200) -> Kibana (Port 5601)

### 1. Optimize Linux Kernel Memory
Elasticsearch requires a memory map count that exceeds Linux defaults. Increase this limit permanently on the Ubuntu VM:
```
sudo sysctl -w vm.max_map_count=262144
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```
### 2. Configure `docker-compose.yml`
Create a project directory `~/elastic-siem` and deploy the following environment configuration. This setup implements a **Lean Mode** architecture, strictly capping Java Virtual Machine (JVM) heap space and container limits to preserve host system resources:
```yaml
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.0
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
      - "ES_JAVA_OPTS=-Xms1g -Xmx1g"
      - xpack.security.enabled=true
      - xpack.security.transport.ssl.enabled=false
      - xpack.security.http.ssl.enabled=false
      - xpack.security.authc.api_key.enabled=true
    ulimits:
      memlock:
        soft: -1
        hard: -1
    volumes:
      - esdata:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"
    deploy:
      resources:
        limits:
          memory: 2g

  kibana:
    image: docker.elastic.co/kibana/kibana:7.17.0
    container_name: kibana
    ports:
      - "5601:5601"
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
      - ELASTICSEARCH_USERNAME=kibana_system
      - ELASTICSEARCH_PASSWORD=YourSecureKibanaSystemPassword
      - XPACK_ENCRYPTEDSAVEDOBJECTS_ENCRYPTIONKEY=YourGenerated32CharacterStringHere
    depends_on:
      - elasticsearch
    deploy:
      resources:
        limits:
          memory: 1g

volumes:
  esdata:
    driver: local
```
**Note: Refer to the /docker-compose.yml in the /scripts folder if needed. Replace username, password, and encryption key values with your generated values.**

### 3. Initialize Security & Passwords
Launch the Elasticsearch database first to initialize security parameters:
```
sudo docker compose up -d elasticsearch
```
Once the database node is online, execute the native credential utility to generate passwords for default system service accounts:
```
sudo docker compose exec elasticsearch bin/elasticsearch-setup-passwords interactive
```
**Note: Record all generated keys. The `kibana_system` password must be updated inside the `docker-compose.yml` file before launching the frontend web container using `sudo docker compose up -d`.**
---

### 4. GPO Advanced Audit Configuration
By default, Windows Server silences specific authentication failure metadata. Enforce auditing parameters natively via Group Policy:
1. Open **Group Policy Management Console (GPMC)** on the Domain Controller.
2. Edit the **Default Domain Controllers Policy** under the Domain Controllers OU.
3. Navigate to: `Computer Configuration > Policies > Windows Settings > Security Settings > Advanced Audit Policy Configuration > Audit Policies`.
4. Configure the following subcategories for **Success and Failure**:
   * **Logon/Logoff:** Audit Logon, Audit Account Lockout
   * **Account Management:** Audit Security Group Management, Audit User Account Management
5. Open an Administrator PowerShell window and push the changes live immediately:
```powershell
gpupdate /force
```
### 5. Agent Installation
1. Download the **Winlogbeat 7.17.0 ZIP Archive** on the Domain Controller VM.
2. Extract the file directory cleanly to `C:\Program Files\Winlogbeat`.

### 6. Configure Authentication and Output Channel
Modify `C:\Program Files\Winlogbeat\winlogbeat.yml` to supply authenticated access credentials targeting the remote SIEM database:
```
winlogbeat.event_logs:
  - name: Security
    event_id: 4625, 4728, 4732, 4720

output.elasticsearch:
  hosts: ["http://<UBUNTU_VM_IP>:9200"]
  username: "elastic"
  password: "YourMasterElasticPassword"
```
**Notes: Replace host address with the address of your Ubuntu VM**

### 7. Register and Start Windows Service
Open an **Administrator PowerShell** session, bypass execution policies for the setup script, register the service binary, and turn on the pipeline:
```
Set-ExecutionPolicy Bypass -Scope Process -Force
cd "C:\Program Files\Winlogbeat"
.\install-service-winlogbeat.ps1
Start-Service winlogbeat
```
Verify successful deployment by confirming the connection test status returns clean:
```
.\winlogbeat.exe test output -c .\winlogbeat.yml
```
### 8. Map Data Views
1. Navigate to Kibana (`http://<UBUNTU_VM_IP>:5601`) on your DC VM browser and authenticate using the master `elastic` user credentials.
2. Go to **Management > Stack Management > Kibana > Index Patterns**.
3. Create an index pattern mapping explicitly to: `winlogbeat-*` using `@timestamp` as the primary time field.

### 9. Deploy Brute Force Threshold Alert Logic
1. Navigate to **Security > Detect > Rules > Create New Rule**.
2. Select **Threshold** as the engine type.
3. Define the tracking logic criteria:
   * **Index Pattern:** `winlogbeat-*`
   * **Custom Query:** `winlog.event_id : "4625"`
   * **Threshold Aggregator (Group By):** `winlog.event_data.targetUserName`
   * **Threshold Condition:** `Is above 5`
4. Set execution parameters: Run **Every 5 minutes** with an additional **2-minute look-back safety buffer** to conserve CPU cycles.
5. Set actions mapping to: **Perform no actions** (routing alerts entirely into the internal Kibana Security Incident panel).
With that, you just created a custom threshold rule in Kibana. Congrats.

### 10. Emulate Adversarial Attacks
To validate the detection engine pipeline end-to-end, execute an automated credential guessing script block on an endpoint or the DC to force consecutive auditing failures:
```powershell
FOR (\$i=1; i -le 10; i++) { net use \\127.0.0.1 /user:siem_test_attacker WrongPass123! }
```
Within 5 minutes, the rule scheduling window will catch the threshold breach, populating the **Security > Alerts** dashboard grid with a High-Severity brute-force event notification containing full user and host context.
