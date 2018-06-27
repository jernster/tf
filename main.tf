provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "ssb_test" {
  #ami                    = "ami-e251209a" # Amazon Linux 2018.03.0
  ami                    = "ami-db710fa3"                        #Ubuntu 16.04 
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  #user_data = <<-EOF
  #            #!/bin/sh
  #            yum install httpd
  #            chkconfig httpd on
  #            echo "Hello, Apache" > /var/www/html/index.html
  #            service httpd start
  #            EOF
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags {
    Name = "ssb-terraform-example"
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

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  default     = 8080
}

output "public_ip" {
  value = "${aws_instance.ssb_test.public_ip}"
}
