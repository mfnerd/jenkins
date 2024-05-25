terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.27.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = "secondprojecto"
  region = "us-central1"
  zone = "us-central1-a"
  
}
#######################
# create bucket in GCP
#######################
resource "google_storage_bucket" "bucket" {
  name     = "shepz-bucket"
  location = "US"
  force_destroy = true
}
#######################
# iam binding
#######################
resource "google_storage_bucket_iam_binding" "public_read" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}
#######################
# upload file to bucket
#######################
resource "google_storage_bucket_object" "object" {
  name   = "index.html"
  bucket = google_storage_bucket.bucket.name
  source = "index.html"
  content_type = "text/html"
}
#######################
# output public url
#######################
output "public_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/${google_storage_bucket_object.object.name}"
  description = "The public URL to access the index.html"
}
