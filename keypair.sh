

aws ec2 describe-key-pairs --key-name techvisuals-key-pair

aws ec2 create-key-pair --key-name techvisuals-key-pair --query 'KeyMaterial' --output text > techvisuals-key-pair.pem
here is how i  