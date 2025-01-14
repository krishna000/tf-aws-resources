terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }
}

provider "aws" {
  region = "ap-south-1a"
}

# Creating VPC, name, CIDR and Tags
resource "aws_vpc" "dev" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "dev"
  }
}

#Creating first Public Subnet in VPC
resource "aws_subnet" "dev-public-1" {
  vpc_id = aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch =  "true"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "dev-public-1"
  }
}

#Creating second Public Subnet in VPC
resource "aws_subnet" "dev-public-2" {
  vpc_id = aws_vpc.dev.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch =  "true"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "dev-public-2"
  }
}

#Creating Internet Gateway in AWS VPC
resource "aws_internet_gateway" "dev-gw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev"
  }
}

#Create Route tables for Internet Gateway
resource "aws_route_table" "dev-public" {
  vpc_id         = aws_vpc.dev.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-gw.id
  }

  tags = {
    Name = "dev-public-1"
  }
}

resource "aws_route_table_association" "dev-public-1-a" {
  subnet_id = aws_subnet.dev-public-1.id
  route_table_id = aws_route_table.dev-public.id
}

resource "aws_route_table_association" "dev-public-2-a" {
  subnet_id = aws_subnet.dev-public-2.id
  route_table_id = aws_route_table.dev-public.id
}