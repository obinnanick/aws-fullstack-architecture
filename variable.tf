variable "aws_region" {
  description = "AWS region"
  type = string
}
variable "aws_vpc_cidr" {
  description = "VPC cidr block "
  type = string
}
variable "aws_public_subnet_cidr" {
  description = "Public Subnet Cidr List"
  type = list(string)
}
variable "aws_private_subnet_cidr" {
    description = "Private Subnet Cidr List"
    type = list(string)
}
