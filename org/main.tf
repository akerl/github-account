locals {
  repomap = { for repo in var.repos : repo.name => repo }
}

resource "github_repository" "each" {
  for_each = local.repomap
  name     = each.key

  description  = each.value.description
  homepage_url = each.value.homepage_url

  has_issues      = true
  has_wiki        = false
  has_projects    = false
  has_discussions = false

  allow_merge_commit     = false
  allow_rebase_merge     = false
  allow_squash_merge     = true
  delete_branch_on_merge = true
  allow_update_branch    = true
}

resource "github_repository_pages" "each" {
  for_each   = { for repo in var.repos : repo.name => repo if repo.pages != null }
  repository = each.value.name

  build_type = "legacy"

  source {
    branch = each.value.pages.branch
    path   = each.value.pages.path
  }
}

resource "github_repository_ruleset" "each" {
  for_each   = local.repomap
  repository = each.key

  name        = "Default branch protection"
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  bypass_actors {
    actor_id    = "41898282"
    actor_type  = "User"
    bypass_mode = "always"
  }

  rules {
    creation         = true
    update           = true
    deletion         = true
    non_fast_forward = true

    required_status_checks {
      strict_required_status_checks_policy = true

      dynamic "required_check" {
        for_each = var.checks
        content {
          context = each.key
        }
      }
    }
  }
}

resource "github_repository_vulnerability_alerts" "each" {
  for_each   = local.repomap
  repository = each.key

  enabled = false
}

resource "github_issue_labels" "each" {
  for_each   = local.repomap
  repository = each.key

  dynamic "label" {
    for_each = var.labels
    content {
      name  = label.value.name
      color = label.value.color
    }
  }
}
