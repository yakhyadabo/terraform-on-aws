module "bastion" {
  source = "modules/bastion"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  allowed_network = "${var.allowed_network}"
}
