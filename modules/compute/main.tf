
resource "aws_instance" "kube-master" {
    ami = var.ami
    instance_type = var.control_plane_instance_type
    #iam_instance_profile = module.iam.master_profile_name
    vpc_security_group_ids = [aws_security_group.techvisuals-kube-master-sg.id, aws_security_group.techvisuals-kube-mutual-sg.id]
    key_name = var.key_name
    subnet_id = var.control-plane-subnet-1
    availability_zone = "us-east-1a"
    tags = {
        Name = "kube-master"
        "kubernetes.io/cluster/techvisualsCluster" = "owned"
        Project = "techvisuals-project"
        Role = "master"
        Id = "1"
    }
}

resource "aws_instance" "worker-1" {
    ami = var.ami
    instance_type = var.worker_instance_type
    #iam_instance_profile = module.iam.worker_profile_name
    vpc_security_group_ids = [aws_security_group.techvisuals-kube-worker-sg.id, aws_security_group.techvisuals-kube-mutual-sg.id]
    key_name = var.key_name
    subnet_id = var.worker-subnet-1
    availability_zone = "us-east-1a"
    tags = {
        Name = "worker-1"
        "kubernetes.io/cluster/techvisualsCluster" = "owned"
        Project = "techvisuals-project"
        Role = "worker"
        Id = "1"
    }
}

resource "aws_instance" "worker-2" {
    ami = var.ami
    instance_type = var.worker_instance_type
    #iam_instance_profile = module.iam.worker_profile_name
    vpc_security_group_ids = [aws_security_group.techvisuals-kube-worker-sg.id, aws_security_group.techvisuals-kube-mutual-sg.id]
    key_name = var.key_name
    subnet_id = var.worker-subnet-2
    availability_zone = "us-east-1b"
    tags = {
        Name = "worker-2"
        "kubernetes.io/cluster/techvisualsCluster" = "owned"
        Project = "techvisuals-project"
        Role = "worker"
        Id = "2"
    }
}



# Create a security group for worker nodes
resource "aws_security_group" "techvisuals-kube-mutual-sg" {
  name = "kube-mutual-sec-group-for-techvisuals"
  vpc_id = var.vpc_id
  tags = {
    Name = "kube-mutual-secgroup"
  }
}

resource "aws_security_group" "techvisuals-kube-worker-sg" {
  name = "kube-worker-sec-group-for-techvisuals"
  vpc_id = var.vpc_id
  ingress {
    protocol = "tcp"

    from_port = 10250
    to_port = 10250
    security_groups = [aws_security_group.techvisuals-kube-mutual-sg.id]
  }
  ingress {
    protocol = "tcp"
    from_port = 30000
    to_port = 32767
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "udp"
    from_port = 8472
    to_port = 8472
    security_groups = [aws_security_group.techvisuals-kube-mutual-sg.id]
  }
  egress{
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "kube-worker-secgroup"
    "kubernetes.io/cluster/techvisualssCluster" = "owned"
  }
}

resource "aws_security_group" "techvisuals-kube-master-sg" {
  name = "kube-master-sec-group-for-techvisuals"
  vpc_id = var.vpc_id
  ingress {
    protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = 6443
    to_port = 6443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    protocol = "tcp"
    from_port = 2380
    to_port = 2380
    security_groups = [aws_security_group.techvisuals-kube-mutual-sg.id]
  }
  ingress {
    protocol = "tcp"
    from_port = 2379
    to_port = 2379
    security_groups = [aws_security_group.techvisuals-kube-mutual-sg.id]
  }
  ingress {
    protocol = "tcp"
    from_port = 10250
    to_port = 10250
    security_groups = [aws_security_group.techvisuals-kube-mutual-sg.id]
  }
  ingress {
    protocol = "tcp"
    from_port = 10251
    to_port = 10251
    security_groups = [aws_security_group.techvisuals-kube-mutual-sg.id]
  }
  ingress {
    protocol = "tcp"
    from_port = 10252
    to_port = 10252
    security_groups = [aws_security_group.techvisuals-kube-mutual-sg.id]
  }
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "kube-master-secgroup"
  }
}