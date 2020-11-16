resource "google_storage_bucket" "tf-state" {
  project = var.project_id
  name = "eksamen-terraform-state-bucket"
  location = "EU"
}


