provider "aws" {
  region = "us-east-1" # Change this to the appropriate region
}

resource "aws_s3_bucket" "static_site" {
  bucket = "example.com" # Change this to your desired bucket name
  acl    = "private"     # Make the bucket private
  website {
    index_document = "index.html" # Change this to your desired index file name
    error_document = "error.html" # Change this to your desired error file name
  }
}

resource "aws_s3_bucket_policy" "static_site_policy" {
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action = [
          "s3:GetObject"
        ],
        Resource = [
          "${aws_s3_bucket.static_site.arn}/*"
        ],
        Condition = {
          StringEquals = {
            "aws:Referer": "${aws:SourceIp}"
          }
        }
      }
    ]
  })
}

output "s3_bucket_name" {
  value = aws_s3_bucket.static_site.bucket
}
