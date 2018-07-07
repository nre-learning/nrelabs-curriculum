resource "google_compute_image" "nested-vm-image" {
  name = "nested-vm-image"

  depends_on = [
    "google_compute_disk.centos7_disk",
  ]

  project     = "${var.project}"
  source_disk = "${google_compute_disk.centos7_disk.self_link}"

  licenses = [
    "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx",
  ]
}
