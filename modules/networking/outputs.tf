output "bastion_host_id" {
  description = "The ID of the bastion host instance."
  value       = aws_instance.bastion_host.id
}

# Add more outputs as needed


output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.techvisuals_lb.dns_name
}

# Add more outputs as needed

output "worker_subnet_ids" {
  description = "The IDs of the worker node subnets."
  value       = aws_subnet.worker_subnets[*].id
}

output "control_plane_subnet_ids" {
  description = "The IDs of the control plane subnets."
  value       = aws_subnet.control_plane_subnets[*].id
}

output "database_subnet_id" {
  description = "The ID of the database subnet."
  value       = aws_subnet.database_subnet.id
}

output "bastion_subnet_id" {
  value = aws_subnet.bastion_subnet.id
}

output "load_balancer_subnet1_id" {
  description = "The ID of the subnet where the load balancer will be placed."
  value       = aws_subnet.load_balancer_subnet1.id
}


output "load_balancer_subnet2_id" {
  description = "The ID of the subnet where the load balancer will be placed."
  value       = aws_subnet.load_balancer_subnet2.id
}

output "vpc_id" {
  description = "The ID of the created VPC."
  value       = aws_vpc.techvisuals_vpc.id
}

 output "internet_gateway_id" {
    description = "The ID of the Inernet Gateway"
    value       = aws_internet_gateway.techvisuals_igw.id
}


output "lb_target_group_arn" {
  value = aws_lb_target_group.techvisuals_tg.arn
}



output "lb_target_group_name" {
  value = aws_lb_target_group.techvisuals_tg.name
}


output "lb_tg" {
  value = aws_lb.techvisuals_lb.id
}