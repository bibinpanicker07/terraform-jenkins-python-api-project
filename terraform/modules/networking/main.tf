variable "vpc_name" {}
variable "vpc_cidr_block" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "az" {}

resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr_block
    tags           = {
        Name       = var.vpc_name
    }
}
resource "aws_subnet" "public_subnet"{
    count             = length(var.public_subnet_cidr)
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = element(var.public_subnet_cidr, count.index)
    availability_zone = element(var.az, count.index)
    map_public_ip_on_launch = true
    tags              = {
        Name          = "public-subnet-${count.index+1}"
    }
}
resource "aws_subnet" "private_subnet"{
    count             = length(var.private_subnet_cidr)
    vpc_id            = aws_vpc.vpc.id
    cidr_block        = element(var.private_subnet_cidr, count.index)
    availability_zone = element(var.az, count.index)
    tags              = {
        Name          = "private-subnet-${count.index+1}"
    }
}
resource "aws_internet_gateway" "igw"{
    vpc_id            = aws_vpc.vpc.id
    tags              = {
        Name          = "igw"
    }
}
resource "aws_route_table" "public_rt" {
    vpc_id            = aws_vpc.vpc.id
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags              = {
        Name          = "public_rt"
    }    
}
resource "aws_route_table_association" "public_rt_association" {
    count           = length(aws_subnet.public_subnet) 
    subnet_id       = aws_subnet.public_subnet[count.index].id
    route_table_id  = aws_route_table.public_rt.id
}
resource "aws_route_table" "private_rt" {
    vpc_id            = aws_vpc.vpc.id

    tags              = {
        Name          = "private_rt"
    }    
}
resource "aws_route_table_association" "private_rt_association" {
    count           = length(aws_subnet.private_subnet) 
    subnet_id       = aws_subnet.private_subnet[count.index].id
    route_table_id  = aws_route_table.private_rt.id
}

output "vpc_id" {
    value = aws_vpc.vpc.id
}
output "public_subnet_ids" {
    value = aws_subnet.public_subnet.*.id
}