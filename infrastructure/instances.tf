data "google_compute_region_instance_group" "controllers" {
  project   = "${var.project}"
  region    = "${var.region}"
  self_link = "${google_compute_region_instance_group_manager.controllers.instance_group}"
}

data "google_compute_region_instance_group" "workers" {
  project   = "${var.project}"
  region    = "${var.region}"
  self_link = "${google_compute_region_instance_group_manager.workers.instance_group}"
}

resource "google_compute_region_instance_group_manager" "controllers" {
  name    = "controllers"
  project = "${var.project}"

  base_instance_name = "antidote-controller"
  instance_template  = "${google_compute_instance_template.controllers.self_link}"
  region             = "${var.region}"

  named_port {
    name = "k8sapi"
    port = 6443
  }
}

resource "google_compute_region_instance_group_manager" "workers" {
  name    = "workers"
  project = "${var.project}"

  base_instance_name = "antidote-worker"
  instance_template  = "${google_compute_instance_template.workers.self_link}"
  region             = "${var.region}"

  named_port {
    name = "nrehttp"
    port = 30001
  }

  named_port {
    name = "https"
    port = 30002
  }
}

resource "google_compute_region_autoscaler" "controllers-scaler" {
  name    = "controllers-scaler"
  project = "${var.project}"
  region  = "${var.region}"
  target  = "${google_compute_region_instance_group_manager.controllers.self_link}"

  autoscaling_policy = {
    max_replicas    = 1
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.8
    }
  }
}

resource "google_compute_region_autoscaler" "workers-scaler" {
  name    = "workers-scaler"
  project = "${var.project}"
  region  = "${var.region}"
  target  = "${google_compute_region_instance_group_manager.workers.self_link}"

  autoscaling_policy = {
    max_replicas    = 4
    min_replicas    = 3
    cooldown_period = 60

    cpu_utilization {
      target = 0.8
    }
  }
}

resource "google_compute_instance_template" "controllers" {
  name        = "controllers"
  project     = "${var.project}"
  description = "This template is used to create antidote controller instances."

  tags         = ["antidote", "kubernetes", "kubernetescontrollers"]
  machine_type = "n1-standard-2"

  depends_on = [
    # "google_project_services.project",
    "google_compute_image.nested-vm-image",
  ]

  instance_description = "antidote controller instance"
  can_ip_forward       = true

  # scheduling {
  #   automatic_restart   = true
  #   on_host_maintenance = "MIGRATE"
  # }

  disk {
    source_image = "${google_compute_image.nested-vm-image.name}"
    auto_delete  = true
    boot         = true
  }
  network_interface {
    network       = "${google_compute_network.default-internal.name}"
    access_config = {}
  }
}

resource "google_compute_instance_template" "workers" {
  name        = "workers"
  project     = "${var.project}"
  description = "This template is used to create antidote workers instances."

  tags = ["antidote", "kubernetes", "kubernetesworkers"]

  # 8 vCPUs, 30GB RAM
  machine_type = "n1-standard-16"

  depends_on = [
    # "google_project_services.project",
    "google_compute_image.nested-vm-image",
  ]

  instance_description = "antidote workers instance"
  can_ip_forward       = true

  # scheduling {
  #   automatic_restart   = true
  #   on_host_maintenance = "MIGRATE"
  # }

  disk {
    source_image = "${google_compute_image.nested-vm-image.name}"
    auto_delete  = true
    boot         = true
  }
  network_interface {
    network       = "${google_compute_network.default-internal.name}"
    access_config = {}
  }
}
