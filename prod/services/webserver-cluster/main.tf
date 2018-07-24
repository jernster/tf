provider "aws" {
  region = "us-west-2"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  cluster_name = "webservers-prod"
  db_remote_state_bucket = "ssb-terraform-state"
  db_remote_state_key = "prod/services/webserver-cluster/terraform.tfstate"
}
