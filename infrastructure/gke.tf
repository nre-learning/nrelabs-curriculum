# https://www.youtube.com/watch?v=B16YTeSs1hI


# resource "google_container_node_pool" "antidote-workers" {
#   name       = "antidote-workers"
#   project   = "${var.project}"
#   zone    = "${var.zone}"
#   cluster    = "${google_container_cluster.primary.name}"
#   node_count = 3
#   autoscaling = {
#       min_node_count = 3
#       max_node_count = 5
#   }
# #   node_config {
# #     oauth_scopes = [
# #     #   "https://www.googleapis.com/auth/compute",
# #     #   "https://www.googleapis.com/auth/devstorage.read_only",
# #     #   "https://www.googleapis.com/auth/logging.write",
# #     #   "https://www.googleapis.com/auth/monitoring",
# #     #   "https://www.googleapis.com/auth/cloud-platform",
# #     #   "https://www.googleapis.com/auth/gke-default",
# #         "monitoring"
# #     ]
# #     # guest_accelerator {
# #     #   type  = "nvidia-tesla-k80"
# #     #   count = 1
# #     # }
# #   }
# }
# https://cloud.google.com/kubernetes-engine/docs/tutorials/http-balancer

resource "google_container_cluster" "primary" {
  name               = "antidote-cluster"
  project   = "${var.project}"
  zone    = "${var.zone}"
  remove_default_node_pool = true

  master_auth {
    username = "mierdin"
    password = "${var.k8s_master_password}"
  }

  node_pool {
    name = "default-pool"
  }
}

resource "google_container_node_pool" "primary_pool" {
  name       = "antidote-container-node-pool"
  cluster    = "${google_container_cluster.primary.name}"
  project   = "${var.project}"
  zone    = "${var.zone}"
  node_count = "3"



  node_config {
    # 8 vCPUs, 30GB RAM
    machine_type = "n1-standard-16"

    image_type = "ubuntu"
  }
}



# resource "google_container_cluster" "primary" {
#   name               = "antidote-cluster"
#   project   = "${var.project}"
# #   region    = "${var.region}"
#   zone    = "${var.zone}"
#   initial_node_count = 3
#   remove_default_node_pool = true
# #   node_pool = [
# #       "${google_container_node_pool.antidote-workers.self_link}"
# #   ]

# #   additional_zones = [
# #     "${var.zone2}",
# #     "${var.zone3}",
# #   ]

#   # 8 vCPUs, 30GB RAM
# #   machine_type = "n1-standard-16"

#   master_auth {
#     username = "mierdin"
#     password = "${var.k8s_master_password}"
#   }

# # --scopes logging-write,monitoring-write,service-management,compute-rw,storage-rw,monitoring,pubsub,service-acontrol,service-management,sql-admin,trace,cloud-platform

# #   node_config {
# #     oauth_scopes = [
# #     #   "https://www.googleapis.com/auth/compute",
# #     #   "https://www.googleapis.com/auth/devstorage.read_only",
# #     #   "https://www.googleapis.com/auth/logging.write",
# #     #   "https://www.googleapis.com/auth/monitoring",
# #     #   "https://www.googleapis.com/auth/cloud-platform",
# #         "monitoring"
# #     ]
# #   }
# }

# The following outputs allow authentication and connectivity to the GKE Cluster.
output "client_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.primary.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
}


output "endpoint" {
  value = "${google_container_cluster.primary.endpoint}"
}

# output "instanceGroupUrls" {
#   value = "${google_container_node_pool.antidote-workers.instance_group_urls}"
# }
