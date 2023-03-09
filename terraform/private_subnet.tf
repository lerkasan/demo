resource "aws_subnet" "private" {
  for_each                = toset(local.availability_zones)

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.value
  cidr_block              = var.private_subnets[index(local.availability_zones, each.value)]
// CIDR can also be generated automatically without subnet variables
// cidr_block             = format("10.0.%s.0/24", format("%d", 250 - index(local.availability_zones, each.value)))

  tags = {
    Name        = "demo_private_subnet"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_route_table" "private" {
  for_each     = aws_nat_gateway.this

  vpc_id       = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = each.value.id
  }

  tags = {
    Name        = "demo_private_rt"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}
