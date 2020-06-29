provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "tf-state-jenkins"
    key    = "tfstate/"
    region = "us-east-1"
  }
}

resource "aws_security_group" "jenkins_ingress" {
  name        = "jenkins_ingress"
  description = "Build server ingress traffic"

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "admin_access"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins_ingress"
  }
}

resource "aws_instance" "jenkins" {
  ami               = "ami-0e9089763828757e1"
  instance_type     = "t2.small"
  key_name          = "jenkins"
  user_data         =  file("./user_data/install_jenkins.sh")
  security_groups   = [aws_security_group.jenkins_ingress.name]

  tags          = {
      Name = "Build Server"
  }

}