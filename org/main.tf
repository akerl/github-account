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
  allow_rebase_merge     = true
  allow_squash_merge     = false
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

resource "github_branch_protection" "each" {
  for_each      = local.repomap
  repository_id = each.key

  pattern             = "main"
  enforce_admins      = true
  allows_deletions    = false
  allows_force_pushes = false

  required_status_checks {
    strict   = true
    contexts = var.checks
  }
}

resource "github_repository_ruleset" "tag" {
  for_each   = local.repomap
  repository = each.key

  name        = "restrict tags"
  target      = "tag"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~ALL"]
      exclude = []
    }
  }

  dynamic "bypass_actors" {
    for_each = each.value.tag_bypass
    content {
      actor_id    = bypass_actors.value
      actor_type  = "Integration"
      bypass_mode = "always"
    }
  }

  rules {
    creation = true
    update   = true
    deletion = true
  }
}


resource "github_repository_vulnerability_alerts" "each" {
  for_each   = local.repomap
  repository = each.key

  enabled = false
}

resource "github_workflow_repository_permissions" "test" {
  for_each   = local.repomap
  repository = each.key

  default_workflow_permissions     = "read"
  can_approve_pull_request_reviews = false
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
