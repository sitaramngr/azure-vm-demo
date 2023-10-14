
resource "azurerm_public_ip" "frontend_load_balancer" {
  name                = "pip-lb-${var.application_name}-${var.environment_name}-frontend"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "frontend" {
  name                = "lb-${var.application_name}-${var.environment_name}-frontend"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.frontend_load_balancer.id
  }
}
resource "azurerm_lb_backend_address_pool" "frontend" {
  loadbalancer_id    = azurerm_lb.frontend.id
  name               = "frontend-pool"
  virtual_network_id = azurerm_virtual_network.main.id
}

# connects the Backend Address Pool to the Load Balancer's Frontend IP Configuration
resource "azurerm_lb_backend_address_pool_address" "frontend" {
  name                                = "frontend-pool-address"
  backend_address_pool_id             = azurerm_lb_backend_address_pool.frontend.id
  backend_address_ip_configuration_id = azurerm_lb.frontend.frontend_ip_configuration[0].id
}

resource "azurerm_lb_nat_rule" "frontend_http" {
  resource_group_name            = azurerm_resource_group.main.name
  loadbalancer_id                = azurerm_lb.frontend.id
  name                           = "HTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 5000
  frontend_ip_configuration_name = "PublicIPAddress"
}
