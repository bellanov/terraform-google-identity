# Module Definition
# 
# Contains the main set of configuration for the module.
#================================================

# Use Service Accounts to assign various identities to infrastructure.
resource "google_service_account" "sa" {
  for_each     = var.service_accounts
  account_id   = "${each.key}-identity"
  display_name = each.value.display_name
  project      = var.project
}

# Assign the Terraform identity as a Service Account user.
data "google_iam_policy" "terraform" {
  binding {
    role = "roles/iam.serviceAccountUser"

    members = [
      var.terraform_identity,
    ]
  }
}

# Enable the Terraform identity to assume the role of any user while applying changes.
resource "google_service_account_iam_policy" "terraform_iam" {
  for_each           = var.service_accounts
  service_account_id = each.value.service_account
  policy_data        = data.google_iam_policy.terraform.policy_data

  depends_on = [
    google_service_account.sa
  ]
}
