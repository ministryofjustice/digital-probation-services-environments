# Hello world sample application in the nDelius stage environment

variable "application_name" {
  default = "ndelius-helloworld"
}

variable "eb_environment_name" {
  default = "ndelius-helloworld-stage"
}

# This resource is shared with multiple environments
resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "${var.application_name}"
  description = "Test of beanstalk deployment"
}

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
  tags        = "${module.tags.tags}"
}

resource "aws_elastic_beanstalk_application_version" "latest" {
  name        = "latest"
  application = "${var.application_name}"
  description = "Version latest of app ${var.application_name}"
  bucket      = "hmpps-probation-artefacts"
  key         = "Dockerrun.aws.json.zip"
}
