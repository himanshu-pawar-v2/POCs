# aws_alb is known as aws_lb. The functionality is identical
resource "aws_lb" "HpALB" {
  name               = "ALB-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "HpALB-tf"
    enabled = true
  }

  tags = {
    Environment = "production"
  }
}