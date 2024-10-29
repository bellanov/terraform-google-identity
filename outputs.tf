# Outputs
# 
# Output values make information about your infrastructure available on the command line, 
# and can expose information for other Terraform configurations to use.
#================================================

output "service_accounts" {
  description = "Service Accounts."
  value       = { for sa in google_service_account.sa : sa.account_id => tomap({ "id" = sa.id, "email" = sa.email }) }
}
