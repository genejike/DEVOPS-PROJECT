resource "aws_iam_user" "eg" {
  for_each = toset(var.user_names)
  name     = each.value
  path     = "/system/"

  tags = {
    tag-key = var.iam_user_tag
  }
}

data "aws_iam_policy_document" "cloudwatch_read_only" {
  statement {
    effect    = "Allow"
    actions   = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_read_only" {
  name   = "cloudwatch-read-only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_full_access" {
  name   = "cloudwatch-full-access"
  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

resource "aws_iam_user_policy_attachment" "cy_cloudwatch_full_access" {
  for_each = { for k, v in aws_iam_user.eg : k => v if k == "cy" && var.give_cy_cloudwatch_full_access }

  user       = each.value.name
  policy_arn = aws_iam_policy.cloudwatch_full_access.arn
}

resource "aws_iam_user_policy_attachment" "cy_cloudwatch_read_only" {
  for_each = { for k, v in aws_iam_user.eg : k => v if k == "cy" && !var.give_cy_cloudwatch_full_access }

  user       = each.value.name
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}