provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "tf-state-snake"
    key    = "tfstate/"
    region = "us-east-1"
  }
}

resource "aws_security_group" "snake" {
  name        = "snake"
  description = "snake server security group"

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "UI access"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "gameserver access"
    from_port   = 1337
    to_port     = 1337
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
    Name = "snake"
  }
}

resource "aws_instance" "snake_server" {
  ami               = "ami-0e9089763828757e1"
  instance_type     = "t2.small"
  key_name          = "snake_server"
  user_data         =  file("./user_data/install_snake.sh")
  security_groups   = [aws_security_group.snake.name]

  tags              = {
      Name = "Game Server"
  }

}

resource "aws_eip" "bar" {
  vpc = true
  instance          = aws_instance.snake_server.id
}