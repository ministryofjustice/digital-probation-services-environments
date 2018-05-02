# Main configuration file for Digital Probation Services environments in AWS

terraform {
  backend "s3" {
    bucket = "digital-probation-services-terraform"
    key    = "vcms.stage.terraform.tfstate"
    region = "eu-west-2"
  }
  required_version = "~> 0.11"
}

provider "aws" {
  region  = "eu-west-2"
  version = "~> 1.16"
}

module "tags" {
  source = "modules/tags"
}

module "constants" {
  source = "modules/constants"
}

# Template for a dev/test environment for VCMS

resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "${module.constants.application_name}"
  description = "Test of beanstalk deployment"
}

resource "aws_elastic_beanstalk_environment" "eb_environment" {
  name = "${module.constants.environment_name}"
  application = "${module.constants.application_name}"
  solution_stack_name = "64bit Amazon Linux 2017.09 v2.6.6 running PHP 7.1"

  # Settings

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${aws_vpc.digital-probation-services.id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${join(",", list(aws_subnet.application_public_1.id, aws_subnet.application_public_2.id))}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
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
}

resource "aws_elastic_beanstalk_application_version" "latest" {
  name        = "latest"
  application = "${module.constants.application_name}"
  description = "Version latest of app ${module.constants.application_name}"
  bucket      = "digital-probation-services-applications"
  key         = "vcms.zip"
}
