resource "aws_security_group" "alb" {
  name        = "demo_alb_security_group"
  description = "demo security group for loadbalancer"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name        = "demo_alb_sg"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }

  # Dependency is used to ensure that VPC has an Internet gateway
  depends_on  = [ aws_internet_gateway.this ]
}

resource "aws_security_group" "appserver" {
  name        = "appserver_security_group"
  description = "Demo security group for application server"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name        = "demo_appserver_sg"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }

  # Dependency is used to ensure that VPC has an Internet gateway
  depends_on  = [ aws_internet_gateway.this ]
}

resource "aws_security_group" "database" {
  name        = "database_security_group"
  description = "Demo security group for database"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name        = "demo_database_sg"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }

  # Dependency is used to ensure that VPC has NAT gateways
  depends_on  = [ aws_nat_gateway.this ]
}

resource "aws_security_group" "bastion" {
  name        = "bastion_security_group"
  description = "Demo security group for bastion"
  vpc_id      = aws_vpc.this.id

  tags = {
    Name        = "demo_bastion_sg"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }

  # Dependency is used to ensure that VPC has an Internet gateway
  depends_on  = [ aws_internet_gateway.this ]
}
