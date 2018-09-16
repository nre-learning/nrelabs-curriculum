resource "google_compute_image" "nested-vm-image" {
  name = "nested-vm-image"

  depends_on = [
    "google_compute_disk.centos7_disk",
  ]

  project     = "${var.project}"
  source_disk = "${google_compute_disk.centos7_disk.self_link}"

  licenses = [
    "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx",
    # "https://www.googleapis.com/compute/v1/projects/centos-cloud/global/licenses/centos-7",
  ]

}

resource "google_compute_disk" "centos7_disk" {
  name = "centos7-disk"

  project = "${var.project_name}"

  type = "pd-ssd"

  zone  = "${var.zone}"
  image = "${var.os["centos-7"]}"

  size = 350

  depends_on = [
    "google_project_services.project",
  ]
}
