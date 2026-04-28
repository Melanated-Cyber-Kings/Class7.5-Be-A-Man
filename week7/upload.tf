
#grab all the file names
locals {
  txt_files = tolist(fileset(".", "*.html"))
  jpg_files = tolist(fileset(".", "*.jpg"))
  css_files = tolist(fileset(".", "*.css"))
  all_files = concat(local.txt_files, local.jpg_files, local.css_files)
}


# Loop over the `all_files` and upload each file to the GCS bucket
resource "google_storage_bucket_object" "files" {
  for_each = toset(local.all_files)

  bucket = google_storage_bucket.my_bucket.name
  name   = each.value  # Name the object the same as the file's name
  source = each.value  # Path to the local file
}

#got error: googleapi: Error 412: Request violates constraint 'constraints/storage.uniformBucketLevelAccess', conditionNotMet
# Make the objects publicly accessible
# resource "google_storage_object_acl" "public_read" {
#   for_each = toset(local.all_files)

#   bucket = google_storage_bucket.my_bucket.name
#   object = each.value

#   role_entity = [
#     "READER:allUsers"  # This grants public read access
#   ]
# }


#doing this instead
#just made the bucket public
resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.my_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"  # This grants public read access to all users
}