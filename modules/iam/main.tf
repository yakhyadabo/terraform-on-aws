resource "aws_iam_user" "zeta-admin" {
    name = "zeta-admin"
    path = "/"
}

resource "aws_iam_group" "admin-group" {
    name = "admin-group"
    path = "/"
}

resource "aws_iam_group_membership" "admin-user-membership" {
    name = "admin-user-membership"
    users = [
        "${aws_iam_user.zeta-admin.name}",
    ]
    group = "${aws_iam_group.admin-group.name}"
}

resource "aws_iam_group_policy" "explicit-admin" {
    name = "explicit-admin"
    group = "${aws_iam_group.admin-group.id}"
    policy = <<EOF
{
  "Version": "2018-07-02",
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
