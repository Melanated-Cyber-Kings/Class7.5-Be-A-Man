output "static_site_url" {
  value = "https://${google_storage_bucket.my_bucket.name}.storage.googleapis.com/index.html"
  description = "The URL of the static website hosted on Google Cloud Storage"
}