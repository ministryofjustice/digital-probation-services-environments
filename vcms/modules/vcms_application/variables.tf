variable "vpc_id" {
  type = "string"
}

variable "tags" {
  type = "map"
}

variable "private_subnet_a_id" {
  type = "string"
}

variable "private_subnet_b_id" {
  type = "string"
}

variable "public_subnet_a_id" {
  type = "string"
}

variable "public_subnet_b_id" {
  type = "string"
}

variable "db_subnet_group_name" {
  type = "string"
}

variable "eb_environment_name" {
  type = "string"
}

variable "db_name" {
  type = "string"
}

