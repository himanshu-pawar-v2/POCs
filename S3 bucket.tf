provider "aws" {
  region = "us-east-1" # Change this to the appropriate region
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-123" # Change this to your desired bucket name
  acl    = "private"           # Change this to your desired ACL, default is private
}

output "s3_bucket_name" {
  value = aws_s3_bucket.example_bucket.bucket
}
