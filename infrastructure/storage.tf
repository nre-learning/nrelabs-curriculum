resource "google_storage_bucket" "maintenance-page" {
  name     = "maintenance-page"
  location = "US"

  project   = "${var.project}"

  website {
    main_page_suffix = "index.html"
  }
}

resource "google_storage_bucket_object" "index" {
  name   = "index.html"
  source = "./maintenance_page/index.html"
  bucket = "${google_storage_bucket.maintenance-page.name}"
}

resource "google_storage_object_acl" "maintenance-acl" {
  bucket = "${google_storage_bucket.maintenance-page.name}"
  object = "${google_storage_bucket_object.index.name}"
  predefined_acl = "publicRead"
}