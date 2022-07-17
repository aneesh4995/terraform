provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "vpc1" {
  cidr_block = "192.168.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "192.168.1.0/24"
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = "192.168.2.0/24"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.bastionhost.id
  }
}
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.publicRT.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.privateRT.id
}