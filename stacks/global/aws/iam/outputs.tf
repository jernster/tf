output "iam_arn" {
    value = ["${aws_iam_user.iam_example.*.arn}"]
}