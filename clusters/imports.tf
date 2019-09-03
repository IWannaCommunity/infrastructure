variable "freeman_starz0r_openldap_admin_pass" {}
variable "freeman_starz0r_openldap_config_pass" {}
module "freeman" {
  source = "./freeman"

  starz0r_openldap_admin_pass  = "${var.freeman_starz0r_openldap_admin_pass}"
  starz0r_openldap_config_pass = "${var.freeman_starz0r_openldap_config_pass}"
}
