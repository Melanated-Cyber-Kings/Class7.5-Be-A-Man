output "vpc_name" {
  description = "The name of the created vpc"
  value       = google_compute_network.vpc_network.name
  sensitive   = false
}