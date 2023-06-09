terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.25.1"
    }
  }
}

provider "github" {
  alias = "akerl"
}

provider "github" {
  alias = "amylum"
  owner = "amylum"
}

provider "github" {
  alias = "armorfret"
  owner = "armorfret"
}

provider "github" {
  alias = "dock0"
  owner = "dock0"
}

provider "github" {
  alias = "halyard"
  owner = "halyard"
}

module "akerl" {
  source = "./org"
  name   = "akerl"
  providers = {
    github = github.akerl
  }
}

module "amylum" {
  source = "./org"
  name   = "amylum"
  providers = {
    github = github.amylum
  }
}

module "armorfret" {
  source = "./org"
  name   = "armorfret"
  providers = {
    github = github.armorfret
  }
}

module "dock0" {
  source = "./org"
  name   = "dock0"
  providers = {
    github = github.dock0
  }
}

module "halyard" {
  source = "./org"
  name   = "halyard"
  providers = {
    github = github.halyard
  }
}
