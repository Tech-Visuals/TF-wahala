
resource "aws_vpc" "techvisuals_vpc" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

 tags      = {
    Name    = "${var.project_name}-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_internet_gateway" "techvisuals_igw" {
   vpc_id             = aws_vpc.techvisuals_vpc.id

    tags      = {
      Name    = "${var.project_name}-igw"
    }
}

# Subnet for Bastion Host
resource "aws_subnet" "bastion_subnet" {
  vpc_id                  = aws_vpc.techvisuals_vpc.id
  cidr_block              = var.bastion_subnet_cidr_block[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "techvisuals-bastion-subnet"
  }
}
# Subnet for Load Balancer
resource "aws_subnet" "load_balancer_subnet1" {
  vpc_id                  = aws_vpc.techvisuals_vpc.id
  cidr_block              = var.load_balancer_subnet1_cidr_block[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "techvisuals-load-balancer-subnet1"
  }
}

resource "aws_subnet" "load_balancer_subnet2" {
  vpc_id                  = aws_vpc.techvisuals_vpc.id
  cidr_block              = var.load_balancer_subnet2_cidr_block[0]  # Different CIDR block
  availability_zone       = var.availability_zones[1]  # Different AZ
  map_public_ip_on_launch = true
  tags = {
    Name = "techvisuals-load-balancer-subnet2"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.techvisuals_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.techvisuals_igw.id
  }

  tags       = {
    Name     = "public route table"
  }
}

# associate public subnet az1 to "public route table"
resource "aws_route_table_association" "public_subnet_az1_route_table_association" {
  subnet_id           = aws_subnet.load_balancer_subnet1.id
  route_table_id      = aws_route_table.public_route_table.id
}

# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "public_subnet_az2_route_table_association" {
  subnet_id           = aws_subnet.load_balancer_subnet2.id
  route_table_id      = aws_route_table.public_route_table.id
}


### EIP AND NAT GATEWAY
resource "aws_eip" "techvisuals_eip" {
  domain = "vpc"

  tags      = {
     Name    = "${var.project_name}-eip"
   }

}
resource "aws_nat_gateway" "techvisuals_ngw" {
  allocation_id     = aws_eip.techvisuals_eip.id
  subnet_id         = aws_subnet.load_balancer_subnet1.id

  tags      = {
     Name    = "${var.project_name}-ngw"
   }
}


# Worker Node Subnets
resource "aws_subnet" "worker_subnets" {
  count           = length(var.worker_subnet_cidr_blocks)
  vpc_id          = aws_vpc.techvisuals_vpc.id
  cidr_block      = var.worker_subnet_cidr_blocks[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "techvisuals-worker-subnet-${count.index + 1}"  # Adjust the naming as needed
  }
}

resource "aws_route_table" "worker_route_table" {
  count = length(var.worker_subnet_cidr_blocks)
  vpc_id = aws_vpc.techvisuals_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.techvisuals_ngw.id
  }

  tags = {
    Name = "worker private route table ${count.index + 1}"
  }
}


# Associate each worker subnet with its corresponding private route table
resource "aws_route_table_association" "worker_subnet_route_table_association" {
  count      = length(aws_subnet.worker_subnets)
  subnet_id  = aws_subnet.worker_subnets[count.index].id
  route_table_id = aws_route_table.worker_route_table[count.index].id
}



# Control Plane Subnets
# Control Plane Subnets
resource "aws_subnet" "control_plane_subnets" {
  count           = length(var.control_plane_subnet_cidr_blocks)
  vpc_id          = aws_vpc.techvisuals_vpc.id
  cidr_block      = var.control_plane_subnet_cidr_blocks[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "techvisuals-control-plane-subnet-${count.index + 1}"  # Adjust the naming as needed
  }
}

resource "aws_route_table" "control_plane_route_table" {
  count = length(var.control_plane_subnet_cidr_blocks)
  vpc_id = aws_vpc.techvisuals_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.techvisuals_ngw.id
  }

  tags = {
    Name = "control-plane-route-table ${count.index + 1}"
  }
}

