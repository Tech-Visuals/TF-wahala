# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket      = "tf-state-new"
    key         = "terraform.tfstate" #don't replace this value
    region      = "us-east-1"
    dynamodb_table = "tf-lock-new"
  }
}