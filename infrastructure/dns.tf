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
  name = "labs.networkreliability.engineering."
  type = "A"
  ttl  = 300

  project = "${var.project}"

  managed_zone = "nre"

  rrdatas = [
    "${google_compute_global_address.nrefrontend.address}",
  ]
}
