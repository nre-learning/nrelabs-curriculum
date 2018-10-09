resource "google_compute_firewall" "restrict-external" {
  name = "restrict-external"

  project = "${var.project}"

  network = "${google_compute_network.default-internal.name}"

  allow {
    protocol = "tcp"

    # 3001 = nginx http nodeport
    # 3002 = nginx https nodeport
    # 6443 = k8s API
    ports    = ["22", "30001", "30002", "6443"]
  }

  # source_tags = []

  source_ranges = [
    "0.0.0.0/0"
  ]
}

resource "google_compute_firewall" "allow-internal-antidote" {
  name = "allow-internal-antidote"

  project = "${var.project}"

  network = "${google_compute_network.default-internal.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  // Default allow-all range in GCE isn't broad enough. I.e. instances are 10.128.0.0/9 but weave is 10.32.0.0/8 by default, etc etc
  // Pretty much everything is under 10.0.0.0/8, and really, the main thing is to just apply to everything internal anyways. May as well
  // expand to all RFC1918 tbh.
  source_ranges = [
    "10.0.0.0/8"
  ]
}

resource "google_compute_network" "default-internal" {
  name = "default-internal"
  project                 = "${var.project}"
  auto_create_subnetworks = "true"
}
