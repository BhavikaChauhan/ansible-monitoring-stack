# 📊 Ansible Monitoring Stack Deployment (WSL → Azure VM)

This project automates the deployment of a monitoring stack (Prometheus + Grafana + Node Exporter) on an Azure Ubuntu VM using Ansible from WSL.

---

# 🏗️ Architecture

```
WSL (Ubuntu)
   ↓
Ansible 2.15 (virtual environment)
   ↓
Azure Ubuntu 24.04 VM
   ↓
Docker + Docker Compose
   ↓
Prometheus + Grafana + Node Exporter
```

---

# 🚀 Prerequisites

## Local (WSL)

* Ubuntu (WSL)
* Python 3
* SSH key (.pem file)
* Internet access

## Remote (Azure VM)

* Ubuntu 24.04 LTS
* Port 22 open (SSH)
* Port 3000 open (Grafana access)

# 📁 Project Structure

```
ansible-monitoring-stack/
│
├── inventory.ini
├── playbook.yml
├── requirements.txt
├── mujahed.pem
└── files/
    ├── docker-compose.yml
    ├── prometheus.yml
    └── grafana provisioning files
```

---

# 📦 Project Setup

## 1️⃣ Clone Repository

```bash
git clone https://github.com/BhavikaChauhan/ansible-monitoring-stack.git
cd ansible-monitoring-stack
```

---

## 2️⃣ Create Python Virtual Environment

```bash
sudo apt update
sudo apt install python3-venv python3-pip -y

python3 -m venv ansible215
source ansible215/bin/activate
```

---

## 3️⃣ Install Required Ansible Version

```bash
pip install --upgrade pip
pip install ansible-core==2.15.12
```

Verify:

```bash
ansible --version
```

Expected:

```
ansible [core 2.15.12]
```

---

# 🔑 Inventory Configuration

Ensure `inventory.ini` contains:

```
[monitoring]
azurevm ansible_host=<PUBLIC_IP> ansible_user=azureuser ansible_ssh_private_key_file=key.pem
```

---

# 🔎 Test Connectivity

```bash
ansible monitoring -i inventory.ini -m ping
```

Expected:

```
"ping": "pong"
```

---

# 🐳 Deployment

Run playbook:

```bash
ansible-playbook -i inventory.ini playbook.yml
```

This will:

* Add Docker official repository
* Install Docker Engine
* Install Docker Compose plugin
* Enable Docker service
* Copy monitoring files
* Start containers

---

# 🔍 Verify Deployment

Check running containers:

```bash
ansible monitoring -i inventory.ini -b -a "docker ps"
```

You should see:

* prometheus
* grafana
* node-exporter

---

# 🌍 Access Grafana

Open in browser:

```
http://<PUBLIC_IP>:3000
```

Default credentials:

```
Username: admin
Password: admin
```

---

# 🔥 Azure Network Rule

Ensure Azure inbound rule allows:

| Port | Protocol | Source |
| ---- | -------- | ------ |
| 3000 | TCP      | Any    |

---

# 🧹 Cleanup (Full Removal)

## Stop containers

```bash
ansible monitoring -i inventory.ini -b -a "docker compose -f /opt/monitoring/docker-compose.yml down"
```

## Remove Docker

```bash
ansible monitoring -i inventory.ini -b -a "apt remove --purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y"
ansible monitoring -i inventory.ini -b -a "apt autoremove -y"
ansible monitoring -i inventory.ini -b -a "rm -rf /var/lib/docker /var/lib/containerd"
```

## Remove monitoring directory

```bash
ansible monitoring -i inventory.ini -b -a "rm -rf /opt/monitoring"
```

## Remove local virtual environment

```bash
deactivate
rm -rf ansible215
```

---

# ⚠️ Common Issues Faced

### 1. `ModuleNotFoundError: ansible.module_utils.six.moves`

Fixed by installing:

```
ansible-core==2.15.12
```

---

### 2. `docker-compose-plugin not available`

Fixed by adding official Docker repository for Ubuntu 24.04.

---

### 3. `permission denied docker.sock`

Use:

```
-b
```

with Ansible commands.

---

### 4. `ERR_CONNECTION_TIMED_OUT`

Open port 3000 in Azure Network Security Group.

---

---

# 🔄 Reuse Setup Later

Each new terminal session:

```bash
cd ansible-monitoring-stack
source ansible215/bin/activate
```

---

# ✅ Final Result

* Automated monitoring deployment
* Infrastructure provisioned via Ansible
* Docker managed via official repository
* Grafana accessible via public IP
* Fully reproducible environment
