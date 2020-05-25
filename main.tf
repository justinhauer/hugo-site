# Provider Block
provider "aws" {
  region = "us-east-2"
  version = "~> 2.0"
}
# Backend S3 state
terraform {
  backend "s3" {
    bucket = "tfstates-justin"
    key    = "hugo-site/hugo-components"
    region = "us-east-2"
  }
}

# Enable logging for justinhauer.net, might have to delete some stuff for this
resource "aws_s3_bucket" "log_bucket" {
  bucket = "logging-test.justinhauer.net"
  acl    = "log-delivery-write"
}

 resource "aws_iam_policy" "public_bucket_policy" {
   bucket = aws_s3_bucket.log_bucket.id
   policy = <<POLICY
  {"Version": "2012-10-17",
  "Statement": [{
    "Sid": "PublicReadGetObject",
    "Effect": "Allow",
    "Principal": "*",
    "Action": "s3:GetObject",
    "Resource": "arn:aws:s3:::justin-tf-test-bucket/*"}]}
 POLICY
 }

# Create bucket for static site content justinhauer.net
 resource "aws_s3_bucket" "static_site" {
  bucket = "justin-tf-test-bucket"
  acl    = "public-read"
  policy = aws_iam_policy.public_bucket_policy.id


  # policy = "${file("access-policies/policy.json")}"
  # policy = <<POLICY
  

  # POLICY

  website {
    index_document = "${file("./public/index.html")}"
    error_document = "${file("./public/404.html")}"

  }
  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}

## look into importing the zone?

# ### Route 53 hosted zone

# resource "aws_route53_zone" "primary" {
#   name = "example.com"
# }

# #Route 53 resource record set
# resource "aws_route53_record" "dev-ns" {
#   zone_id = "${aws_route53_zone.main.zone_id}"
#   name    = "dev.example.com"
#   type    = "NS"
#   ttl     = "30"

#   records = [
#     "${aws_route53_zone.dev.name_servers.0}",
#     "${aws_route53_zone.dev.name_servers.1}",
#     "${aws_route53_zone.dev.name_servers.2}",
#     "${aws_route53_zone.dev.name_servers.3}",
#   ]
# }

# manage the A record for this
# resource "aws_route53_record" "www" {
#   zone_id = "${aws_route53_zone.primary.zone_id}"
#   name    = "example.com"
#   type    = "A"

#   alias {
#     name                   = "${aws_elb.main.dns_name}"
#     zone_id                = "${aws_elb.main.zone_id}"
#     evaluate_target_health = true
#   }
# }

# manage the cname

# resource "aws_route53_record" "www-live" {
#   zone_id = "${aws_route53_zone.primary.zone_id}"
#   name    = "www"
#   type    = "CNAME"
#   ttl     = "5"

#   set_identifier = "live"
#   records        = ["live.example.com"]
# }
