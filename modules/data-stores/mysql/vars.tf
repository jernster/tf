variable "db_password" {
  description = "The password for the database"
}

variable "db_name" {
  description = "The name for the database"
}

variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
}
