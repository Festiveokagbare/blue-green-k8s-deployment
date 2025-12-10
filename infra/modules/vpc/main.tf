########################################
# VPC
########################################
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags       = merge(var.tags, { Name = var.name })
}

########################################
# Internet Gateway
########################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.name}-igw" })
}

########################################
# Public Subnets
########################################
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = merge(var.tags, { Name = "${var.name}-public-${count.index + 1}" })
}

########################################
# Private Subnets
########################################
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = merge(var.tags, { Name = "${var.name}-private-${count.index + 1}" })
}

########################################
# Public Route Table
########################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnets" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

########################################
# NAT Gateway for Private Subnets
########################################
resource "aws_eip" "nat" {
  count = length(var.public_subnets)

  # No "vpc = true" needed here
  tags = merge(var.tags, { Name = "bg-nat-${count.index + 1}" })
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags          = merge(var.tags, { Name = "bg-nat-${count.index + 1}" })
}

########################################
# Private Route Tables
########################################
resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.name}-private-rt-${count.index + 1}" })
}

resource "aws_route" "private_nat" {
  count                   = length(var.private_subnets)
  route_table_id           = aws_route_table.private[count.index].id
  destination_cidr_block   = "0.0.0.0/0"
  nat_gateway_id           = aws_nat_gateway.nat[count.index % length(aws_nat_gateway.nat)].id
}

resource "aws_route_table_association" "private_subnets" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
