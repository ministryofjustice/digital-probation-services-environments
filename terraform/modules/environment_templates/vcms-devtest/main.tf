# Template for a dev/test environment for VCMS

resource "aws_elastic_beanstalk_application" "test_app" {
  name        = "vcms"
  description = "Test of beanstalk deployment"
  count = 1
}

resource "aws_elastic_beanstalk_environment" "test_env" {
  name = "${aws_elastic_beanstalk_application.test_app.name}-env"
  application = "${aws_elastic_beanstalk_application.test_app.name}"
  solution_stack_name = "64bit Amazon Linux 2017.09 v2.6.6 running PHP 7.1"

  # Settings

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${join(",", var.eb_subnets)}"
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

  count = 1
}

resource "aws_elastic_beanstalk_application_version" "latest" {
  name        = "latest"
  application = "${aws_elastic_beanstalk_application.test_app.name}"
  description = "Version latest of app ${aws_elastic_beanstalk_application.test_app.name}"
  bucket      = "digital-probation-services-applications"
  key         = "vcms.zip"
}
