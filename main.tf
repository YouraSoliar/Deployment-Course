## PREPARATION
provider "azurerm" {
  version = "=2.86.0"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "EmbeddedSoliar"
  location = "eastus"
}

resource "azurerm_availability_set" "DemoAset" {
  name                = "demoAset"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

## VIRTUAL NETWORK
resource "azurerm_virtual_network" "vnet" {
  name                = "vNet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name 
  virtual_network_name = azurerm_virtual_network.vnet.name 
  address_prefix       = "10.0.2.0/24"
}

## IP ADDRESSES
resource "azurerm_public_ip" "ipaddressbalancer" {
  name                = "balancerPublicIp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "ipaddressredis" {
  name                = "redisPublicIp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "ipaddressone" {
  name                = "onePublicIp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_public_ip" "ipaddresstwo" {
  name                = "twoPublicIp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

## INTERFACES
resource "azurerm_network_interface" "interfaceone" {
  name                = "interfaceOne"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name 

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id 
    private_ip_address_allocation = "Static"
    
    private_ip_address = "10.0.2.4"
    public_ip_address_id = azurerm_public_ip.ipaddressone.id
  }
}

resource "azurerm_network_interface" "interfacetwo" {
  name                = "interfaceTwo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name 

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id 
    private_ip_address_allocation = "Static"
    
    private_ip_address = "10.0.2.5"
    public_ip_address_id          = azurerm_public_ip.ipaddresstwo.id
  }
}

resource "azurerm_network_interface" "interfacebalancer" {
  name                = "interfaceBalancer"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name 

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id 
    private_ip_address_allocation = "Static"
    
    private_ip_address = "10.0.2.10"
    public_ip_address_id          = azurerm_public_ip.ipaddressbalancer.id
  }
}

resource "azurerm_network_interface" "interfaceredis" {
  name                = "interfaceRedis"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name 

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id 
    private_ip_address_allocation = "Static"
    
    private_ip_address = "10.0.2.11"
    public_ip_address_id          = azurerm_public_ip.ipaddressredis.id
  }
}

##THIS REDIS IS OK, But so long creating
# resource "azurerm_redis_cache" "redisyurii" {
#   #my unique name
#   name                = "ys-tfgkduiy5rdhntfbihyujhgn"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   capacity            = 2
#   family              = "C"
#   sku_name            = "Standard"
#   enable_non_ssl_port = false
#   minimum_tls_version = "1.2"

#   redis_configuration {
#   }
# }

## BALANCER
# resource "azurerm_lb" "loadbalancer" {
#   name                = "loadBalancer"
#   location            = "eastus"
#   resource_group_name = azurerm_resource_group.rg.name

#   frontend_ip_configuration {
#     name                 = "PublicIPAddress"
#     public_ip_address_id = azurerm_public_ip.ipaddressbalancer.id
#   }
# }

# resource "azurerm_lb_rule" "ruleserverone" {
#   name                           = "LBRule"
#   resource_group_name            = azurerm_resource_group.rg.name
#   loadbalancer_id                = azurerm_lb.loadbalancer.id
#   protocol                       = "Tcp"
#   frontend_port                  = 80
#   backend_port                   = 5000
#   frontend_ip_configuration_name = azurerm_lb.loadbalancer.frontend_ip_configuration[0].name
# }

# resource "azurerm_lb_backend_address_pool" "backend_pool" {
#   name            = "first"
#   loadbalancer_id = azurerm_lb.loadbalancer.id
  
# }

# resource "azurerm_network_interface_backend_address_pool_association" "backend_address_pool_association" {
#   network_interface_id    = azurerm_network_interface.interfacebalancer.id
#   ip_configuration_name   = "internal"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
# }


# resource "azurerm_lb_backend_address_pool_address" "backend_address_pool_address" {
#   name                    = "example"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
#   virtual_network_id      = azurerm_virtual_network.vnet.id
#   ip_address              = "10.0.0.1"
# }

# resource "azurerm_network_interface_backend_address_pool_association" "backend_address_pool_association" {
#   network_interface_id    = azurerm_network_interface.interfaceone.id
#   ip_configuration_name   = azurerm_network_interface.interfaceone.name
#   backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
# }

## VIRTUAL MACHINES
resource "azurerm_linux_virtual_machine" "vmyuriione" {
  name                = "VMYuriiOne"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F1"
  admin_username      = var.SERVER_USERNAME
  admin_password      = var.SERVER_PWD
  disable_password_authentication = false
  availability_set_id = azurerm_availability_set.DemoAset.id 
  network_interface_ids = [
    azurerm_network_interface.interfaceone.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "vmyuriitwo" {
  name                = "VMYuriiTwo"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F1"
  admin_username      = var.SERVER_USERNAME
  admin_password      = var.SERVER_PWD
  disable_password_authentication = false
  availability_set_id = azurerm_availability_set.DemoAset.id 
  network_interface_ids = [
    azurerm_network_interface.interfacetwo.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

## VIRTUAL BALANCER && REDIS
resource "azurerm_linux_virtual_machine" "vmyuriibalancer" {
  name                = "VMYuriiBalancer"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F1"
  admin_username      = var.SERVER_USERNAME
  admin_password      = var.SERVER_PWD
  disable_password_authentication = false
  availability_set_id = azurerm_availability_set.DemoAset.id 
  network_interface_ids = [
    azurerm_network_interface.interfacebalancer.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "vmyuriiredis" {
  name                = "VMYuriiRedis"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F1"
  admin_username      = var.SERVER_USERNAME
  admin_password      = var.SERVER_PWD
  disable_password_authentication = false
  availability_set_id = azurerm_availability_set.DemoAset.id 
  network_interface_ids = [
    azurerm_network_interface.interfaceredis.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}



## OUTPUT
output "public_ip_server_1" {
  value = "${azurerm_public_ip.ipaddressone.ip_address}"
}

output "public_ip_server_2" {
  value = "${azurerm_public_ip.ipaddresstwo.ip_address}"
}

output "public_ip_address_redis" {
  value = "${azurerm_public_ip.ipaddressredis.ip_address}"
}

output "public_ip_address_balancer" {
  value = "${azurerm_public_ip.ipaddressbalancer.ip_address}"
}

