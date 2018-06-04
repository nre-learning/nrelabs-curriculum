resource "google_compute_disk" "xenial_disk" {
  name    = "u16-disk"
  project = "${google_project.project.project_id}"

  zone  = "${var.zone}"
  image = "${var.os["ubuntu-1604"]}"

  depends_on = [
    "google_project_services.project",
  ]
}

output "disk_id_out" {
  value = "${google_compute_disk.xenial_disk.name}"
}

# Per https://cloud.google.com/compute/docs/instances/enable-nested-virtualization-vm-instances
# We want to set up a disk based off a source Xenial image, and then create a new image based
# on this disk, with hardware virtulization flag enabled.
#
# Unfortunately, it doesn't look like the google_compute_image resource yet has a "licenses" field for us
# to be able to do this. So we'll have to use the gcloud API directly, and comment this out for now.
#
# resource "google_compute_image" "xenial_image_vmx" {
#   name        = "u16-virt"
#   source_disk = "${google_compute_disk.xenial_disk.u16-disk.self_link}"
#   # Enable virtualization extensions
#   licenses = ["https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"]
# }

