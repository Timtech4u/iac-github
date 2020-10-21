variable "project" {
  type        = "string"
  description = "GCP Project ID"
  default     = "vpn-test-291807"
}

variable "zone" {
  type        = "string"
  description = "GCP Project Zone"
  default     = "us-central1-a"
}

variable "service_account_file" {
  type        = "string"
  description = "file path to JSON Service Account"
  default     = "/sa.json"
}

variable "gcs_bucket_name" {
  type        = "string"
  description = "GCS bucket name for backend & state locking"
  default     = "tim_playground_state"
}
