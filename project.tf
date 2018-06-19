variable "project_name" {
  default = "nre-learning"
}

# Provided at runtime
variable "billing_account" {}

provider "google" {
  region = "${var.region}"
}

resource "random_id" "id" {
  byte_length = 4
  prefix      = "${var.project_name}-"
}

resource "google_project" "project" {
  name            = "${var.project_name}"
  project_id      = "${random_id.id.hex}"
  billing_account = "${var.billing_account}"
}

resource "google_project_services" "project" {
  project = "${google_project.project.project_id}"

  // Services to allow in this project. These are the APIs that are enabled for this project.
  services = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
    "iam.googleapis.com",
    "dns.googleapis.com",
  ]
}

output "project_id_out" {
  value = "${google_project.project.project_id}"
}
