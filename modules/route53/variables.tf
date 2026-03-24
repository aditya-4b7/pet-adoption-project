variable "domain_name" {
  description = "Domain name (example.com)"
  type        = string
}

variable "alb_dns" {
  description = "ALB DNS name"
  type        = string
}

variable "alb_zone_id" {
  description = "ALB hosted zone ID"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "devops-project"
}