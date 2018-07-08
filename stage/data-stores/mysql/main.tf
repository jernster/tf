provider "aws" {
  region = "us-west-2"
}

resource "aws_db_instance" "ssb-rds-example" {
  engine            = "mysql"
  allocated_storage = 10
  instance_class    = "db.t2.micro"
  name              = "ssbdb"
  username          = "admin"
  password          = "${var.db_password}"

  #snapshot_identifier = "snapshotid"
  skip_final_snapshot = true
}

terraform {
  backend "s3" {
    bucket  = "ssb-terraform-state"
    key     = "stage/data-stores/mysql/terraform.tfstate"
    region  = "us-west-2"
    encrypt = "true"

    #dynamodb_table = "terraform-lock-table"
  }
}
