# -------------------------
# INSTANCE CONFIG
# -------------------------

variable "ami_id" {
  description = "AMI ID for bastion host"
  type        = string
  default     = "ami-0c02fb55956c7d316"
}

variable "instance_type" {
  description = "Instance type for bastion"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

# -------------------------
# NETWORKING
# -------------------------

variable "public_subnet" {
  description = "Public subnet ID for bastion host"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID (for security group)"
  type        = string
}

# -------------------------
# SECURITY
# -------------------------

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into bastion"
  type        = string
  default     = "0.0.0.0/0"  # change to your IP for security
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