# variables.tf
variable "vpc_id" {}
variable "subnet_id" {}
variable "key_name" {}
variable "ami_id" {}
variable "region" {}
variable "instance_type" {
  description = "The EC2 instance type"
  default     = "t2.micro"
}

