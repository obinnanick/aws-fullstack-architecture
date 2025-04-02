output "vpc_id" {
  value = aws_vpc.main_vpc.id
}
output "aws_public_subnet_cidr" {
  value = aws_subnet.public_subnets[*].id
}
output "aws_private_subnet_cidr" {
  value = aws_subnet.private_subnets[*].id
}
