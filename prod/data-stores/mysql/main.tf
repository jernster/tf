provider "aws" {
  region = "us-west-2"
}

module "ssb-rds-example" {
  source                 = "../../../modules/data-stores/mysql/"
  db_name                = "ssbdbprod"
  db_password            = "${var.db_password}"
#  db_remote_state_bucket = "ssb-terraform-state"
#  db_remote_state_key    = "prod/data-stores/mysql/terraform.tfstate"
}

terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }

terraform {
  backend "s3" {}
}
