resource "aws_instance" "nginx-webapp" {
  count                  = 2
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance-type
  subnet_id              = var.private-subnet-id[count.index]
  vpc_security_group_ids = [aws_security_group.webapp-alb-sg.id]
  key_name               = var.key-name

  user_data = <<EOT
  #!/bin/bash
  sudo yum update -y
  sudo yum install nginx -y
  sudo service nginx start
  sudo chkconfig nginx on
  echo "Nginx is now installed and running"
  EOT

  tags = {
    Name = "{var.environment}-webapp-instance-${count.index}"
  }
}

data "aws_ami" "amzlinux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_security_group" "webapp-alb-sg" {
  name        = "${var.environment}-webapp-alb-sg"
  description = "Allow HTTP in and everything out"
  vpc_id      = var.vpc-id

  ingress {
    description = "Allow HTTP in"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Everything out"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "webapp-alb" {
  name               = "${var.environment}webapp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webapp-alb-sg.id]
  subnets            = var.public-subnet
}

resource "aws_lb_listener" "webapp-alb-listener" {
  load_balancer_arn = aws_lb.webapp-alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp-alb-target-group.arn
  }

  tags = {
    Name = "${var.environment}-WebApp-ALB-Listener"
  }
}

resource "aws_lb_target_group" "webapp-alb-target-group" {
  name     = "${var.environment}webapp-alb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  health_check {
    path    = "/"
    matcher = 200
  }
}

resource "aws_lb_target_group_attachment" "webapp-alb-target-group-attachment" {
  count            = 2
  target_group_arn = aws_lb_target_group.webapp-alb-target-group.arn
  target_id        = aws_instance.nginx-webapp[count.index].id
  port             = 80
}
