#####
# Primary entry into Antidote
#####

resource "google_compute_global_address" "nrefrontend" {
  name    = "nrefrontend"
  project = "${var.project}"
}

resource "google_compute_global_forwarding_rule" "nrehttps" {
  name       = "nrehttps"
  project    = "${var.project}"
  ip_address = "${google_compute_global_address.nrefrontend.address}"

  # target = "${google_compute_target_https_proxy.nrehttpsproxy.self_link}"

  # Going to HTTP here for now
  target     = "${google_compute_target_https_proxy.nrehttpsproxy.self_link}"
  port_range = "443"
}

resource "google_compute_target_http_proxy" "nreproxy" {
  name    = "test-proxy"
  project = "${var.project}"
  url_map = "${google_compute_url_map.default.self_link}"
}

// TODO(mierdin): I'm currently uploading the letencrypt cert myself - need to automate this

resource "google_compute_target_https_proxy" "nrehttpsproxy" {
  name             = "nrehttpsproxy"
  project          = "${var.project}"
  ssl_certificates = ["labs-letsencrypt"]
  url_map          = "${google_compute_url_map.default.self_link}"
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
    default_service = "${google_compute_backend_service.httpsbackend.self_link}"

    path_rule {
      paths   = ["/*"]
      service = "${google_compute_backend_service.httpsbackend.self_link}"
    }
  }

  default_service = "${google_compute_backend_service.httpsbackend.self_link}"
}

# resource "google_compute_backend_service" "httpbackend" {
#   name        = "httpbackend"
#   project     = "${var.project}"
#   description = ""

#   port_name = "nrehttp"
#   protocol  = "HTTP"

#   timeout_sec = 10

#   enable_cdn = false

#   backend {
#     group = "${data.google_compute_region_instance_group.workers.self_link}"
#   }

#   depends_on = [
#     "google_compute_health_check.httphealth",
#   ]

#   health_checks = [
#     "${google_compute_health_check.httphealth.self_link}",
#   ]
# }

resource "google_compute_backend_service" "httpsbackend" {
  name        = "httpsbackend"
  project     = "${var.project}"
  description = ""

  port_name = "nrehttps"
  protocol  = "HTTPS"

  timeout_sec = 10

  enable_cdn = false

  backend {
    group = "${data.google_compute_region_instance_group.workers.self_link}"
  }

  depends_on = [
    "google_compute_health_check.httpshealth",
  ]

  health_checks = [
    "${google_compute_health_check.httpshealth.self_link}",
  ]
}

# resource "google_compute_health_check" "httphealth" {
#   name    = "httphealth"
#   project = "${var.project}"

#   timeout_sec        = 1
#   check_interval_sec = 3

#   tcp_health_check {
#     port = "30001"
#   }
# }

resource "google_compute_health_check" "httpshealth" {
  name    = "httpshealth"
  project = "${var.project}"

  timeout_sec        = 1
  check_interval_sec = 3

  tcp_health_check {
    port = "30001"
  }
}

###
# INTERNAL - for k8s API
###

resource "google_compute_forwarding_rule" "k8sapi" {
  name    = "k8sapi-forwarding-rule"
  project = "${var.project}"

  ip_address = "10.138.0.254"

  ports                 = ["6443"]
  load_balancing_scheme = "INTERNAL"
  backend_service       = "${google_compute_region_backend_service.k8sapi.self_link}"
  service_label         = "k8sapi"
  network               = "${google_compute_network.default-internal.name}"
}

resource "google_compute_region_backend_service" "k8sapi" {
  name        = "k8sapi"
  project     = "${var.project}"
  description = "k8sapi"

  # port_name = "k8sapi"
  protocol = "TCP"

  timeout_sec = 10

  # enable_cdn = false

  backend {
    group = "${data.google_compute_region_instance_group.controllers.self_link}"
  }
  depends_on = [
    "google_compute_health_check.k8sapi",
  ]
  health_checks = [
    "${google_compute_health_check.k8sapi.self_link}",
  ]
}

resource "google_compute_health_check" "k8sapi" {
  name    = "k8sapi"
  project = "${var.project}"

  timeout_sec        = 1
  check_interval_sec = 3

  tcp_health_check {
    port = "6443"
  }
}
