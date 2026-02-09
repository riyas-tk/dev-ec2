module "sandbox_backend_config" {
  source                 = "../../modules/bootstrap"
  region                 = "us-east-1"
  github_repo            = "riyas-tk/dev-ec2"
  backend_s3_bucket      = "953909302469-sandbox-backend-config-2026"
  backend_dynamodb_table = "riyaz-backend-locker-dynamodb-table-20260122"
}
