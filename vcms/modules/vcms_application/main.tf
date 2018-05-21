# VCMS application in a VCMS environment

# Elastic beanstalk
locals {
  application_name = "vcms"
}

# Database
locals {
  db_root_user_name = "vcms"
}

# Security groups

resource "aws_security_group" "elb" {
  name        = "${local.application_name}-elb"
  vpc_id      = "${var.vpc_id}"
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

  tags = "${merge(var.tags, map("Name", "${local.application_name}_elb"))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ec2" {
  name        = "${local.application_name}-ec2"
  vpc_id      = "${var.vpc_id}"
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

  tags = "${merge(var.tags, map("Name", "${local.application_name}_ec2"))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "db" {
  name        = "${local.application_name}-db"
  vpc_id      = "${var.vpc_id}"
  description = "RDS instances"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ec2.id}"]
  }

  tags = "${merge(var.tags, map("Name", "${local.application_name}_db"))}"

  lifecycle {
    create_before_destroy = true
  }
}

# Elastic beanstalk environments

data "aws_elastic_beanstalk_solution_stack" "php" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux *.* v2.*.* running PHP 7.1$"
}

resource "aws_elastic_beanstalk_environment" "eb_environment" {
  name = "${var.eb_environment_name}"
  application = "${local.application_name}"
  solution_stack_name = "${data.aws_elastic_beanstalk_solution_stack.php.name}"

  # Settings

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${join(",", list(var.private_subnet_a_id, var.private_subnet_b_id))}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${join(",", list(var.public_subnet_a_id, var.public_subnet_b_id))}"
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

  # Application settings

  setting {
    namespace = "aws:elasticbeanstalk:container:php:phpini"
    name      = "document_root"
    value     = "/public"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_DATABASE"
    value     = "${var.db_name}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_HOST"
    value     = "${aws_db_instance.default.address}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_USERNAME"
    value     = "${local.db_root_user_name}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_PASSWORD"
    value     = "${data.aws_ssm_parameter.mariadb-root-password.value}"
  }

  tags        = "${var.tags}"
}

#resource "aws_elastic_beanstalk_application_version" "latest" {
#  name        = "latest"
#  application = "${local.application_name}"
#  description = "Version latest of app ${local.application_name}"
#  bucket      = "hmpps-probation-artefacts"
#  key         = "vcms.zip"
#}

# Database

data "aws_ssm_parameter" "mariadb-root-password" {
  name  = "${var.eb_environment_name}-mariadb-root-password"
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.1.31"
  instance_class       = "db.t2.micro"
  name                 = "${var.db_name}"
  identifier           = "${var.eb_environment_name}"
  username             = "${local.db_root_user_name}"
  password             = "${data.aws_ssm_parameter.mariadb-root-password.value}"
  parameter_group_name = "default.mariadb10.1"
  db_subnet_group_name = "${var.db_subnet_group_name}"
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
}

