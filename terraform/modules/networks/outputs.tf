# Externally visible network parameters

output "vpc_id" {
  value = "${aws_vpc.digital-probation-services.id}"
}

output "application_public_application_subnet_1_id" {
  value = "${aws_subnet.application_public_1.id}"
}

output "application_public_application_subnet_2_id" {
  value = "${aws_subnet.application_public_2.id}"
}
