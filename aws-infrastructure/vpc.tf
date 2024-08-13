provider "aws" {
  region = var.region
}

resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "first_subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.subnet[0].cidr
  availability_zone = var.subnet1_az
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet[0].subnet_name
  }
}

resource "aws_subnet" "second_subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.subnet[1].cidr
  availability_zone = var.subnet2_az
  map_public_ip_on_launch = true

  tags = {
    Name = var.subnet[1].subnet_name
  }
}

resource "aws_internet_gateway" "internetgtw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = var.internetgtw_name
  }
}

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = var.rt_cidr
    gateway_id = aws_internet_gateway.internetgtw.id
  }

  tags = {
    Name = var.rt_name
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.first_subnet.id
  route_table_id = aws_route_table.route.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.second_subnet.id
  route_table_id = aws_route_table.route.id
}

