terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {}

data "github_repositories" "all" {
  query = "org:akerl org:amylum org:armorfret org:dock0 org:halyard"
}

data "github_repository" "each" {
  for_each  = toset(data.github_repositories.all.full_names)
  full_name = each.key
}

