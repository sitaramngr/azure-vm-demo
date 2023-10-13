source "azure-arm" "vm" {
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id

  location                          = var.azure_primary_location
  managed_image_name                = "${var.image_name}-${var.image_version}"
  managed_image_resource_group_name = var.resource_group_name

  communicator                      = "ssh"
  os_type                           = "Linux"
  vm_size                           = var.vm_size
  allowed_inbound_ip_addresses      = [var.agent_ipaddress]

}