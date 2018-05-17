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

locals {
  master_key_name = "vcms-non-prod-master"
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

resource "aws_kms_key" "vcms-non-prod-master" {
  description = "${local.master_key_name}"
  tags       = "${merge(local.tags, map("Name", local.master_key_name))}"
}

resource "aws_kms_alias" "vcms-non-prod-master" {
  name          = "alias/${local.master_key_name}"
  target_key_id = "${aws_kms_key.vcms-non-prod-master.key_id}"
}
