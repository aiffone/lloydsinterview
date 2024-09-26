# main.tf

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  description = "The project ID to deploy to"
}

variable "region" {
  description = "The region to deploy to"
  default     = "europe-west1"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  default     = "infra1-gke-cluster"
}

variable "network_name" {
  description = "The name of the VPC network"
  default     = "infra1-vpc-network"
}

variable "subnetwork_name" {
  description = "The name of the VPC subnetwork"
  default     = "infra-subnetwork"
}