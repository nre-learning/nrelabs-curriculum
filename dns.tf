resource "google_dns_managed_zone" "primary_zone" {
  name        = "nre"
  dns_name    = "${var.zone_domain_name}"
  description = "Main zone for NRE labs"
  project     = "${google_project.project.project_id}"

  depends_on = [
    "google_project_services.project",
  ]
}

resource "google_dns_record_set" "labs" {
  name    = "labs.${google_dns_managed_zone.primary_zone.dns_name}"
  type    = "A"
  ttl     = 60
  project = "${google_project.project.project_id}"

  managed_zone = "${google_dns_managed_zone.primary_zone.name}"

  // Setting to tf-controller0 for now, but in the future this should point to a web application
  // for overviewing the labs.
  rrdatas = [
    "${google_compute_instance.tf-controller.0.network_interface.0.access_config.0.assigned_nat_ip}",
  ]
}

// TODO(mierdin): needs to be more dynamic, based on how many instances were spun up, rather than explicit references to instance names
resource "google_dns_record_set" "tf-controller0" {
  name    = "tf-controller0.labs.${google_dns_managed_zone.primary_zone.dns_name}"
  type    = "A"
  ttl     = 60
  project = "${google_project.project.project_id}"

  managed_zone = "${google_dns_managed_zone.primary_zone.name}"

  rrdatas = [
    "${google_compute_instance.tf-controller.0.network_interface.0.access_config.0.assigned_nat_ip}",
  ]
}

resource "google_dns_record_set" "tf-compute0" {
  name    = "tf-compute0.labs.${google_dns_managed_zone.primary_zone.dns_name}"
  type    = "A"
  ttl     = 60
  project = "${google_project.project.project_id}"

  managed_zone = "${google_dns_managed_zone.primary_zone.name}"

  rrdatas = [
    "${google_compute_instance.tf-compute.0.network_interface.0.access_config.0.assigned_nat_ip}",
  ]
}

resource "google_dns_record_set" "tf-compute1" {
  name    = "tf-compute1.labs.${google_dns_managed_zone.primary_zone.dns_name}"
  type    = "A"
  ttl     = 60
  project = "${google_project.project.project_id}"

  managed_zone = "${google_dns_managed_zone.primary_zone.name}"

  rrdatas = [
    "${google_compute_instance.tf-compute.1.network_interface.0.access_config.0.assigned_nat_ip}",
  ]
}
