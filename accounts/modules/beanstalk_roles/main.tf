# EC2

resource "aws_iam_role" "ec2" {
  name               = "aws-elasticbeanstalk-ec2-role"
  description        = "Allows EC2 instances to call AWS services on your behalf."
  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy" "web-tier" {
  arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "web-tier" {
  role       = "${aws_iam_role.ec2.name}"
  policy_arn = "${data.aws_iam_policy.web-tier.arn}"
}

data "aws_iam_policy" "multicontainer-docker" {
  arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_role_policy_attachment" "multicontainer-docker" {
  role       = "${aws_iam_role.ec2.name}"
  policy_arn = "${data.aws_iam_policy.multicontainer-docker.arn}"
}

data "aws_iam_policy" "worker-tier" {
  arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_role_policy_attachment" "worker-tier" {
  role       = "${aws_iam_role.ec2.name}"
  policy_arn = "${data.aws_iam_policy.worker-tier.arn}"
}

# Service

resource "aws_iam_role" "service" {
  name = "aws-elasticbeanstalk-service-role"
  description = "Allows Elastic Beanstalk to create and manage AWS resources on your behalf."
  assume_role_policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "elasticbeanstalk"
        }
      }
    }
  ]
}
EOF
}

data "aws_iam_policy" "enhanced-health" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "enhanced-health" {
  role       = "${aws_iam_role.service.name}"
  policy_arn = "${data.aws_iam_policy.enhanced-health.arn}"
}

data "aws_iam_policy" "service" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkService"
}

resource "aws_iam_role_policy_attachment" "service" {
  role       = "${aws_iam_role.service.name}"
  policy_arn = "${data.aws_iam_policy.service.arn}"
}

