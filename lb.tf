resource "google_compute_global_address" "nrefrontend" {
  name    = "nrefrontend"
  project = "${var.project}"
}

resource "google_compute_global_forwarding_rule" "nreforward" {
  name       = "nreforward"
  project    = "${var.project}"
  ip_address = "${google_compute_global_address.nrefrontend.address}"

  target = "${google_compute_target_http_proxy.nreproxy.self_link}"

  port_range = "80"

  # THIS IS ONLY FOR INTERNAL
  # backend_service = "${data.google_compute_region_instance_group.computes.name}"

  # ports = [
  #   "80",
  #   "443",
  # ]

  # load_balancing_scheme = "EXTERNAL"
}

# gcloud compute backend-services add-backend [backend-service-name] --instance-group [instance-group-name]

# resource "google_compute_target_tcp_proxy" "nreproxy" {
#   name            = "nreproxy"
#   description     = "nreproxy"
#   project         = "${var.project}"
#   backend_service = "${google_compute_backend_service.httpbackend.self_link}"
# }

resource "google_compute_target_http_proxy" "nreproxy" {
  name    = "test-proxy"
  project = "${var.project}"
  url_map = "${google_compute_url_map.default.self_link}"
}

resource "google_compute_url_map" "default" {
  name    = "url-map"
  project = "${var.project}"

  host_rule {
    hosts        = ["networkreliability.engineering"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = "${google_compute_backend_service.httpbackend.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.httpbackend.self_link}"
    }
  }

  default_service = "${google_compute_backend_service.httpbackend.self_link}"
}

resource "google_compute_backend_service" "httpbackend" {
  name        = "httpbackend"
  project     = "${var.project}"
  description = "Our company website"

  port_name = "nrehttp"
  protocol  = "HTTP"

  timeout_sec = 10

  enable_cdn = false

  backend {
    group = "${data.google_compute_region_instance_group.computes.self_link}"
  }

  depends_on = [
    "google_compute_health_check.httphealth",
  ]

  health_checks = [
    "${google_compute_health_check.httphealth.self_link}",
  ]
}

resource "google_compute_health_check" "httphealth" {
  name    = "httphealth"
  project = "${var.project}"

  timeout_sec        = 1
  check_interval_sec = 3

  tcp_health_check {
    port = "30001"
  }
}

resource "google_compute_health_check" "httpshealth" {
  name    = "httpshealth"
  project = "${var.project}"

  timeout_sec        = 1
  check_interval_sec = 3

  tcp_health_check {
    port = "30001"
  }
}
