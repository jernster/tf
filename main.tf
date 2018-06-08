provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "ssb_test" {
  ami           = "ami-e251209a"
  instance_type = "t2.micro"

  tags {
    Name = "ssb-terraform-example"
  }
}
