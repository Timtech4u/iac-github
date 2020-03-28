# ---------------------------------------------------------------------------------------------------------------------
# SET TERRAFORM AND PROVIDER REQUIREMENTS
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = "~> 0.12.24"

  //  backend "s3" {
  //    bucket         = "github-terraform-example-terraform-state"
  //    key            = "organizations/github-terraform-example/terraform.tfstate"
  //    region         = "us-east-1"
  //    encrypt        = true
  //    dynamodb_table = "terraform-state-lock"
  //  }

  required_providers {
    github = "~> 2.4"
  }
}

provider "github" {
  organization = "github-terraform-example"
}

provider "aws" {
  region = "us-east-1"
}
