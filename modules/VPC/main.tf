resource "aws_vpc" "main" {
  cidr_block = var.vpc-cidr
  tags = {
    Name        = "${var.environment} webapp vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public-subnet" {
  count             = length(var.vpc-public-subnet)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc-public-subnet[count.index]
  availability_zone = var.vpc-azs[count.index]
  tags = {
    Name = "Public ${var.vpc-azs[count.index]}"
  }
}

resource "aws_subnet" "private-subnet" {
  count             = length(var.vpc-private-subnet)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.vpc-private-subnet[count.index]
  availability_zone = var.vpc-azs[count.index]
  tags = {
    Name = "Private ${var.vpc-azs[count.index]}"
  }
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "WebApp IGW"
    Environment = var.environment
  }
}

resource "aws_eip" "eip" {
  count = var.environment == "Production" ? length(aws_subnet.public-subnet) : 1
  tags = {
    Name        = "${var.environment}-eip"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "public" {
  depends_on = [aws_internet_gateway.main-igw]

  count         = var.environment == "Production" ? length(aws_subnet.public-subnet) : 1
  allocation_id = aws_eip.eip[count.index].id
  subnet_id     = var.environment == "Production" ? aws_subnet.public-subnet[count.index].id : aws_subnet.public-subnet[0].id

  tags = {
    Name        = "${var.environment}-nat-gateway"
    Environment = var.environment
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = var.public-route-table-cidr
    gateway_id = aws_internet_gateway.main-igw.id
  }
  tags = {
    Name = "${var.environment}-public-rt"
  }
}

resource "aws_route_table" "private-route-table" {
  count  = length(var.vpc-private-subnet)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.environment == "Production" ? aws_nat_gateway.public[count.index].id : aws_nat_gateway.public[0].id
  }
  tags = {
    Name = "${var.environment}-private-rt"
  }
}

resource "aws_route_table_association" "public-rt-association" {
  count          = length(aws_subnet.public-subnet)
  subnet_id      = aws_subnet.public-subnet[count.index].id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private-rt-association" {
  count          = length(aws_subnet.private-subnet)
  subnet_id      = aws_subnet.private-subnet[count.index].id
  route_table_id = aws_route_table.private-route-table[count.index].id
}