# Associate each control plane subnet with its corresponding route table
resource "aws_route_table_association" "control_plane_route_table_association" {
  count      = length(aws_subnet.control_plane_subnets)
  subnet_id  = aws_subnet.control_plane_subnets[count.index].id
  route_table_id = aws_route_table.control_plane_route_table[count.index].id
}



# Database Subnet
resource "aws_subnet" "database_subnet" {
  vpc_id          = aws_vpc.techvisuals_vpc.id
  cidr_block      = var.database_subnet_cidr_block
  availability_zone = element(var.availability_zones, length(var.availability_zones) - 1)
  tags = {
    Name = "techvisuals-database-subnet"
  }
}





# Bastion Host Configuration
resource "aws_instance" "bastion_host" {
  ami           = var.ami
  instance_type = var.bastion_instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.bastion_subnet.id  # Make sure to adjust the module reference

  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name        = "bastion-host"
    Environment = "production"
  }

  # IAM role for accessing AWS services (if needed)
  # iam_instance_profile = aws_iam_instance_profile.bastion_profile.name
}


# Define the security group for the bastion host
resource "aws_security_group" "bastion_sg" {
  name_prefix   = var.bastion_security_group_name
  description   = "Security group for the bastion host"
  vpc_id        = aws_vpc.techvisuals_vpc.id

  # Bastion SSH Ingress Rule
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_ssh_cidr_blocks
  }

  # Bastion HTTP Ingress Rule
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.bastion_http_cidr_blocks
  }


}

#  Creating ALB



resource "aws_lb_target_group" "techvisuals_tg" {
  name       = "techvisuals-tg"
  port       = 80 #8080
  protocol   = "HTTP"
  vpc_id     = aws_vpc.techvisuals_vpc.id
  slow_start = 0

  load_balancing_algorithm_type = "round_robin"

  stickiness {
    enabled = false
    type    = "lb_cookie"
  }

  health_check {
    enabled             = true
    port                = 443 #8081
    interval            = 30
    protocol            = "HTTP"
    path                = "/health"
    matcher             = "200"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}


#resource "aws_lb_target_group_attachment" "techvisuals_app_attach" {
 # for_each = aws_instance.techvisuals

 # target_group_arn = aws_lb_target_group.my_app_eg1.arn
 # target_id        = each.value.id
 # port             = 8080
#}


resource "aws_lb" "techvisuals_lb" {
  name               = "techvisuals-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.load_balancer_subnet1.id, aws_subnet.load_balancer_subnet2.id]
  security_groups    = [aws_security_group.load_balancer_sg.id]
  enable_deletion_protection = false
  enable_http2       = true

}


# HTTP Listener Rule
resource "aws_lb_listener" "techvisuals_listner" {
  load_balancer_arn = aws_lb.techvisuals_lb.arn 
  port             = 80
  protocol         = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.techvisuals_tg.arn
  }
}






  # Define the security group for the load balancer
resource "aws_security_group" "load_balancer_sg" {
  name_prefix = "load-balancer-"
  description = "Security group for the load balancer"
  vpc_id      = aws_vpc.techvisuals_vpc.id

  # Load Balancer HTTP Rule (adjust ports and protocols as needed)
  ingress {
    from_port   = 80  # HTTP port
    to_port     = 80  # HTTP port
    protocol    = "tcp"
    cidr_blocks = var.load_balancer_http_cidr  # Allowed CIDR block for HTTP traffic
  }

  # Load Balancer HTTPS Rule (adjust ports and protocols as needed)
  ingress {
    from_port   = 443  # HTTPS port
    to_port     = 443  # HTTPS port
    protocol    = "tcp"
    cidr_blocks = var.load_balancer_https_cidr  # Allowed CIDR block for HTTPS traffic
  }

  # Add more rules specific to your load balancer if needed
}






