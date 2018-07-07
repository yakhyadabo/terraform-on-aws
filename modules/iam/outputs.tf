output "zeta_admin_user_name" {
  description = "The user's name"
  value       = "${element(concat(aws_iam_user.zeta-admin.*.name, list("")), 0)}"
}

output "zeta_admin_user_login_profile_key_fingerprint" {
  description = "The fingerprint of the PGP key used to encrypt the password"
  value       = "${element(concat(aws_iam_user_login_profile.zeta-admin.*.key_fingerprint, list("")), 0)}"
}

output "zeta_admin_user_login_profile_encrypted_password" {
  description = "The encrypted password, base64 encoded"
  value       = "${element(concat(aws_iam_user_login_profile.zeta-admin.*.encrypted_password, list("")), 0)}"
}

output "zeta_admin_access_key_id" {
  description = "The access key ID"
  value       = "${element(concat(aws_iam_access_key.zeta-admin.*.id, list("")), 0)}"
}

output "zeta_admin_access_key_key_fingerprint" {
  description = "The fingerprint of the PGP key used to encrypt the secret"
  value       = "${element(concat(aws_iam_access_key.zeta-admin.*.key_fingerprint, list("")), 0)}"
}

output "zeta_admin_access_key_encrypted_secret" {
  description = "The encrypted secret, base64 encoded"
  value       = "${element(concat(aws_iam_access_key.zeta-admin.*.encrypted_secret, list("")), 0)}"
}

output "zeta_admin_access_key_status" {
  description = "Active or Inactive. Keys are initially active, but can be made inactive by other means."
  value       = "${element(concat(aws_iam_access_key.zeta-admin.*.status, list("")), 0)}"
}

output "pgp_key" {
  description = "PGP key used to encrypt sensitive data for zeta-admin user (if empty - secrets are not encrypted)"
  value       = "${var.pgp_key}"
}

output "keybase_password_decrypt_command" {
  value = <<EOF
echo "${element(concat(aws_iam_user_login_profile.zeta-admin.*.encrypted_password, list("")), 0)}" | base64 --decode | keybase pgp decrypt
EOF
}

output "keybase_password_pgp_message" {
  value = <<EOF
-----BEGIN PGP MESSAGE-----
Version: Keybase OpenPGP v2.0.76
Comment: https://keybase.io/crypto

${element(concat(aws_iam_user_login_profile.zeta-admin.*.encrypted_password, list("")), 0)}
-----END PGP MESSAGE-----
EOF
}

output "keybase_secret_key_decrypt_command" {
  value = <<EOF
echo "${element(concat(aws_iam_access_key.zeta-admin.*.encrypted_secret, list("")), 0)}" | base64 --decode | keybase pgp decrypt
EOF
}

output "keybase_secret_key_pgp_message" {
  value = <<EOF
-----BEGIN PGP MESSAGE-----
Version: Keybase OpenPGP v2.0.76
Comment: https://keybase.io/crypto

${element(concat(aws_iam_access_key.zeta-admin.*.encrypted_secret, list("")), 0)}
-----END PGP MESSAGE-----
EOF
}
