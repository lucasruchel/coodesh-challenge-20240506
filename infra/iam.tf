/* Assume Role Policy for Backups */
data "aws_iam_policy_document" "aws-backup-service-assume-role-policy-doc" {
  statement {
    sid     = "AssumeServiceRole"
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

/* The policies that allow the backup service to take backups and restores */
data "aws_iam_policy" "aws-backup-service-policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

data "aws_iam_policy" "aws-restore-service-policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
}

data "aws_caller_identity" "current_account" {}

/* Needed to allow the backup service to restore from a snapshot to an EC2 instance
 See https://stackoverflow.com/questions/61802628/aws-backup-missing-permission-iampassrole */
data "aws_iam_policy_document" "pass-role-policy-doc" {
  statement {
    sid       = "PassRole"
    actions   = ["iam:PassRole"]
    effect    = "Allow"
    resources = ["arn:aws:iam::${data.aws_caller_identity.current_account.account_id}:role/*"]
  }
}

/* Roles for taking AWS Backups */
resource "aws_iam_role" "aws-backup-service-role" {
  name               = "AWSBackupServiceRole"
  description        = "Allows the AWS Backup Service to take scheduled backups"
  assume_role_policy = data.aws_iam_policy_document.aws-backup-service-assume-role-policy-doc.json

  tags = {
    Project = var.projeto
    Role    = "iam"
  }
}

resource "aws_iam_role_policy_attachment" "backup-service-aws-backup-role-policy" {
  policy_arn = "${ data.aws_iam_policy.aws-backup-service-policy.arn }"

  role   = aws_iam_role.aws-backup-service-role.name
}

resource "aws_iam_role_policy_attachment" "restore-service-aws-backup-role-policy" {
  policy_arn = "${ data.aws_iam_policy.aws-backup-service-policy.arn }"
  role   = aws_iam_role.aws-backup-service-role.name
}

resource "aws_iam_role_policy" "backup-service-pass-role-policy" {
  policy = data.aws_iam_policy_document.pass-role-policy-doc.json
  role   = aws_iam_role.aws-backup-service-role.name
}