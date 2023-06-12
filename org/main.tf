terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.25.1"
    }
  }
}

variable "name" {
  type = string
}

data "github_repositories" "all" {
  query = "org:${var.name}"
}

data "github_repository" "each" {
  for_each  = toset(data.github_repositories.all.full_names)
  full_name = each.key
}

resource "github_repository" "each" {
  for_each = { for index, repo in data.github_repository.each : repo.name => repo }

  name = each.value.name

  description  = each.value.description
  homepage_url = each.value.homepage_url

  has_issues      = true
  has_downloads   = false
  has_wiki        = false
  has_projects    = false
  has_discussions = false

  vulnerability_alerts = false

  allow_merge_commit     = false
  allow_rebase_merge     = false
  allow_squash_merge     = true
  delete_branch_on_merge = true
  allow_update_branch    = true

  dynamic "pages" {
    for_each = each.value.pages
    content {
      source {
        branch = pages.value.source[0].branch
        path   = pages.value.source[0].path
      }
    }
  }
}
