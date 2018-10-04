resource "google_dns_record_set" "labs" {
  name = "labs.networkreliability.engineering."
  type = "A"
  ttl  = 300

  project = "${var.project}"

  # For this terraform project, we only want to manage the "labs.networkreliability.engineering"
  # subdomain. The root domain is managed outside of this, and we don't want
  # the github page to be taken down when this is rebuilt.
  managed_zone = "nre"

  rrdatas = [
    "${google_compute_global_address.nrefrontend.address}",
  ]
}
