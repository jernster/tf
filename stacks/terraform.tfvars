// Remote S3 state
terragrunt = {
  remote_state {
    backend = "s3"

    config {
      bucket         = "ssb-terraform-state"
      key            = "${path_relative_to_include()}.tfstate"
      region         = "us-west-2"
      encrypt        = true
#      dynamodb_table = "TerraformStateLocking"
    }
  }
}

// Local state
//terragrunt = {
//  remote_state {
//    backend = "local"
//
//    config {
//      path            = "${get_tfvars_dir()}/state.tfstate"
//    }
//  }
//}
