#terraform script to create a application load balancer with auto scaling group with Amazon 
#linux in multiple availability

# Define variables
variable "aws_region" {
  default = "us-east-1"
}

variable "alb_name" {
  default = "my-alb"
}

variable "asg_name" {
  default = "my-asg"
}

variable "ami_id" {
  default = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI ID in us-east-1
}

variable "instance_type" {
  default = "t2.micro"
}

variable "desired_capacity" {
  default = 2
}

# provider
provider "aws" {
  region = var.aws_region
}

#security group for ALB
resource "aws_security_group" "alb_sg" {
  name_prefix = "alb-sg-"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create ALB
resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.private.*.id
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name = var.alb_name
  }
}

# Create target group for ASG
resource "aws_lb_target_group" "asg_tg" {
  name_prefix = "asg-tg-"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
  }
}

# Create listener for ALB
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_tg.arn
  }
}

# Create launch configuration for ASG
resource "aws_launch_configuration" "asg_lc" {
  name_prefix          = "asg-lc-"
  image_id             = var.ami_id
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.asg_sg.id]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > /var/www/html/index.html
              EOF
}

# Create ASG
resource "aws_autoscaling_group" "asg" {
  name                      = var.asg_name
  vpc_zone_identifier       = aws_subnet.private.*.id
  target_group_arns         = [aws_lb_target_group.asg_tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300
  desired_capacity          = var
}