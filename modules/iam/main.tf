resource "aws_iam_user" "zeta-admin" {
  name = "zeta-admin"
  path = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "zeta-admin" {
  count = "${var.create_user && var.create_iam_user_login_profile ? 1 : 0}"

  user                    = "${aws_iam_user.zeta-admin.name}"
  pgp_key                 = "${var.pgp_key}"
  password_length         = "${var.password_length}"
  password_reset_required = "${var.password_reset_required}"
}

resource "aws_iam_access_key" "zeta-admin" {
  count = "${var.create_user && var.create_iam_access_key ? 1 : 0}"

  user    = "${aws_iam_user.zeta-admin.name}"
  pgp_key = "${var.pgp_key}"
}

resource "aws_iam_group" "zeta-admin" {
  name = "zeta-admin"
  path = "/"
}

resource "aws_iam_group_membership" "admin-user-membership" {
  name = "zeta-admin"

  users = [
    "${aws_iam_user.zeta-admin.name}",
  ]

  group = "${aws_iam_group.zeta-admin.name}"
}

resource "aws_iam_group_policy" "explicit-admin" {
  name  = "explicit-admin"
  group = "${aws_iam_group.zeta-admin.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
