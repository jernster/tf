variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
}

variable "db_remote_state_bucket" {
  description = "The S3 bucket used for the database's remote state"
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  default     = "infrastructure/data-stores/aws/rds/prod.tfstate"
}

#variable "db_address" {
#  value = "${aws_db_instance.ssb-rds-example.address}"
#}

#variable "db_port" {
#  value = "${aws_db_instance.ssb-rds-example.port}"
# }
