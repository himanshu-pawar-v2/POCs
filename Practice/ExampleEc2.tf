provider "aws" {
    region = "ap-south-1"
    access_key = "AKIA5P4WOTANSQIKOUP3"
    secret_key = "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"
    version = "~> 2.0"
}

resource "aws_instance" "web1" {
    ami = "ami-0376ec8eacdf70aae"
    instance_type = "t2.micro"
}