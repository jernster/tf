provider "aws" {
  region = "us-west-2"
}

resource "aws_launch_template" "ssb_example" {
  image_id      = "ami-db710fa3" #Ubuntu 16.04 
  instance_type = "t2.micro"
  name          = "ssb_example"

  #security_groups = ["${aws_security_group.instance.id}"]
  security_group_names = ["${aws_security_group.instance.name}"]

  #vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  user_data = "${base64encode(data.template_file.user_data.rendered)}"

  #name_prefix     = "test-tf-example-"


  #key_name = "jernster.pem"

  # template_file deprecated but data.template_file doesn't work either...
  #user_data = "${template_file.user_data.rendered}"
  lifecycle {
    create_before_destroy = true
  }
}

# Warning: template_file.user_data: using template_file as a resource is deprecated; consider using the data source instead
#resource "template_file" "user_data" {
data "template_file" "user_data" {
  template = "${file("user-data.sh")}"

  vars {
    server_port = "${var.server_port}"
    db_address  = "${data.terraform_remote_state.db.address}"
    db_port     = "${data.terraform_remote_state.db.port}"
  }
}

resource "aws_security_group" "instance" {
  name = "ssb-example-instance"

  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#variable "server_port" {
#  description = "The port the server will use for HTTP requests"
#  default     = 8080
#}

#output "elb_dns_name" {
#  value = "${aws_elb.elb_example.dns_name}"
#}

resource "aws_autoscaling_group" "asg_example" {
  name                 = "terraform-asg-example"
  launch_configuration = "${aws_launch_template.ssb_example.name}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]

  load_balancers    = ["${aws_elb.elb_example.name}"]
  health_check_type = "ELB"

  min_size = 2
  max_size = 10

  tags {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

data "aws_availability_zones" "all" {}

resource "aws_elb" "elb_example" {
  name               = "terraform-asg-example"
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
  name = "terraform-example-elb"

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

data "terraform_remote_state" "db" {
  backend = "s3"

  config {
    bucket = "ssb-terraform-state"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-west-2"
  }
}
