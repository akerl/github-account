terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.25.1"
    }
  }
}

provider "github" {}

data "github_user" "self" {
  username = ""
}

data "github_organization" "all" {
  for_each = var.organizations
  name     = each.key
}

data "github_repositories" "all" {
  query = join(" ", concat(
    ["org:${data.github_user.self.login}"],
    [for x in data.github_organization.all : format("org:%s", x.name)]
  ))
}

data "github_repository" "each" {
  for_each  = toset(data.github_repositories.all.full_names)
  full_name = each.key
}


