module "networking" {
  source = "./modules/networking"


  worker_subnet_cidr_blocks     = var.worker_subnet_cidr_blocks
  control_plane_subnet_cidr_blocks = var.control_plane_subnet_cidr_blocks
  database_subnet_cidr_block    = var.database_subnet_cidr_block
  availability_zones            = var.availability_zones
  bastion_ssh_cidr_blocks = var.bastion_ssh_cidr_blocks
  bastion_http_cidr_blocks = var.bastion_http_cidr_blocks
  load_balancer_subnet1_cidr_block = var.load_balancer_subnet1_cidr_block
  load_balancer_subnet2_cidr_block = var.load_balancer_subnet2_cidr_block
  bastion_subnet_cidr_block = var.bastion_subnet_cidr_block
  instance_type   = var.bastion_instance_type
  key_name        = var.key_name
  bastion_security_group_name = var.bastion_security_group_name  # Corrected argument name
  load_balancer_http_cidr = var.load_balancer_http_cidr
  load_balancer_https_cidr = var.load_balancer_https_cidr
  bastion_instance_type = var.bastion_instance_type
  bastion_ami = var.bastion_ami
  project_name = var.project_name
  # Other module arguments...
}
