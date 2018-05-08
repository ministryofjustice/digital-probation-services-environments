# Hello world sample application in the nDelius stage environment

variable "application_name" {
  default = "ndelius-helloworld"
}

variable "eb_environment_name" {
  default = "ndelius-helloworld-stage"
}

# Security groups

resource "aws_security_group" "elb" {
  name        = "${var.application_name}-elb"
  vpc_id      = "${aws_vpc.vpc.id}"
  description = "ELB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(module.tags.tags, map("Name", "${var.application_name}_elb"))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ec2" {
  name        = "${var.application_name}-ec2"
  vpc_id      = "${aws_vpc.vpc.id}"
  description = "elasticbeanstalk EC2 instances"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.elb.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(module.tags.tags, map("Name", "${var.application_name}_ec2"))}"

  lifecycle {
    create_before_destroy = true
  }
}

# Elastic beanstalk environments

# This resource is shared with multiple environments
resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "${var.application_name}"
  description = "Test of beanstalk deployment"
}

# Stage environment

resource "aws_elastic_beanstalk_environment" "eb_environment" {
  name = "${var.eb_environment_name}"
  application = "${var.application_name}"
  solution_stack_name = "64bit Amazon Linux 2017.09 v2.9.2 running Docker 17.12.0-ce"

  # Settings

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${aws_vpc.vpc.id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${join(",", list(aws_subnet.private_a.id, aws_subnet.private_b.id))}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${join(",", list(aws_subnet.public_a.id, aws_subnet.public_b.id))}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "false"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = "aws-elasticbeanstalk-service-role"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "${aws_security_group.ec2.id}"
  }
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "ManagedSecurityGroup"
    value     = "${aws_security_group.elb.id}"
  }
  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "SecurityGroups"
    value     = "${aws_security_group.elb.id}"
  }
  tags        = "${module.tags.tags}"
}

resource "aws_elastic_beanstalk_application_version" "latest" {
  name        = "latest"
  application = "${var.application_name}"
  description = "Version latest of app ${var.application_name}"
  bucket      = "hmpps-probation-artefacts"
  key         = "Dockerrun.aws.json.zip"
}
