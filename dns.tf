# For this terraform project, we only want to manage the "labs.networkreliability.engineering"
# subdomain. The root domain is managed outside of this, and we don't want
# the github page to be taken down when this is rebuilt.

# resource "google_dns_managed_zone" "labs_zone" {
#   name        = "labs"
#   dns_name    = "labs.${var.zone_domain_name}"
#   description = "Main zone for NRE labs"

#   # project     = "${google_project.project.project_id}"
# project = "${var.project}"

#   depends_on = [
#     "google_project_services.project",
#   ]
# }

resource "google_dns_record_set" "labs" {
  # name = "${google_dns_managed_zone.labs_zone.dns_name}"
  name = "labs.networkreliability.engineering."
  type = "A"
  ttl  = 300

  # project = "${google_project.project.project_id}"
  project = "networkreliabilityengineering"

  depends_on = [
    # "google_dns_managed_zone.labs_zone",
    "google_compute_instance.tf-controller",
  ]

  # managed_zone = "${google_dns_managed_zone.labs_zone.name}"
  managed_zone = "nre"

  # Primary ingress for the NRE labs, so we're directing to the static IP provisioned for our load balancer.
  rrdatas = [
    "${google_compute_global_address.nrefrontend.address}",
  ]
}

// TODO(mierdin): needs to be more dynamic, based on how many instances were spun up, rather than explicit references to instance names
resource "google_dns_record_set" "tf-controller0" {
  # name = "tf-controller0.${google_dns_managed_zone.labs_zone.dns_name}"
  name = "tf-controller0.labs.networkreliability.engineering."
  type = "A"
  ttl  = 300

  # project = "${google_project.project.project_id}"
  project = "${var.project}"

  depends_on = [
    # "google_dns_managed_zone.labs_zone",
    "google_compute_instance.tf-controller",
  ]

  # managed_zone = "${google_dns_managed_zone.labs_zone.name}"
  managed_zone = "nre"

  rrdatas = [
    "${google_compute_instance.tf-controller.0.network_interface.0.access_config.0.assigned_nat_ip}",
  ]
}
