provider "aws" {
  region = "us-east-1"
}

resource "aws_launch_configuration" "example" {
  image_id = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.example.id}"]
}

resource "aws_security_group" "example" {
  name = "example"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "example" {
  name = "example"
  launch_configuration = aws_launch_configuration.example.id
  min_size = 1
  max_size = 3
  desired_capacity = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
  vpc_zone_identifier = ["${aws_subnet.example.id}"]
}

resource "aws_subnet" "example" {
  vpc_id = "${aws_vpc.example.id}"
  cidr_block = "10.0.1.0/24"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

