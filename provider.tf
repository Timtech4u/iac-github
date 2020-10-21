provider "google" {
  project     = var.project
  version     = "~>v3.41.0"
  credentials = file(var.service_account_file)
}
