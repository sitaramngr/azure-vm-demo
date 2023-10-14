application_name = "fleet-ops"
environment_name = "dev"
primary_region   = "westus2"
frontend_image = {
  name                = "fleetops-frontend-2023.10.5"
  resource_group_name = "rg-packer"
}
frontend_instance_type = "Standard_DS2_v2"
backend_image_name     = "fleetops-backend-2023.10.4"
backend_instance_type  = "Standard_DS2_v2"
domain_name            = "cloud-stack.io"
vpc_cidr_block         = "10.0.0.0/23"
az_count               = 2
admin_username         = "adminuser"