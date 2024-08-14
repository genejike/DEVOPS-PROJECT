resource "aws_iam_user" "eg" {
  name = var.user_names[count.index]
  count = length(var.user_names)
  path = "/system/"

  tags = {
    tag-key = var.iam_user_tag
  }
}
