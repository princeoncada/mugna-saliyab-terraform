terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1" # choose your AWS region
}

# Create an S3 bucket for your React app.
resource "aws_s3_bucket" "react_app_bucket" {
  # TODO: change this one to your unique bucket name
  bucket = "www.local.pgsoncada.com" # must be globally unique
  # This makes sure the bucket is deleted when you run `terraform destroy`
  force_destroy = true
}

resource "aws_s3_bucket_website_configuration" "name" {
  bucket = aws_s3_bucket.react_app_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }

}

resource "aws_s3_bucket_public_access_block" "bucket_pub_access" {
  bucket                  = aws_s3_bucket.react_app_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "react_app_policy" {
  bucket = aws_s3_bucket.react_app_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "AllowGetObjects"
    Statement = [
      {
        Sid       = "AllowPublic",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.react_app_bucket.arn}/*"
      }
    ]
  })
  depends_on = [ aws_s3_bucket_public_access_block.bucket_pub_access ]
}

# Create a CloudFront Distribution to serve your site.
resource "aws_cloudfront_distribution" "react_app_cdn" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    # We use the S3 bucket website endpoint; this bucket must be public.
    domain_name = aws_s3_bucket_website_configuration.name.website_endpoint
    origin_id   = "${aws_s3_bucket.react_app_bucket.bucket}-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "${aws_s3_bucket.react_app_bucket.bucket}-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.react_app_cdn.domain_name
  description = "Domain name of the Cloudfront Distribution with your react app"
}

output "bucket_name" {
  value       = aws_s3_bucket.react_app_bucket.bucket
  description = "S3 bucket name"
}
