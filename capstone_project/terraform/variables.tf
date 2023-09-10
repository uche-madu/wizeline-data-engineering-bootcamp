variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "credentials_file" {
  description = "Path to the Google Cloud credentials file"
  type        = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "network_name" {
  type = string
}

variable "subnet-01" {
  type = string
}

variable "subnet-02" {
  type = string
}



# GKE
variable "gke_cluster" {
  type = string
}
variable "node_pool_name" {
  type = string
}
variable "machine_type" {
  type = string
}
variable "node_count" {
  type = number
}


# Services
variable "enable_apis" {
  type = bool
}
variable "disable_services_on_destroy" {
  type = bool
}
variable "disable_dependent_services" {
  type = bool
}

# variable "gcp_services" {
#   type        = list(any)
#   description = "GCP services to enable"
# }