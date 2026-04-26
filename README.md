# 🚀 End-to-End DevOps Project: Containerized Java Application on AWS

This repository provisions and deploys a **containerized Java web application** using a fully automated DevOps pipeline. It implements a **production-grade multi-environment architecture (Stage + Prod)** with secure networking, CI/CD, monitoring, and security scanning.

The project also fulfills the requirement of an **Ansible auto-discovery script**, dynamically building inventory from private IPs of instances in the Auto Scaling Group.

---

## 🏗️ Architecture Overview

### 🔹 Stage Environment (Tools VPC - 10.10.0.0/16)

* Jenkins (CI/CD)
* Nexus (Docker + artifact repository)
* SonarQube (code quality)
* Bastion host

### 🔹 Production Environment (App VPC - 10.20.0.0/16)

* Auto Scaling Group (private app nodes)
* Application Load Balancer (ALB)
* Route53 + ACM (domain + HTTPS)
* Bastion host

### 🔹 Networking

* Separate VPCs for stage and prod
* **VPC Peering** enables private communication (Prod → Stage Nexus)
* No direct public access to application nodes

---

## 🛠️ Technologies Used

* **AWS**: VPC, EC2, ASG, ALB, Route53, ACM, S3, DynamoDB, VPC Peering
* **Terraform**: Infrastructure as Code
* **Jenkins**: CI/CD orchestration
* **Ansible**: Configuration & deployment
* **Docker**: Application containerization
* **Nexus**: Docker & artifact repository
* **SonarQube**: Code quality analysis
* **New Relic**: Infrastructure monitoring
* **Trivy**: Security scanning (FS + image)
* **Maven + Java 17/21**: Build system
* **Tomcat**: Application runtime

---

## 📦 What This Repo Provisions

* VPC with public and private subnets across 2 AZs (stage & prod)
* Internet Gateway, NAT Gateway, route tables
* Bastion host for secure SSH access
* Jenkins, Nexus, SonarQube (stage only)
* Application Load Balancer with HTTPS (ACM + Route53)
* Auto Scaling Group for application nodes
* **VPC Peering between stage and prod**
* Security groups enforcing least-privilege access

---

## 🚀 What This Repo Deploys

* Maven-built WAR file
* Docker image (Tomcat + WAR)
* Push to Nexus private registry
* Dynamic Ansible inventory from ASG
* Docker installation on private nodes
* Application deployment via bastion
* Optional New Relic agent installation
* Trivy security scans with report generation

---

## 🔐 Security Design

* App nodes run in **private subnets only**
* Bastion host used for controlled SSH access
* Security Group rules:

  * Jenkins → Bastion (SSH)
  * Bastion → App nodes (SSH)
  * Prod → Nexus via VPC peering
* No hardcoded credentials (Jenkins credentials used)

---

## 📊 CI/CD Pipeline (Jenkins)

### Pipeline Flow

1. Checkout source from GitHub
2. Read Terraform outputs (stage/prod)
3. Build WAR with Maven
4. Run **Trivy FS scan**
5. Run SonarQube analysis + Quality Gate
6. Upload WAR to Nexus
7. Build Docker image
8. Run **Trivy image scan**
9. Push Docker image to Nexus
10. Generate dynamic Ansible inventory
11. Bootstrap Docker on app nodes
12. Deploy container via bastion
13. Optionally install New Relic agent
14. Run application smoke test

---

## 🛡️ Security Scanning (Trivy)

### Filesystem Scan

```bash
trivy fs .
```

### Docker Image Scan

```bash
trivy image <image>
```

### Reports (Jenkins Artifacts)

```text
reports/trivy-fs.txt
reports/trivy-image.txt
```

---

## 📈 Monitoring (New Relic)

* Installed via Ansible on app nodes
* Uses license key from Jenkins credentials
* Tracks:

  * CPU, Memory, Disk
  * Host-level metrics
* Visible in:

  * **Infrastructure → Hosts**

---

## ⚙️ Backend State Handling

```bash
chmod +x scripts/*.sh
./scripts/create-backend.sh us-east-1 pet-adoption
./scripts/init-env.sh stage
./scripts/init-env.sh prod
```

This automatically:

* Creates S3 backend buckets
* Creates DynamoDB lock tables
* Generates `backend.auto.hcl`

---

## 🚀 Terraform Apply

### Stage (Tools)

```bash
cd environment/stage
terraform apply -auto-approve
```

### Prod (Application)

```bash
cd environment/prod
terraform apply -auto-approve
```

---

## 🔧 Jenkins Setup

### Tools

* JDK: `jdk21`
* Maven: `maven3`

### Credentials

* `ssh-private-key` → EC2 key pair
* `nexus-creds` → Nexus login
* `newrelic-license-key` → New Relic license key

---

## 📂 Files That Require Real Values

Set in:

```text
environment/stage/terraform.tfvars
environment/prod/terraform.tfvars
```

Required variables:

* `key_name`
* `domain_name`
* `allowed_admin_cidrs` (list of CIDRs)

---

## ⚠️ Key Challenges Solved

| Challenge                 | Solution                            |
| ------------------------- | ----------------------------------- |
| Jenkins disk full         | Attached EBS & moved `JENKINS_HOME` |
| SSH failures              | Fixed SG rules & bastion forwarding |
| Prod → Nexus unreachable  | Implemented VPC peering             |
| Terraform inconsistencies | Standardized variables              |
| New Relic not reporting   | Correct license key usage           |
| Pipeline failures         | Resource + config fixes             |

---

## 🌐 Outputs

### Stage

* Jenkins URL
* Nexus Registry
* SonarQube URL

### Prod

* Application URL
* Bastion IP
* ASG Name

---

## 🚀 Future Improvements

* Blue/Green deployments
* Kubernetes migration
* Slack notifications
* Advanced alerting (New Relic)
* Multi-region deployment

---

## 👨‍💻 Author

Gokul Parise
