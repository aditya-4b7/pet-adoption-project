# End-to-End DevOps Project: Containerized Java Application on AWS

This repository deploys a containerized Java web application through a Jenkins CI/CD pipeline into a robust, scalable, high-availability AWS environment provisioned by Terraform. It implements the requirement for an Ansible auto-discovery bash script that builds inventory from the private IP addresses of instances currently running in the Auto Scaling Group.

## Technologies Used
- AWS: VPC, EC2, Auto Scaling Group, ALB, Route53, ACM, S3, DynamoDB
- GitHub: source control and collaboration
- Terraform: infrastructure provisioning
- Jenkins: CI/CD orchestration
- Ansible: bootstrap and deployment automation
- Docker: application packaging and runtime
- SonarQube: code quality analysis
- Nexus: artifact repository for WAR files
- Bastion Host: SSH jump host into private application instances
- New Relic: optional infrastructure monitoring on app nodes
- Tomcat: application server in the Docker image
- Maven: Java build and packaging
- Java 21: build and runtime base
- Trivy: container vulnerability scanning
- OWASP Dependency Check: dependency vulnerability scanning

## What This Repo Provisions
- VPC with 2 public and 2 private subnets across 2 AZs
- Internet Gateway, NAT Gateway, public and private route tables
- Bastion host in a public subnet
- Jenkins server in a public subnet
- SonarQube server in a public subnet
- Nexus server in a public subnet
- Route53 hosted zone
- ACM certificate validated by DNS
- Application Load Balancer with HTTP to HTTPS redirect
- Application Auto Scaling Group in private subnets
- Security groups that restrict app access to the ALB and bastion

## What This Repo Deploys
- Maven-built WAR
- Docker image containing Tomcat and the WAR
- Nexus artifact upload
- Trivy and OWASP scans in Jenkins
- Ansible bootstrap of Docker on app nodes
- Ansible deployment to the private ASG nodes through the bastion host
- Optional New Relic infrastructure agent installation on app nodes

## Files That Require Your Real Values
These cannot be guessed safely because they depend on your account and your environment:
- `environment/stage/terraform.tfvars`
- `environment/prod/terraform.tfvars`

Set these before applying Terraform:
- `key_name`: name of an EC2 key pair that already exists in your AWS account
- `domain_name`: a real domain you control so ACM DNS validation succeeds
- `allowed_admin_cidr`: your public IP in CIDR format, such as `1.2.3.4/32`

## Backend State Handling
The backend bucket names do not require manual placeholders anymore.

Run:
```bash
chmod +x scripts/*.sh
./scripts/create-backend.sh us-east-1 pet-adoption
./scripts/init-env.sh stage
./scripts/init-env.sh prod
```

The script automatically:
- reads your AWS account ID
- creates unique S3 bucket names for stage and prod
- creates DynamoDB lock tables
- writes `environment/<env>/backend.auto.hcl`

## Terraform Apply
Stage:
```bash
cd environment/stage
terraform apply -auto-approve
```

Prod:
```bash
cd environment/prod
terraform apply -auto-approve
```

## Jenkins Setup Summary
Configure these Jenkins tools:
- JDK named `jdk21`
- Maven named `maven3`

Configure these Jenkins credentials:
- `ssh-private-key`: private key matching `key_name`
- `nexus-creds`: username and password for Nexus
- `newrelic-license-key`: optional secret text credential for New Relic

## Pipeline Flow
1. Checkout source from GitHub
2. Read Terraform outputs from the selected environment
3. Build WAR with Maven
4. Run OWASP Dependency Check
5. Run SonarQube analysis and quality gate
6. Upload WAR to Nexus
7. Build Docker image
8. Run Trivy scan
9. Save Docker image as tarball
10. Generate Ansible inventory from ASG private IPs
11. Bootstrap Docker on app nodes through the bastion host
12. Deploy the new image to app nodes through the bastion host
13. Optionally install New Relic infrastructure agent
14. Run an HTTPS smoke test against the application domain
