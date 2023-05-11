# Set the AWS region and credentials
provider "aws" {
  region = "us-west-2"
}

# Create a new MySQL RDS instance
#
resource "aws_db_instance" "example" {
  engine           = "mysql"
  instance_class   = "db.t2.micro"
  allocated_storage = 10

  # Set the username and password for the master user
  master_username = "admin"
  master_password = "password123"

  # Specify the database name
  name = "mydatabase"

  # Use the default VPC and subnet group
  vpc_security_group_ids = [aws_security_group.example.id]
  db_subnet_group_name   = aws_db_subnet_group.example.name

  # Set the backup retention period and preferred maintenance window
  backup_retention_period = 7
  preferred_maintenance_window = "Mon:03:00-Mon:04:00"

  # Enable automatic backups and monitoring
  skip_final_snapshot         = true
  monitoring_interval         = 60
  monitoring_role_arn         = aws_iam_role.example.arn
  enable_performance_insights = true

  # Enable encryption at rest
  storage_encrypted = true
  kms_key_id        = aws_kms_key.example.arn
}

# Create a new security group for the RDS instance
resource "aws_security_group" "example" {
  name_prefix = "rds-"
  ingress {
    from_port   = 0
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a new subnet group for the RDS instance
resource "aws_db_subnet_group" "example" {
  name       = "my-subnet-group"
  subnet_ids = [aws_subnet.example.id]
}

# Create a new IAM role for RDS monitoring
resource "aws_iam_role" "example" {
  name = "rds-monitoring-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

# Create a new KMS key for RDS encryption
resource "aws_kms_key" "example" {
  description = "RDS encryption key"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ]
        Resource = "*"
      },
      {
        Sid = "Allow access to RDS encryption key"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = "*"
      }
    ]
  })
}
``
