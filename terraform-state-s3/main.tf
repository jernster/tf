provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "terraform-state" {
  bucket = "ssb-terraform-state"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

output "s3_bucket_arn" {
  value = "${aws_s3_bucket.terraform-state.arn}"
}

terraform {
  backend "s3" {
    bucket         = "ssb-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = "true"
    dynamodb_table = "terraform-lock-table"
  }
}
