resource "aws_lb" "app" {
  name               = "demo-webapp-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [ aws_security_group.alb.id ]
  subnets            = [ for subnet in aws_subnet.public : subnet.id ]
//enable_deletion_protection = true

  tags = {
    Name        = "demo_app_alb"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_lb_target_group" "app" {
  port     = var.http_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id

  health_check {
    healthy_threshold   = 5
    interval            = 60
    matcher              = "200"
    path                = "/"
    protocol            = "HTTP"
    timeout             = 10
    unhealthy_threshold = 4
  }

  tags = {
    Name        = "demo_app_tg"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_lb_target_group_attachment" "app" {
  for_each         = toset(local.availability_zones)

  target_group_arn = aws_lb_target_group.app.arn
  target_id        = aws_instance.appserver[each.value].id
  port             = var.http_port
}

resource "aws_lb_listener" "app" {
  load_balancer_arn = aws_lb.app.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  tags = {
    Name        = "demo_app_lb_listener"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}
