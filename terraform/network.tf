# VPC
resource "aws_vpc" "tft_vpc" {
  cidr_block         = var.tft_envmap[var.tft_env].vpc_cidr
  enable_dns_support = true
  tags = {
    "Name" = "tf-tutorial-vpc-${var.tft_env}"
  }
}

# Internet Gateway 
resource "aws_internet_gateway" "tft_igw" {
  vpc_id = aws_vpc.tft_vpc.id
  tags = {
    "Name" = "tf-tutorial-igw-${var.tft_env}"
  }
}

# Subnet (public)  
resource "aws_subnet" "tft_public_subnet" {
  vpc_id                  = aws_vpc.tft_vpc.id
  cidr_block              = var.tft_envmap[var.tft_env].public_subnet_cidr
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    "Name" = "tf-tutorial-public-subnet-${var.tft_env}"
  }
}

resource "aws_route_table" "tft_public_rtb" {
  vpc_id = aws_vpc.tft_vpc.id
  tags = {
    "Name" = "tf-tutorial-public-rtb-${var.tft_env}"
  }
}

resource "aws_route" "tft_public_route" {
  route_table_id         = aws_route_table.tft_public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tft_igw.id
}

resource "aws_route_table_association" "tft_public_rtassoc" {
  subnet_id      = aws_subnet.tft_public_subnet.id
  route_table_id = aws_route_table.tft_public_rtb.id
}

# Subnet (private) 
resource "aws_subnet" "tft_private_subnet" {
  vpc_id                  = aws_vpc.tft_vpc.id
  cidr_block              = var.tft_envmap[var.tft_env].private_subnet_cidr
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
  tags = {
    "Name" = "tf-tutorial-private-subnet-${var.tft_env}"
  }
}

resource "aws_route_table" "tft_private_rtb" {
  vpc_id = aws_vpc.tft_vpc.id
  tags = {
    "Name" = "tf-tutorial-private-rtb-${var.tft_env}"
  }
}

resource "aws_route" "tft_private_route" {
  route_table_id         = aws_route_table.tft_private_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.tft_natgw.id
}

resource "aws_route_table_association" "tft_private_rtassoc" {
  subnet_id      = aws_subnet.tft_private_subnet.id
  route_table_id = aws_route_table.tft_private_rtb.id
}

# NAT Gateway 
resource "aws_nat_gateway" "tft_natgw" {
  allocation_id = aws_eip.tft_natgw_eip.id
  subnet_id     = aws_subnet.tft_public_subnet.id
  tags = {
    "Name" = "tf-tutorial-natgw-${var.tft_env}"
  }
}

# Elastic IP
resource "aws_eip" "tft_natgw_eip" {
  domain = "vpc"
}
