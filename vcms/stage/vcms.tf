# VCMS application in the VCMS stage environment

variable "application_name" {
  default = "vcms"
}

variable "eb_environment_name" {
  default = "vcms-stage"
}

# This resource is shared with multiple environments
resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "${var.application_name}"
  description = "Test of beanstalk deployment"
}

resource "aws_elastic_beanstalk_environment" "eb_environment" {
  name = "${var.eb_environment_name}"
  application = "${var.application_name}"
  solution_stack_name = "64bit Amazon Linux 2017.09 v2.6.6 running PHP 7.1"

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
  tags        = "${module.tags.tags}"
}

resource "aws_elastic_beanstalk_application_version" "latest" {
  name        = "latest"
  application = "${var.application_name}"
  description = "Version latest of app ${var.application_name}"
  bucket      = "hmpps-probation-artefacts"
  key         = "vcms.zip"
  count = 0
}
