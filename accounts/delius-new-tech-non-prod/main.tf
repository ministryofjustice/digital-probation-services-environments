# Main configuration file for alfresco-non-prod account resources in AWS

terraform {
  backend "s3" {
    bucket = "hmpps-probation-terraform"
    key    = "delius-new-tech-non-prod.terraform.tfstate"
    region = "eu-west-2"
  }
  required_version = "~> 0.11"
}

provider "aws" {
  region  = "eu-west-2"
  version = "~> 1.16"
  assume_role {
    role_arn = "arn:aws:iam::301496033642:role/terraform"
  }
}

locals {
  master_key_name = "delius-new-tech-non-prod-master"
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
