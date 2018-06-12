resource "google_compute_instance" "tf-controller01" {
  name         = "tf-controller01"
  machine_type = "n1-standard-2"

  depends_on = [
    "google_project_services.project",
  ]

  zone = "${var.zone}"

  metadata {
    hostname = "tf-controller01"
  }

  project = "${google_project_services.project.project}"
  tags    = []

  boot_disk {
    initialize_params {
      image = "nested-vm-image"
    }
  }

  network_interface {
    network       = "${google_compute_network.default-internal.name}"
    access_config = {}
  }
}
