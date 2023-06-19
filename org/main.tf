terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.28"
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

resource "github_issue_label" "bug" {
  for_each   = toset([for index, repo in data.github_repository.each : repo.name])
  repository = each.key
  name       = "bug"
  color      = "ffa500"
}

resource "github_issue_label" "feature" {
  for_each   = toset([for index, repo in data.github_repository.each : repo.name])
  repository = each.key
  name       = "feature"
  color      = "0000ff"
}

resource "github_issue_label" "mergewhenready" {
  for_each   = toset([for index, repo in data.github_repository.each : repo.name])
  repository = each.key
  name       = "mergewhenready"
  color      = "008000"
}

resource "github_issue_label" "donotmerge" {
  for_each   = toset([for index, repo in data.github_repository.each : repo.name])
  repository = each.key
  name       = "donotmerge"
  color      = "ff0000"
}
