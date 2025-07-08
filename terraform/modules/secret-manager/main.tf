resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "aws_secretsmanager_secret" "rds_secret" {
  name        = "rds-db-credentials"
  description = "Credentials for RDS MySQL database"
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = "dbuser"
    password = random_password.db_password.result
  })
}

output username {
  value = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string)["username"]
}
output username {
  value = jsondecode(aws_secretsmanager_secret_version.rds_secret_version.secret_string)["password"]
}
output rds_secret_arm{
  value = aws_secretsmanager_secret.rds_secret.arn
}
