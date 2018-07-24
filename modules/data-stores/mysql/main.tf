resource "aws_db_instance" "ssb-rds-example" {
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "${var.db_name}"
  username          = "admin"
  password          = "${var.db_password}"

  skip_final_snapshot = true
}

#terraform {
#  backend "s3" {
#    bucket  = "${var.db_remote_state_bucket}"
#    key     = "${var.db_remote_state_key}"
#    region  = "us-west-2"
#    encrypt = "true"
#  }
#}

#data "terraform_remote_state" "webserver-cluster" {
#  backend = "s3"

#  config {
#    #bucket = "ssb-terraform-state"
#    bucket = "${var.db_remote_state_bucket}"
#
#    #key    = "stage/services/webserver-cluster/terraform.tfstate"
#    key    = "${var.db_remote_state_key}"
#    region = "us-west-2"
#  }
#}

#terragrunt = {
#  include {
#    path = "${find_in_parent_folders()}"
#  }

terraform {
  backend "s3" {}
}
