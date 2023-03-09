resource "aws_kms_key" "database_encrypt_key" {
  description             = "A key to encrypt database"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name        = "demo_database_encrypt_key"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}

resource "aws_kms_key" "ssm_param_encrypt_key" {
  description             = "A key to encrypt SSM parameters"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags = {
    Name        = "demo_ssm_param_encrypt_key"
    terraform   = "true"
    environment = var.environment
    project     = var.project_name
  }
}
