module "dmz" {
  source = "../../modules/network/dmz"

  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}
