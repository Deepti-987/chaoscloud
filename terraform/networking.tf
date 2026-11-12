
resource "aws_vpc" "chaoscloud_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "chaoscloud-vpc"
  }
}

resource "aws_subnet" "chaoscloud_subnet" {
  vpc_id                  = aws_vpc.chaoscloud_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "chaoscloud-public-subnet"
  }
}

resource "aws_internet_gateway" "chaoscloud_igw" {
  vpc_id = aws_vpc.chaoscloud_vpc.id

  tags = {
    Name = "chaoscloud-igw"
  }
}

resource "aws_route_table" "chaoscloud_route_table" {
  vpc_id = aws_vpc.chaoscloud_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.chaoscloud_igw.id
  }

  tags = {
    Name = "chaoscloud-public-route-table"
  }
}

resource "aws_route_table_association" "chaoscloud_route_association" {
  subnet_id      = aws_subnet.chaoscloud_subnet.id
  route_table_id = aws_route_table.chaoscloud_route_table.id
}
