provider "google" {
  credentials = file(var.service_account_file)
  project = var.project
  version = "~>v3.41.0"
}
