resource "aws_iam_role" "admin" {
  name               = "admin"
  description        = "Full admin permissions"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": { "AWS": "arn:aws:iam::570551521311:root" },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy" "AdministratorAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_role_policy_attachment" "admin" {
  role = "${aws_iam_role.admin.name}"
  policy_arn = "${data.aws_iam_policy.AdministratorAccess.arn}"
}
