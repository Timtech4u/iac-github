output "organization" {
  description = "Members and Admins of the organization."
  value       = module.organization
}

output "iac_github_repository" {
  description = "All outputs of the iac-github repository."
  value       = module.iac-github
}
