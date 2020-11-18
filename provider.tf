terraform {
  backend "gcs" {
    bucket = "eksamen-terraform-state"
    prefix = "tf-state"
    credentials = "google-key.json"
  }
}

provider "google-beta" {
  credentials = file("google-key.json")
  project     = var.project_id
  version = "~> 3.0.0-beta.1"
}

provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = "=2.20.0"
  features {}
}