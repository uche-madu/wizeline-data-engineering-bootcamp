# resource "google_storage_bucket" "terraform_state_bucket" {
#   name          = "terraform-state" 
#   location      = "US"  
#   uniform_bucket_level_access = true
#   force_destroy = true  # WARNING: This allows Terraform to destroy the bucket and its contents
# }
