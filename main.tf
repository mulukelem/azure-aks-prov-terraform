terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.107.0"
      #version = "=3.1.0"
    }
  }
}

# Configure the Microsoft Azure Provider (required) - Test
provider "azurerm" {
  features {}
}


# Create a resource group - Proof of Concept (POC)
resource "azurerm_resource_group" "poc-rg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
  tags     = "${var.tags}"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "poc-vn" {
  name                = "${var.azurerm_virtual_network}"
  resource_group_name = azurerm_resource_group.poc-rg.name
  location            = "${var.location}"
  address_space       = ["10.0.0.0/16"]
}

# Create a subnets within the resource group and Virtual Network
resource "azurerm_subnet" "poc-subnet" {
  name                 = "${var.azurerm_subnet}"
  resource_group_name  = azurerm_resource_group.poc-rg.name
  virtual_network_name = azurerm_virtual_network.poc-vn.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "poc-nsg" {
  name                = "${var.azurerm_network_security_group}"
  location            = "${var.location}"
  resource_group_name = azurerm_resource_group.poc-rg.name

  tags = {
    environment = "poc"
  }
}

resource "azurerm_network_security_rule" "poc-nsr" {
  name                        = "${var.azurerm_network_security_rule}"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.poc-rg.name
  network_security_group_name = azurerm_network_security_group.poc-nsg.name
}

resource "azurerm_subnet_network_security_group_association" "poc-sga" {
  subnet_id                 = azurerm_subnet.poc-subnet.id
  network_security_group_id = azurerm_network_security_group.poc-nsg.id
}


resource "azurerm_public_ip" "poc-ip" {
  name                = "sol-poc-ip"
  resource_group_name = azurerm_resource_group.poc-rg.name
  location            = "${var.location}"
  allocation_method   = "Dynamic"

  tags = {
    environment = "poc"
  }
}

resource "azurerm_network_interface" "poc-nic" {
  name                = "sol-poc-nic"
  location            = "${var.location}"
  resource_group_name = azurerm_resource_group.poc-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.poc-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.poc-ip.id
  }
}

# Create (and display) an SSH key
resource "tls_private_key" "poc_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name       = "aks"
  location   = azurerm_resource_group.poc-rg.location
  dns_prefix = "aks"

  resource_group_name = azurerm_resource_group.poc-rg.name
  kubernetes_version  = "1.30.0"

  default_node_pool {
    name       = "aks"
    node_count = "1"
    vm_size    = "Standard_D2s_v3"
  }

  identity {
    type = "SystemAssigned"
  }
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw

  sensitive = true
}
