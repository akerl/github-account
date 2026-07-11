variable "repos" {
  type = set(object({
    name         = string
    description  = optional(string)
    homepage_url = optional(string)
    pages = optional(object({
      branch = string
      path   = string
    }))
  }))
}

variable "labels" {
  type = set(object({
    name  = string
    color = string
  }))
}

variable "checks" {
  type = set(string)
}
