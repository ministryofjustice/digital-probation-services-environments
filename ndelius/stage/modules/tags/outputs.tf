# Standard tags for Digital Probation Services resources

output "tags" {
  value = {
    owner = "Digital Studio",
    environment-name = "ndelius-stage",
    application = "nDelius"
    is-production = "false",
    business-unit = "HMPPS",
    infrastructure-support = "Digital Studio"
  }
}
