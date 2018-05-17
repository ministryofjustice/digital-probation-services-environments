# Main configuration file for alfresco-non-prod account resources in AWS

terraform {
  backend "s3" {
    bucket = "hmpps-probation-terraform"
    key    = "alfresco-non-prod.terraform.tfstate"
    region = "eu-west-2"
  }
  required_version = "~> 0.11"
}

provider "aws" {
  region  = "eu-west-2"
  version = "~> 1.16"
  assume_role {
    role_arn = "arn:aws:iam::563502482979:role/terraform"
  }
}

locals {
  master_key_name = "alfresco-non-prod-master"
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

resource "aws_kms_key" "non-prod-master" {
  description = "${local.master_key_name}"
  tags       = "${merge(local.tags, map("Name", local.master_key_name))}"
}

resource "aws_kms_alias" "non-prod-master" {
  name          = "alias/${local.master_key_name}"
  target_key_id = "${aws_kms_key.non-prod-master.key_id}"
}
