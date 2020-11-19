variable "logz_token" {

}
variable "statuscake_key" {

}

variable "opsgenie_key" {}

#Datadog
variable "api_key" {}
variable "app_key" {}

variable "project_id" {
  default = "devops-examen-2020"
}

locals {
  gcp_json_data = jsondecode(file("${path.module}/google-key.json"))
}


