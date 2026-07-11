locals {
  yaml = yamldecode(file("${path.module}/data.yaml"))
}

module "akerl" {
  source = "./org"
  providers = {
    github = github.akerl
  }
  labels = local.yaml.labels
  checks = local.yaml.checks
  repos  = local.yaml.orgs.akerl
}

module "amylum" {
  source = "./org"
  providers = {
    github = github.amylum
  }
  labels = local.yaml.labels
  checks = local.yaml.checks
  repos  = local.yaml.orgs.amylum
}

module "armorfret" {
  source = "./org"
  providers = {
    github = github.armorfret
  }
  labels = local.yaml.labels
  checks = local.yaml.checks
  repos  = local.yaml.orgs.armorfret
}

module "dock0" {
  source = "./org"
  providers = {
    github = github.dock0
  }
  labels = local.yaml.labels
  checks = local.yaml.checks
  repos  = local.yaml.orgs.dock0
}

module "halyard" {
  source = "./org"
  providers = {
    github = github.halyard
  }
  labels = local.yaml.labels
  checks = local.yaml.checks
  repos  = local.yaml.orgs.halyard
}
