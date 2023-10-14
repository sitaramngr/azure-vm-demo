resource "azurerm_network_security_group" "frontend" {

  name                = "nsg-${var.application_name}-${var.environment_name}-frontend"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

}

resource "azurerm_network_security_rule" "frontend_http" {

  resource_group_name          = azurerm_resource_group.main.name
  network_security_group_name  = azurerm_network_security_group.frontend.name
  name                         = "allow-http"
  priority                     = "2005"
  access                       = "Allow"
  direction                    = "Inbound"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_range       = "80"
  source_address_prefix        = "*"
  destination_address_prefixes = azurerm_subnet.frontend.address_prefixes

}