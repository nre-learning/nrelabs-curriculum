resource "google_compute_disk" "centos7_disk" {
  name = "centos7-disk"

  project = "${var.project_name}"

  type = "pd-ssd"

  zone  = "${var.zone}"
  image = "${var.os["centos-7"]}"

  size = 350
}

resource "google_compute_disk" "influxdb_disk" {
  name = "influxdb-disk"

  project = "${var.project_name}"

  type = "pd-ssd"

  zone  = "${var.zone}"

  size = 210
}


resource "google_compute_disk" "grafana_disk" {
  name = "grafana-disk"

  project = "${var.project_name}"

  type = "pd-ssd"

  zone  = "${var.zone}"

  size = 210
}
