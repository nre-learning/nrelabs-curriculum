resource "google_compute_firewall" "supersecure" {
  name = "supersecure"

  project = "${google_project_services.project.project}"

  network = "${google_compute_network.default-internal.name}"

  allow {
    protocol = "all"
  }

  source_tags = []
}

resource "google_compute_network" "default-internal" {
  name                    = "default-internal"
  project                 = "${google_project_services.project.project}"
  auto_create_subnetworks = "true"
}
