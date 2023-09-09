# Bastion Host Configuration

aws_profile = "adejoke"
region = "us-east-1"
bastion_ami           = "ami-053b0d53c279acc90"  # Replace with your preferred AMI ID
bastion_instance_type = "t2.micro"         # Replace with your preferred instance type
key_name      = "techvisuals-key-pair"   # Replace with your SSH key pair name
project_name = "techvisuals"
bastion_security_group_name = "bastion-sg"  # Replace with your desired security group name
bastion_ssh_cidr_blocks    = ["0.0.0.0/0"]
bastion_http_cidr_blocks   =  ["0.0.0.0/0"]
bastion_https_cidr_blocks   =  ["0.0.0.0/0"]

# Load Balancer Subnet CIDR Block 
bastion_subnet_cidr_block       = ["10.0.1.0/24"]
load_balancer_subnet1_cidr_block = ["10.0.2.0/24"]  
load_balancer_subnet2_cidr_block = ["10.0.3.0/24"] 
load_balancer_http_cidr  = ["0.0.0.0/0"]  # Replace with your desired CIDR block
load_balancer_https_cidr = ["0.0.0.0/0"] 


# Worker Node Subnet CIDR Blocks
worker_subnet_cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24"]

# Control Plane Subnet CIDR Blocks
control_plane_subnet_cidr_blocks = ["10.0.6.0/24", "10.0.7.0/24"]

# Database Subnet CIDR Block
database_subnet_cidr_block = "10.0.8.0/24"

# Availability Zones
availability_zones = ["us-east-1a", "us-east-1b"]
# Add values for other variables as needed# techvisuals.tfvars

vpc_cidr_block = "10.0.0.0/16"


  # Replace with your trusted IP range
