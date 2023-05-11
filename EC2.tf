provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key-pair" #required key pair
  subnet_id     = "subnet-0c5c5028378e27c61"
  tags = {
    Name = "HpEC2"
  }
}