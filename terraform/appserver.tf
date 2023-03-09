resource "aws_instance" "appserver" {
  for_each                    = toset(local.availability_zones)

  availability_zone           = each.value
  subnet_id                   = aws_subnet.private[each.value].id
  associate_public_ip_address = false
  ami                         = data.aws_ami.this.id
  instance_type               = var.ec2_instance_type
  user_data                   = data.cloudinit_config.user_data.rendered
  key_name                    = var.appserver_private_ssh_key_name
  vpc_security_group_ids      = [ aws_security_group.appserver.id ]
  monitoring                  = true

  tags = {
    Name        = "demo_appserver"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }

  # Dependency is used to ensure that bastion is ready to pass ansible traffic to appserver
  depends_on = [ aws_instance.bastion ]
}


