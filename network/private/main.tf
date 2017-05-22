module "private" {
  source = "../../modules/network/private"

  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}
