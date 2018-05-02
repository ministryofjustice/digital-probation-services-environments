# VPC, subnets etc for VCMS

resource "aws_vpc" "digital-probation-services" {
  cidr_block = "192.168.0.0/24"
  tags       = "${merge(module.tags.tags, map("Name", "${module.constants.environment_name}"))}"
}

resource "aws_internet_gateway" "main" {
  vpc_id            = "${aws_vpc.digital-probation-services.id}"
  tags              = "${merge(module.tags.tags, map("Name", "${module.constants.environment_name}"))}"
}

resource "aws_subnet" "application_public_1" {
  vpc_id            = "${aws_vpc.digital-probation-services.id}"
  cidr_block        = "${cidrsubnet(aws_vpc.digital-probation-services.cidr_block, 4, 0)}"
  availability_zone = "${module.constants.az_1}"
  tags              = "${merge(module.tags.tags, map("Name", "${module.constants.environment_name}_public_1"))}"
}

resource "aws_route_table" "application_public_1" {
  vpc_id            = "${aws_vpc.digital-probation-services.id}"
  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = "${aws_internet_gateway.main.id}"
  }
  tags              = "${merge(module.tags.tags, map("Name", "${module.constants.environment_name}_public_1"))}"
}

resource "aws_route_table_association" "application_public_1" {
  subnet_id      = "${aws_subnet.application_public_1.id}"
  route_table_id = "${aws_route_table.application_public_1.id}"
}

resource "aws_subnet" "application_public_2" {
  vpc_id            = "${aws_vpc.digital-probation-services.id}"
  cidr_block        = "${cidrsubnet(aws_vpc.digital-probation-services.cidr_block, 4, 1)}"
  availability_zone = "${module.constants.az_2}"
  tags              = "${merge(module.tags.tags, map("Name", "${module.constants.environment_name}_public_2"))}"
}

resource "aws_route_table" "application_public_2" {
  vpc_id            = "${aws_vpc.digital-probation-services.id}"
  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = "${aws_internet_gateway.main.id}"
  }
  tags              = "${merge(module.tags.tags, map("Name", "${module.constants.environment_name}_public_2"))}"
}

resource "aws_route_table_association" "application_public_2" {
  subnet_id      = "${aws_subnet.application_public_2.id}"
  route_table_id = "${aws_route_table.application_public_2.id}"
}
