resource "google_service_account" "ansible" {
  account_id   = "ansible"
  display_name = "ansible"
  project      = "${var.project}"
}

resource "google_service_account_key" "ansible-key" {
  service_account_id = "${google_service_account.ansible.name}"
}

resource "local_file" "ansible-key-file" {
  content  = "${base64decode(google_service_account_key.ansible-key.private_key)}"
  filename = "${path.module}/inventory/ansiblekey.json"
}

resource "random_id" "ansible-role-id" {
  byte_length = 6
  prefix      = "ansible_"
}

// Because apparently IAM custom roles don't get deleted right away so let's randomly generate
// an ID because reasons
resource "google_project_iam_custom_role" "ansible" {
  role_id     = "${random_id.ansible-role-id.hex}"
  title       = "Ansible Role"
  description = "Role for ansible dynamic inventory"
  project     = "${var.project}"

  deleted = false

  permissions = [
    "compute.zones.list",
    "compute.regions.list",
    "compute.instances.list",
    "compute.disks.list",
  ]
}

resource "google_project_iam_binding" "admin-account-iam" {
  project = "${var.project}"
  role    = "projects/networkreliabilityengineering/roles/${google_project_iam_custom_role.ansible.role_id}"

  members = [
    "serviceAccount:ansible@networkreliabilityengineering.iam.gserviceaccount.com",
  ]
}
