# Main configuration file for vcms-non-prod account resources in AWS

terraform {
  backend "s3" {
    bucket = "hmpps-probation-terraform"
    key    = "vcms-non-prod.terraform.tfstate"
    region = "eu-west-2"
  }
  required_version = "~> 0.11"
}

provider "aws" {
  region  = "eu-west-2"
  version = "~> 1.16"
  assume_role {
    role_arn = "arn:aws:iam::356676313489:role/terraform"
  }
}

# Tags
locals {
  tags = {
    owner = "Digital Studio",
    environment-name = "N/A",
    application = "N/A"
    is-production = "false",
    business-unit = "HMPPS",
    infrastructure-support = "Digital Studio"
  }
}

module "master_key" {
  source = "../modules/encryption_key"
  key_name = "master"
  tags = "${local.tags}"
}

module "admin_role" {
  source = "../modules/admin_role"
}

# Elastic beanstalk applications - shared between environments

resource "aws_elastic_beanstalk_application" "vcms" {
  name        = "vcms"
  description = "VCMS application"
}

module "beanstalk_roles" {
  source = "../modules/beanstalk_roles"
}

# CI policy and group

locals {
  group_name = "CI"
}

resource "aws_iam_group" "ci" {
  name = "${local.group_name}"
}

data "aws_iam_policy" "beanstalk" {
  arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkFullAccess"
}

resource "aws_iam_group_policy_attachment" "beanstalk" {
  group      = "${local.group_name}"
  policy_arn = "${data.aws_iam_policy.beanstalk.arn}"
  depends_on = ["aws_iam_group.ci"]
}

