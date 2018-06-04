resource "google_compute_instance" "default" {
  name         = "nrelearn"
  machine_type = "n1-standard-2"

  depends_on = [
    "google_project_services.project",
  ]

  zone = "${var.zone}"

  metadata {
    hostname = "nrelearn"
  }

  project = "${google_project_services.project.project}"
  tags    = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "nested-vm-image"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }
}
