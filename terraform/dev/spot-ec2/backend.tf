terraform {
  backend "s3" {
    bucket = "us-east-1-953909302469-sandbox-backend-config-2026"
    key    = "mysandbox/spot_ec2.state"
    region = "us-east-1"
  }
}