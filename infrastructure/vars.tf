variable "prodstate" {

  # This variable controlls the "production state" for antidote.
  #
  # Setting to "maintenance" will direct traffic to a static page hosted in a public read-only bucket instructing users of the downtime.
  # Setting to "production" will direct traffic to the appropriate HTTP(s) backend service to the Antidote platform.
  default = "production"
}

variable "zone" {
  default = "us-west1-a" # Oregon
}

variable "zone2" {
  default = "us-west1-b" # Oregon
}

variable "zone3" {
  default = "us-west1-c" # Oregon
}

variable "region" {
  default = "us-west1" # Oregon
}

variable "os" {
  default {
    "ubuntu-1604" = "ubuntu-os-cloud/ubuntu-1604-xenial-v20180522"
    "centos-7"    = "centos-cloud/centos-7-v20180523"
  }
}

variable "zone_domain_name" {
  default = "networkreliability.engineering."
}

variable "project" {
  default = "antidote-216521"

  # default = "${google_project_services.project.project}"
}

variable "project_name" {
  default = "antidote-216521"
}
