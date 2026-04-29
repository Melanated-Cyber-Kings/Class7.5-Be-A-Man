# Configure the Google Cloud provider with the latest terraform version.
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.29.0"
    }
    
    local = {
      source  = "hashicorp/local"
      version = "2.8.0"
    }
  }
}

provider "google" {
   project     = "fleming-friday-floripa"
  region      = "us-central1"
}