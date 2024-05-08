
locals {
  backups = {
    schedule  = "cron(0 5 ? * MON-FRI *)" /* UTC Time */
    retention = 7 // days
  }
}

resource "aws_backup_vault" "backup-vault" {
  name = "backup-vault"
  tags = {
    Project = var.projeto
    Role    = "backup-vault"
  }
}

resource "aws_backup_plan" "backup-plan" {
  name = "backup-plan"

  rule {
    rule_name         = "weekdays-every-2-hours-${local.backups.retention}-day-retention"
    target_vault_name = aws_backup_vault.backup-vault.name
    schedule          = local.backups.schedule
    start_window      = 60
    completion_window = 300

    lifecycle {
      delete_after = local.backups.retention
    }

    recovery_point_tags = {
      Role    = "backup"
      Creator = "aws-backups"
    }
  }

  tags = {
    Project = var.projeto
    Role    = "backup"
  }
}

resource "aws_backup_selection" "server-backup-selection" {
  iam_role_arn = aws_iam_role.aws-backup-service-role.arn
  name         = "server-resources"
  plan_id      = aws_backup_plan.backup-plan.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "true"
  }
}
