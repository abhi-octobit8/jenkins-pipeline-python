provider "google" {
  credentials = file("path/to/your/credentials.json")
  project     = "your-project-id"
  region      = "us-central1" # Replace with your desired region
}

resource "google_container_cluster" "my_cluster" {
  name     = "my-gke-cluster"
  location = "us-central1" # Replace with your desired region

  remove_default_node_pool = true

  node_pool {
    name               = "default-pool"
    initial_node_count = 1
    version            = "1.21.5" # Replace with your desired GKE version
    node_config {
      machine_type = "n1-standard-2" # Replace with your desired machine type
      oauth_scopes = [
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
      ]
    }
  }
}

# Output the kubeconfig file for kubectl
output "kubeconfig" {
  value = google_container_cluster.my_cluster.kube_config[0].raw_config
}
