variable "zone" {
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
