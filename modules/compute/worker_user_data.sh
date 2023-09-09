#!/bin/bash
  apt update -y
  apt install docker.io -y
  systemctl enable docker.service
  usermod -aG docker ubuntu
  apt install -y apt-transport-https curl
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add
  apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
  apt update -y
  apt install -y kubelet kubeadm kubectl
  sysctl -w net.ipv4.ip_forward=1
  sed -i 's/net.ipv4.ip_forward=0/net.ipv4.ip_forward=1/Ig' /etc/sysctl.conf
  kubeadm join ${aws_instance.Master-Node.private_ip}:6443 \
  --token ${local.token} \
  --discovery-token-unsafe-skip-ca-verification