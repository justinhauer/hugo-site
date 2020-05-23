provider "aws" {
  # ... other configuration ...
  region = "us-east-2"
  version = "~> 2.0"
  access_key = "AWS_ACCESS_KEY_ID"
  secret_key = "AWS_SECRET_ACCESS_KEY"
}

terraform {
  backend "s3" {
    bucket = "tfstates-justin"
    key    = "hugo-site/hugo-components"
    region = "AWS_DEFAULT_REGION"
  }
}

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-jhauer1"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

# Create bucket for static site content justinhauer.net
#  resource "aws_s3_bucket" "static_site" {
#   bucket = "tf-test-bucket"
#   acl    = "public-read"
#   policy = "file("access-policies/policy.json")"

#   website {
#     index_document = "index.html"
#     error_document = "error.html"

#     routing_rules = <<EOF
# [{
#     "Condition": {
#         "KeyPrefixEquals": "docs/"
#     },
#     "Redirect": {
#         "ReplaceKeyPrefixWith": "documents/"
#     }
# }]
# EOF
  # }
# }


# #Create bucket for static site content www.justinhauer.net
#  resource "aws_s3_bucket" "static_site" {
#   bucket = "s3-website-test.hashicorp.com"
#   acl    = "public-read"
#   policy = "${file("policy.json")}"

#   website {
#     index_document = "index.html"
#     error_document = "error.html"

#     routing_rules = <<EOF
# [{
#     "Condition": {
#         "KeyPrefixEquals": "docs/"
#     },
#     "Redirect": {
#         "ReplaceKeyPrefixWith": "documents/"
#     }
# }]
# EOF
#   }
# }

# enable logging for justinhauer.net, might have to delete some stuff for this
# resource "aws_s3_bucket" "log_bucket" {
#   bucket = "my-tf-log-bucket"
#   acl    = "log-delivery-write"
# }

# resource "aws_s3_bucket" "b" {
#   bucket = "my-tf-test-bucket"
#   acl    = "private"

#   logging {
#     target_bucket = "${aws_s3_bucket.log_bucket.id}"
#     target_prefix = "log/"
#   }
# }

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
