# GCS Static Site POC — README

## Project goal  
Deploy a proof-of-concept static website fully automated using a Google Cloud Storage (GCS) bucket, containing provided sample assets plus one additional image.

## What I built
- Automated deployment using Terraform to provision a GCS bucket and related resources, plus scripts to upload site files.  
- Static site files hosted in the GCS bucket (HTML/CSS/JS, sample assets, and one chosen image).  


## How to run / reproduce
1. Install Terraform, gcloud, and gsutil.  
2. Create/activate a GCP project and enable the Storage API.  
3. Edit Terraform variables (e.g., project ID, bucket name).  
4. Run:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
5. Verify by visiting the bucket website endpoint or configured domain.

## Files included
- `0-authentication.tf`, `bucket.tf`, `outputs.tf`, `upload.tf` — Terraform configuration to create the bucket and website resources.
- `index.html` — main page (single-page app style) 
- `style.css` -- style sheet 
- `404.html` — custom not-found page (note: see known GCS limitation below)  
- `image.jpg` — additional image added  


## Known limitations
- GCS website hosting does not fully support single-page-app routing or client-side fallback for all requests; navigating directly to non-root routes can return a bucket XML error ("NoSuchKey") instead of serving `404.html`. This is a known limitation: https://www.reddit.com/r/googlecloud/comments/rvhki2/hosting_a_single_page_app_on_gcs_and_an_https/

## Notes / next steps
- Implement URL rewrite using a Cloud Load Balancer with Backend Bucket and URL map (provisioned via Terraform) for proper SPA routing and nicer 404 handling.  
- Convert the upload script to a Terraform null_resource or use Cloud Build for automated CI/CD deployments.  
- Add IAM hardening and lifecycle rules in Terraform for production readiness.
