variable "project_name" {
  default = "nre-learning"
}

# Provided at runtime
variable "billing_account" {}

provider "google" {
  region  = "${var.region}"
  version = "~> 1.16.2"
}

resource "random_id" "id" {
  byte_length = 4
  prefix      = "${var.project_name}-"
}

# Taking this out for now so I don't have to recreate a project a billion times a day.
# Planning to put this back in.
#
# If you do, make sure you put 
# gcloud config set core/project $(gcloud projects list | grep nre-learning | awk '{print $1}')
# back in to the README
#
# resource "google_project" "project" {
#   name = "${var.project_name}"

#   project_id      = "${random_id.id.hex}"
#   billing_account = "${var.billing_account}"
# }

resource "google_project_services" "project" {
  project = "${var.project}"

  disable_on_destroy = false

  // Services to allow in this project. These are the APIs that are enabled for this project.
  services = [
    "compute.googleapis.com",
    "oslogin.googleapis.com",
    "iam.googleapis.com",
    "dns.googleapis.com",
  ]
}
