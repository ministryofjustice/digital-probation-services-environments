# VPC, subnets etc for VCMS

module "network" {
  source  = "../../modules/vpc_with_public_and_db_subnets"
  vpc_cidr = "192.168.0.0/24"
  tags = "${local.tags}"
  environment_name = "${local.environment_name}"
  az_a = "${local.az_a}"
  az_b = "${local.az_b}"
}
