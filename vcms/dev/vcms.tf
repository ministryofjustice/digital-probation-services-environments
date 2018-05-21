# VCMS application in the VCMS dev environment

# Elastic beanstalk
locals {
  eb_environment_name = "vcms-dev"
}

# Database
locals {
  db_name = "vcmsdev"
}

module "application" {
  source  = "../modules/vcms_application"
  vpc_id  = "${module.network.vpc_id}"
  tags = "${local.tags}"
  eb_environment_name = "${local.eb_environment_name}"
  private_subnet_a_id = "${module.network.private_subnet_a_id}"
  private_subnet_b_id = "${module.network.private_subnet_b_id}"
  public_subnet_a_id = "${module.network.public_subnet_a_id}"
  public_subnet_b_id = "${module.network.public_subnet_b_id}"
  db_subnet_group_name = "${module.network.db_subnet_group_name}"
  db_name = "${local.db_name}"
}

