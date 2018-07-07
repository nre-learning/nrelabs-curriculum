resource "google_compute_instance" "tf-controller" {
  count = 1

  name = "tf-controller${count.index}"

  # 2 vCPUs, 7.5GB RAM
  machine_type = "n1-standard-2"

  depends_on = [
    "google_project_services.project",
    "google_compute_image.nested-vm-image",
  ]

  zone = "${var.zone}"

  metadata {
    hostname = "tf-controller${count.index}"
  }

  # project = "${google_project_services.project.project}"
  project = "networkreliabilityengineering"
  tags    = []

  boot_disk {
    initialize_params {
      image = "nested-vm-image"
    }
  }

  network_interface {
    network       = "${google_compute_network.default-internal.name}"
    access_config = {}

    # TODO(mierdin): this won't work if you spin up multiple controllers. Will need to revisit this.
    address = "10.138.0.5"
  }
}

resource "google_compute_instance" "tf-compute" {
  count = 2

  name = "tf-compute${count.index}"

  # 8 vCPUs, 30GB RAM
  # machine_type = "n1-standard-8"

  machine_type = "n1-standard-2"
  depends_on = [
    "google_project_services.project",
    "google_compute_image.nested-vm-image",
  ]
  zone = "${var.zone}"
  metadata {
    hostname = "tf-compute${count.index}"
  }
  # project = "${google_project_services.project.project}"
  project = "networkreliabilityengineering"
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

resource "google_compute_instance" "db" {
  count = 1

  name         = "db${count.index}"
  machine_type = "n1-standard-2"

  depends_on = [
    "google_project_services.project",
  ]

  zone = "${var.zone}"

  metadata {
    hostname = "db${count.index}"
  }

  project = "${var.project}"
  tags    = []

  boot_disk {
    initialize_params {
      # image = "${var.os["centos-7"]}"
      image = "${google_compute_image.nested-vm-image.self_link}"
    }
  }

  # TODO(mierdin): DEFINITELY need to restrict access here.
  network_interface {
    network       = "${google_compute_network.default-internal.name}"
    access_config = {}
  }
}
