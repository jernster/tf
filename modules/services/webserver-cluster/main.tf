resource "aws_launch_configuration" "ssb_example" {
  image_id        = "ami-db710fa3"                             #Ubuntu 16.04 
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]
  key_name        = "ssb-jernster"
  user_data       = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = "${file("~/projects/terraform/mycode/tf/modules/services/webserver-cluster/user-data.sh")}"

  vars {
    server_port = "${var.server_port}"
    db_address  = "${data.terraform_remote_state.db.address}"
    db_port     = "${data.terraform_remote_state.db.port}"
  }
}

resource "aws_security_group" "instance" {
  #name = "ssb-example-instance"
  name = "${var.cluster_name}-instance"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_autoscaling_group" "asg_example" {
  #name                 = "terraform-asg-example"
  launch_configuration = "${aws_launch_configuration.ssb_example.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]

  load_balancers    = ["${aws_elb.elb_example.name}"]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tags {
    key                 = "Name"
    value               = "${var.cluster_name}-instance"
    propagate_at_launch = true
  }
}

data "aws_availability_zones" "all" {}

resource "aws_elb" "elb_example" {
  name               = "${var.cluster_name}-elb"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups    = ["${aws_security_group.elb.id}"]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:${var.server_port}/"
  }
}

resource "aws_security_group" "elb" {
  #name = "terraform-example-elb"
  name = "${var.cluster_name}-elb"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#data "terraform_remote_state" "db" {
#  backend = "s3"

#  config {
#    bucket = "ssb-terraform-state"
#    key    = "stage/data-stores/mysql/terraform.tfstate"
#    region = "us-west-2"
#  }
#}

#terraform {
#  backend "s3" {
#    #bucket  = "ssb-terraform-state"
#    bucket = "${var.db_remote_state_bucket}"
#
    #key     = "stage/services/webserver-cluster/terraform.tfstate"
#    key     = "${var.db_remote_state_key}"
#    region  = "us-west-2"
#    encrypt = "true"
#  }
#}

#data "terraform_remote_state" "webserver-cluster" {
#  backend = "s3"
#
#  config {
#    #bucket = "ssb-terraform-state"
#    bucket = "${var.db_remote_state_bucket}"
#
#    #key    = "stage/services/webserver-cluster/terraform.tfstate"
#    key    = "${var.db_remote_state_key}"
#    region = "us-west-2"
#  }
#}

terragrunt = {
  include {
    path = "${find_in_parent_folders()}"
  }
