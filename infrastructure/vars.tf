variable "zone" {
  default = "us-west1-a" # Oregon
}

variable "zone2" {
  default = "us-west1-a" # Oregon
}

variable "zone3" {
  default = "us-west1-a" # Oregon
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


variable "k8s_master_password" {
  default = ""
}