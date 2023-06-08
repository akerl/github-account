variable "organizations" {
  description = "list of organizations to manage"
  type        = set(string)
  default     = ["amylum", "armorfret", "dock0", "halyard"]
}
