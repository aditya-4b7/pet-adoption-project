resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { 
    Name = "${var.project_name}-${var.env}-vpc" 
    Environment = var.env 
    Project = var.project_name 
    }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = { 
    Name = "${var.project_name}-${var.env}-igw" 
    Environment = var.env 
    Project = var.project_name 
    }
}
resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_1_cidr
  availability_zone = var.az_1
  map_public_ip_on_launch = true
  tags = { 
    Name = "${var.project_name}-${var.env}-public-1" 
    Environment = var.env 
    Project = var.project_name 
    Tier = "public" }
}
resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_2_cidr
  availability_zone = var.az_2
  map_public_ip_on_launch = true
  tags = { 
    Name = "${var.project_name}-${var.env}-public-2" 
    Environment = var.env 
    Project = var.project_name 
    Tier = "public" }
}
resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_1_cidr
  availability_zone = var.az_1
  tags = { 
    Name = "${var.project_name}-${var.env}-private-1" 
    Environment = var.env 
    Project = var.project_name 
    Tier = "private" }
}
resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_2_cidr
  availability_zone = var.az_2
  tags = { 
    Name = "${var.project_name}-${var.env}-private-2" 
    Environment = var.env 
    Project = var.project_name 
    Tier = "private" }
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = { 
    Name = "${var.project_name}-${var.env}-public-rt" 
    Environment = var.env 
    Project = var.project_name 
    }
}
resource "aws_route" "public_default" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name        = "${var.project_name}-${var.env}-nat-eip"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name        = "${var.project_name}-${var.env}-nat"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.project_name}-${var.env}-private-rt"
    Environment = var.env
    Project     = var.project_name
  }
}

resource "aws_route" "private_default" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}
