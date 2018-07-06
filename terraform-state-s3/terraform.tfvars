#### To be continued.  Not functional at this time.

terragrunt = {
  remote_state {
    backend = "s3"

    config {
      bucket         = "ssb-terraform-state"
      key            = "global/s3/terraform.tfstate"
      region         = "us-west-2"
      encrypt        = true
      dynamodb_table = "terraform-lock-table"

      state_file_id  = "global/s3"

      #s3_bucket_tags {
      #  owner = "terragrunt integration test"
      #  name  = "Terraform state storage"
      #}

      #dynamodb_table_tags {
      # owner = "terragrunt integration test"
      #  name  = "Terraform lock table"
      #}
    }
  }
}
