# Línea base: cuenta de almacenamiento con configuración razonable.
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "app" {
  name     = "rg-demo-app"
  location = "eastus"
}

resource "azurerm_storage_account" "datos" {
  name                            = "stdemodatos001"
  resource_group_name             = azurerm_resource_group.app.name
  location                        = azurerm_resource_group.app.location
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
}

# Cambio del PR: cuenta para compartir reportes con un proveedor externo.
resource "azurerm_storage_account" "reportes" {
  name                            = "stdemoreportes001"
  resource_group_name             = azurerm_resource_group.app.name
  location                        = azurerm_resource_group.app.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  https_traffic_only_enabled      = false
  min_tls_version                 = "TLS1_0"
  allow_nested_items_to_be_public = true
}

# Acceso de administración "temporal" a la VM de reportes.
resource "azurerm_network_security_group" "admin" {
  name                = "nsg-reportes-admin"
  location            = azurerm_resource_group.app.location
  resource_group_name = azurerm_resource_group.app.name

  security_rule {
    name                       = "ssh-desde-internet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
