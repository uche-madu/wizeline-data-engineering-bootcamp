terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.81.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
  }

  backend "gcs" {
    bucket = "deb-capstone"
    prefix = "terraform/state"
  }
}


