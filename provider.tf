

provider "google-beta" {
  credentials = file("google-key.json")
  project     = var.project_id
  version = "~> 3.0.0-beta.1"
}