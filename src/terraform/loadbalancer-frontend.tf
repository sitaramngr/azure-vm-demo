
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
  loadbalancer_id = azurerm_lb.frontend.id
  name            = "frontend-pool"
}

# Connects this Virtual Machine to the Load Balancer's Backend Address Pool
resource "azurerm_network_interface_backend_address_pool_association" "frontend" {

  count = var.az_count

  network_interface_id    = azurerm_network_interface.frontend[count.index].id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.frontend.id

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

resource "azurerm_lb_probe" "frontend_probe_http" {
  loadbalancer_id = azurerm_lb.frontend.id
  name            = "http"
  port            = 5000
  request_path    = "/"
}
