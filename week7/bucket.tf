#random suffix, bucket names must be globally unique
resource "random_id" "bucket_id" {
  byte_length = 4
}


resource "google_storage_bucket" "my_bucket" {
  name          = "class7-5-theswordpt-gcp-${random_id.bucket_id.hex}"  # The name must be globally unique.
  location      = "US"
  force_destroy = true  # Allows Terraform to delete the bucket even if it contains objects.

  versioning {
    enabled = true  # Optional: Enables versioning for objects stored in the bucket
  }

  lifecycle {
    prevent_destroy = false  # Optional: Set to true to prevent accidental deletion
  }


# had to turn this on, otherwise got errors
  uniform_bucket_level_access = true

  # Static Website Hosting Configuration
  website {
    main_page_suffix = "index.html"   # Default page (e.g., index.html)
    not_found_page   = "404.html"     # Error page (e.g., 404.html)
  }
}



