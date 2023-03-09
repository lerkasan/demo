resource "aws_ssm_parameter" "database_host" {
  name        = "demo_database_host"
  description = "Demo database host"
  type        = "SecureString"
  key_id      = aws_kms_key.ssm_param_encrypt_key.id
  value       = aws_db_instance.primary.address

  tags = {
    Name        = "demo_database_host"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_ssm_parameter" "database_name" {
  name        = "demo_database_name"
  description = "Demo database name"
  type        = "SecureString"
  key_id      = aws_kms_key.ssm_param_encrypt_key.id
  value       = var.database_name

  tags = {
    Name        = "demo_database_name"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_ssm_parameter" "database_username" {
  name        = "demo_database_username"
  description = "Demo database username"
  type        = "SecureString"
  key_id      = aws_kms_key.ssm_param_encrypt_key.id
  value       = var.database_username

  tags = {
    Name        = "demo_database_username"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_ssm_parameter" "database_password" {
  name        = "demo_database_password"
  description = "Demo database password"
  type        = "SecureString"
  key_id      = aws_kms_key.ssm_param_encrypt_key.id
  value       = var.database_password

  tags = {
    Name        = "demo_database_password"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}
