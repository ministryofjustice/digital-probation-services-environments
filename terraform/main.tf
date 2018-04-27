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

