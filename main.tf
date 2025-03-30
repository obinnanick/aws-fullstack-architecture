resource "aws_vpc" "main_vpc" {
  cidr_block = var.aws_vpc_cidr #referencing the vpc cidr from the variable
  enable_dns_support = true #Allows instances to resolve AWS-provided DNS names.
  enable_dns_hostnames = true #Enables assigning public DNS hostnames to instances with public IPs

  tags = {
    Name = "main_vpc"
  }
}
resource "aws_subnet" "public_subnets" {
  count = length(var.aws_public_subnet_cidr) #How many subnets to create which is already defined in the tfvar
  vpc_id = aws_vpc.main_vpc #The VPC where is going to be deployed
  cidr_block = var.aws_public_subnet_cidr[count.index] #[count.index]Each subnet gets a unique CIDR from the list
  map_public_ip_on_launch = true #Ensures instances launched in this subnet automatically get a public IP. PS: Only for public subnets

  tags = {
    Name = "public_subnet-${count.index +1}"#${count.index} is Terraform’s loop index (starts at 1 here cos +1).

  }
}
resource "aws_subnet" "private_subnet" {
    count = length(var.aws_private_subnet_cidr)
    vpc_id = aws_vpc.main_vpc
    cidr_block = var.aws_private_subnet_cidr[count.index]
    tags = {
      Name = "private_subnet-${count.index +1}"
    }
}
resource "aws_internet_gateway" "main_igw" {
    vpc_id = aws_vpc.main_vpc
    tags = {
      Name = "main_igw"
    }
  
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc
  tags = {
    Name= "Public RT"
  }
}