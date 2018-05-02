# Standard tags for Digital Probation Services resources

output "tags" {
  value = {
    owner = "Digital Studio",
    environment-name = "vcms-stage",
    application = "VCMS"
    is-production = "false",
    business-unit = "HMPPS",
    infrastructure-support = "Digital Studio"
  }
}
