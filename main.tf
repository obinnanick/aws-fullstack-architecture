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
  vpc_id = aws_vpc.main_vpc.id #The VPC where is going to be deployed
  cidr_block = var.aws_public_subnet_cidr[count.index] #[count.index]Each subnet gets a unique CIDR from the list
   availability_zone = element(["us-east-1a", "us-east-1b"], count.index)  # Explicit AZ placement
  map_public_ip_on_launch = true #Ensures instances launched in this subnet automatically get a public IP. PS: Only for public subnets

  tags = {
    Name = "public_subnet-${count.index +1}"#${count.index} is Terraform’s loop index (starts at 1 here cos +1).

  }
}
resource "aws_internet_gateway" "main_igw" {
    vpc_id = aws_vpc.main_vpc.id
    tags = {
      Name = "main_igw"
    }
  
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name= "Public RT"
  }
}
#Creating a route rule for the Public subnet
resource "aws_route" "default_public_route" {
  route_table_id = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main_igw.id

}
resource "aws_route_table_association" "public_association" {
    count = length(var.aws_public_subnet_cidr)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
 }
resource "aws_subnet" "private_subnets" {
    count = length(var.aws_private_subnet_cidr)
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = var.aws_private_subnet_cidr[count.index]
     availability_zone = element(["us-east-1a", "us-east-1b"], count.index)  # Explicit AZ placement
    tags = {
      Name = "private_subnet-${count.index +3}"
    }
}
resource "aws_eip" "NAT_eip" { #Allocating and public IP first
  domain = "vpc"
}
#Creating NAT and attaching the public ip to it
resource "aws_nat_gateway" "NAT" {
    allocation_id = aws_eip.NAT_eip.id
    subnet_id = aws_subnet.public_subnets[0].id
    tags = {
        Name = "Nat_Gate"
    }
        
}
#Creating a public route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "Private RT"
  }

}
#Configuring the rules in the Private route table 
resource "aws_route" "NAT_private_route" {
  route_table_id = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.NAT.id
}
#Associating Private subnets with the Private route
resource "aws_route_table_association" "private_association" {
    count = length(var.aws_private_subnet_cidr)
    subnet_id = aws_subnet.private_subnets[count.index].id
    route_table_id = aws_route_table.private_rt.id
}