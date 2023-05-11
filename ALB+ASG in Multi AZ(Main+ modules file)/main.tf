#main.tf
# Configuring provider
provider "aws" {
  region = var.aws_region
}

# Defining variables
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

# Creating VPC and subnets
module "vpc" {
  source = "./modules/vpc"
}

# Creating ALB and ASG
module "alb_asg" {
  source = "./modules/alb_asg"

  aws_region        = var.aws_region
  alb_name          = var.alb_name
  asg_name          = var.asg_name
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  desired_capacity  = var.desired_capacity
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.vpc.public_subnets
  private_subnets   = module.vpc.private_subnets
}