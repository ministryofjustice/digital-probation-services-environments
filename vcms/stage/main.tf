# Main configuration file for VCMS stage environment in AWS

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

