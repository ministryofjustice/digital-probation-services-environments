# Main configuration file for alfresco pre-prod environment in AWS

terraform {
  backend "s3" {
    bucket = "hmpps-probation-terraform"
    key    = "alfresco.pre-prod.terraform.tfstate"
    region = "eu-west-2"
  }
  required_version = "~> 0.11"
}

provider "aws" {
  region  = "eu-west-2"
  version = "~> 1.16"
}

locals { # Environment
  environment_name = "alfresco-pre-prod"
}

# Network
locals {
  az_a = "eu-west-2a"
  az_b = "eu-west-2b"
  az_c = "eu-west-2c"
}

# Tags
locals {
  tags = {
    owner = "Digital Studio",
    environment-name = "alfresco-pre-prod",
    application = "nDelius"
    is-production = "false",
    business-unit = "HMPPS",
    infrastructure-support = "Digital Studio"
  }
}

