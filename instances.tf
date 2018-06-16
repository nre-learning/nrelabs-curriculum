resource "google_compute_instance" "tf-controller" {
  count = 1

  name         = "tf-controller${count.index}"
  machine_type = "n1-standard-2"

  depends_on = [
    "google_project_services.project",
  ]

  zone = "${var.zone}"

  metadata {
    hostname = "tf-controller${count.index}"
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

resource "google_compute_instance" "tf-compute" {
  count = 2

  name         = "tf-compute${count.index}"
  machine_type = "n1-standard-2"

  depends_on = [
    "google_project_services.project",
  ]

  zone = "${var.zone}"

  metadata {
    hostname = "tf-compute${count.index}"
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
