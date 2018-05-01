# Main configuration file for Digital Probation Services environments in AWS

terraform {
  backend "s3" {
    bucket = "digital-probation-services-terraform"
    key    = "digital-probation-services-environments.terraform.tfstate"
    region = "eu-west-2"
  }
  required_version = "~> 0.11"
}

provider "aws" {
  region  = "eu-west-2"
  version = "~> 1.16"
}

# Networking

module "networks" {
  source = "modules/networks"
}

# S3 bucket for application version files

# Dev environment for the Delius Offender API

module "dev_offender_api" {
  source     = "modules/environment_templates/delius-offender-api-devtest"
  vpc_id     = "${module.networks.vpc_id}"
  eb_subnets = [
    "${module.networks.application_public_application_subnet_1_id}",
    "${module.networks.application_public_application_subnet_2_id}"
  ]
}
