module "public" {
  source = "../../modules/network/public"

  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}
