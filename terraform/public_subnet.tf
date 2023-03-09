resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"

  tags = {
    Name        = "demo_vpc"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_subnet" "public" {
  for_each = toset(local.availability_zones)

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value
  cidr_block              = var.public_subnets[index(local.availability_zones, each.value)]
// CIDR can also be generated automatically without subnet variables
// cidr_block             = format("10.0.%s.0/24", index(local.availability_zones, each.value))
  map_public_ip_on_launch = true

  tags = {
    Name        = "demo_public_subnet"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name        = "demo_ig"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name        = "demo_public_rt"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_route_table_association" "public" {
  for_each        = aws_subnet.public

  subnet_id       = each.value.id
  route_table_id  = aws_route_table.public.id
}

resource "aws_eip" "this" {
  for_each   = aws_subnet.public

  vpc        = true

  tags = {
    Name        = "demo_nat_gw_eip"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }

  # Dependency is used to ensure that VPC has an Internet gateway
  depends_on = [ aws_internet_gateway.this ]
}

resource "aws_nat_gateway" "this" {
  for_each          = aws_subnet.public

  connectivity_type = "public"
  subnet_id         = aws_subnet.public[each.key].id
  allocation_id     = aws_eip.this[each.key].id

  tags = {
    Name        = "demo_nat_gw"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }

  # Dependency is used to ensure that VPC has an Internet gateway
  depends_on = [aws_internet_gateway.this]
}

