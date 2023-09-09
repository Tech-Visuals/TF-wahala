variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

# Add more variables as needed
variable "worker_subnet_cidr_blocks" {
  description = "CIDR blocks for worker node subnets."
  type        = list(string)
  # Example: ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "control_plane_subnet_cidr_blocks" {
  description = "CIDR blocks for control plane subnets."
  type        = list(string)
  # Example: ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "database_subnet_cidr_block" {
  description = "CIDR block for the database subnet."
  type        = string
  # Example: "10.0.5.0/24"
}

variable "availability_zones" {
  description = "List of availability zones."
  type        = list(string)
  # Example: ["us-east-1a", "us-east-1b"]
}

variable "load_balancer_subnet1_cidr_block" {}
variable "load_balancer_subnet2_cidr_block" {}
variable "bastion_subnet_cidr_block" {}


variable "load_balancer_http_cidr" {
  description = "Allowed CIDR block for HTTP traffic to the load balancer."
  type        = list(string)
}

variable "load_balancer_https_cidr" {
  description = "Allowed CIDR block for HTTPS traffic to the load balancer."
  type        = list(string)
}

# Add more variables as needed

variable "instance_type" {
  description = "The EC2 instance type for the bastion host."
  type        = string
}

variable "bastion_security_group_name" {}
variable "bastion_ssh_cidr_blocks" {}
variable "bastion_http_cidr_blocks" {}
variable "key_name" {}
variable "bastion_instance_type" {} 
variable "ami" {}
variable "project_name" {}