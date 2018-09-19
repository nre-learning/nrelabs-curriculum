resource "google_compute_firewall" "supersecure" {
  name = "supersecure"

  project = "${var.project}"

  # depends_on = [
  #   "google_project_services.project",
  # ]

  network = "${google_compute_network.default-internal.name}"

  allow {
    protocol = "all"
  }

  source_tags = []
}

resource "google_compute_network" "default-internal" {
  name = "default-internal"

  # depends_on = [
  #   "google_project_services.project",
  # ]

  project                 = "${var.project}"
  auto_create_subnetworks = "true"
}
