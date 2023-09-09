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
  # Ignore preflight in order to have master running on t2.micro, otherwise remove it 
  kubeadm init --token ${local.token} \
  --pod-network-cidr=10.244.0.0/16 \
  --service-cidr=10.96.0.0/12 \
  --ignore-preflight-errors=all
  sleep 30
  mkdir -p /home/ubuntu/.kube ~/.kube
  cp /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
  chown ubuntu:ubuntu /home/ubuntu/.kube/config
  export KUBECONFIG=/etc/kubernetes/admin.conf
  kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
  # while [[ $(kubectl -n kube-system get pods -l k8s-app=kube-dns -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do sleep 5; done