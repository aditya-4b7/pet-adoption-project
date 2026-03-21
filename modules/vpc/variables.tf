# -------------------------
# GENERAL
# -------------------------

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# -------------------------
# PUBLIC SUBNETS
# -------------------------

variable "public_subnet_1_cidr" {
  description = "CIDR for public subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR for public subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

# -------------------------
# PRIVATE SUBNETS
# -------------------------

variable "private_subnet_1_cidr" {
  description = "CIDR for private subnet 1"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR for private subnet 2"
  type        = string
  default     = "10.0.12.0/24"
}

# -------------------------
# AVAILABILITY ZONES
# -------------------------

variable "az_1" {
  description = "Availability Zone 1"
  type        = string
  default     = "us-east-1a"
}

variable "az_2" {
  description = "Availability Zone 2"
  type        = string
  default     = "us-east-1b"
}

# -------------------------
# TAGGING
# -------------------------

variable "env" {
  description = "Environment name (stage/prod)"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "devops-project"
}