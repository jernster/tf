output "elb_dns_name" {
  value = "${aws_elb.elb_example.dns_name}"
}

#output "db_address" {
# value = "${aws_db_instance.ssb-rds-example.db_address}"
#}
  
#output "db_port" {
#  value = "${aws_db_instance.ssb-rds-example.db_port}"
#}
