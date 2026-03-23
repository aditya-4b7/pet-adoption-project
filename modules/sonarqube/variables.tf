# -------------------------
# INSTANCE CONFIG
# -------------------------

variable "ami_id" {
  description = "AMI ID for SonarQube server"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "Instance type for SonarQube"
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

# -------------------------
# NETWORKING
# -------------------------

variable "subnet_id" {
  description = "Subnet ID where SonarQube will be deployed"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID (for security group)"
  type        = string
}

# -------------------------
# ACCESS CONTROL
# -------------------------

variable "allowed_cidr" {
  description = "CIDR allowed to access SonarQube UI (port 9000)"
  type        = string
  default     = "0.0.0.0/0"  # ⚠️ restrict in production
}

# -------------------------
# TAGGING
# -------------------------

variable "env" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "devops-project"
}