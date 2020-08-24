resource "aws_launch_template" "djangocms" {
  name_prefix   = "djangocms"
  image_id      = data.aws_ami.packer_image.id
  instance_type = "t3.medium"
  network_interfaces {
    associate_public_ip_address = true
    subnet_id     = aws_subnet.subnet[0].id
    security_groups = [aws_security_group.djangocms-elb-internal.id]
  }
}

resource "aws_autoscaling_group" "djangocms-ag" {
  vpc_zone_identifier = aws_subnet.subnet.*.id
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  load_balancers     = [aws_elb.elb-django-cms.name]

  launch_template {
    id      = aws_launch_template.djangocms.id
    version = "$Latest"
  }
}

resource "aws_elb" "elb-django-cms" {
  name               = "elb-django-cms"
  subnets            = aws_subnet.subnet.*.id
  security_groups    = [aws_security_group.djangocms-elb.id, aws_security_group.djangocms-elb-internal.id]
  access_logs {
    bucket        = "logs-elb-django-cms"
    interval      = 60
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/en/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "foobar-terraform-elb"
  }
}

resource "aws_security_group" "djangocms-elb" {
  name        = "djangocms-elb"
  description = "Habilita acesso a instance do Terraform"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Port 80 Django CMS"
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

  tags = {
    Name = "django-cms"
  }
}

resource "aws_security_group" "djangocms-elb-internal" {
  name        = "djangocms-elb-internal"
  description = "Habilita acesso do ELB a Instancia do Terraform"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Port 80 Django CMS"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "django-cms"
  }
}

resource "aws_s3_bucket" "lb_logs" {
  bucket = "logs-elb-django-cms"
  force_destroy = true
  acl    = "private"

  tags = {
    Name        = "Bucket Logs"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_policy" "django-bucket" {
  bucket = aws_s3_bucket.lb_logs.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "AWSConsole-AccessLogs-Policy-1597979714689",
    "Statement": [
        {
            "Sid": "AWSConsoleStmt-1597979714689",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::127311923021:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.lb_logs.bucket}/AWSLogs/919315413656/*"
        },
        {
            "Sid": "AWSLogDeliveryWrite",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.lb_logs.bucket}/AWSLogs/919315413656/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        },
        {
            "Sid": "AWSLogDeliveryAclCheck",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.lb_logs.bucket}"
        }
    ]
}
POLICY
}

