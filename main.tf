terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.28.0"
    }
  }
}

provider "github" {
  alias = "akerl"
  owner = "akerl"
  app_auth {
    id              = 345463
    installation_id = 38440759
    pem_file        = file("key.pem")
  }
}

provider "github" {
  alias = "amylum"
  owner = "amylum"
  app_auth {
    id              = 345463
    installation_id = 38440760
    pem_file        = file("key.pem")
  }
}

provider "github" {
  alias = "armorfret"
  owner = "armorfret"
  app_auth {
    id              = 345463
    installation_id = 38440765
    pem_file        = file("key.pem")
  }
}

provider "github" {
  alias = "dock0"
  owner = "dock0"
  app_auth {
    id              = 345463
    installation_id = 38440767
    pem_file        = file("key.pem")
  }
}

provider "github" {
  alias = "halyard"
  owner = "halyard"
  app_auth {
    id              = 345463
    installation_id = 38440768
    pem_file        = file("key.pem")
  }
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
