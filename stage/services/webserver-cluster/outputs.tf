output "elb_dns_name" {
  value = "${aws_elb.elb_example.dns_name}"
}
