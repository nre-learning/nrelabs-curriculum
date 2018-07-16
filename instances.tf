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
  project = "${var.project}"
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

data "google_compute_region_instance_group" "computes" {
  # name      = "computes"
  project   = "${var.project}"
  region    = "${var.region}"
  self_link = "${google_compute_region_instance_group_manager.computes.instance_group}"
}

resource "google_compute_region_instance_group_manager" "computes" {
  name    = "computes"
  project = "${var.project}"

  base_instance_name = "a-compute"
  instance_template  = "${google_compute_instance_template.antidote-computes.self_link}"
  region             = "${var.region}"

  named_port {
    name = "nrehttp"
    port = 30001
  }

  # named_port {
  #   name = "https"
  #   port = 30002
  # }
}

resource "google_compute_region_autoscaler" "computes-scaler" {
  name    = "computes-scaler"
  project = "${var.project}"
  region  = "${var.region}"
  target  = "${google_compute_region_instance_group_manager.computes.self_link}"

  autoscaling_policy = {
    max_replicas    = 2
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.8
    }
  }
}

resource "google_compute_instance_template" "antidote-computes" {
  name        = "antidote-computes"
  project     = "${var.project}"
  description = "This template is used to create antidote compute instances."

  # 8 vCPUs, 30GB RAM
  # machine_type = "n1-standard-8"

  machine_type = "n1-standard-2"
  depends_on = [
    "google_project_services.project",
    "google_compute_image.nested-vm-image",
  ]
  instance_description = "antidote compute instance"
  can_ip_forward       = true

  # scheduling {
  #   automatic_restart   = true
  #   on_host_maintenance = "MIGRATE"
  # }

  disk {
    source_image = "nested-vm-image"
    auto_delete  = true
    boot         = true
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
      image = "${var.os["centos-7"]}"
    }
  }

  # TODO(mierdin): DEFINITELY need to restrict access here.
  network_interface {
    network       = "${google_compute_network.default-internal.name}"
    access_config = {}
  }
}
