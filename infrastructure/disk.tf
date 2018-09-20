resource "google_compute_disk" "centos7_disk" {
  name = "centos7-disk"

  project = "${var.project_name}"

  type = "pd-ssd"

  zone  = "${var.zone}"
  image = "${var.os["centos-7"]}"

  size = 350
}
