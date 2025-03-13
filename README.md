# TERRRAFORM-AKS-PROV
This is a POC AKS cluster deployment using Terraform

# Terraform AKS Provisioning

This repository contains Terraform configurations to provision an Azure Kubernetes Service (AKS) cluster along with necessary network resources.

## Prerequisites
- Terraform 1.0.0 or later
- Azure CLI
- An Azure subscription

## Introduction
This Terraform configuration provisions a resource group, virtual network, subnet, network security group, public IP, network interface, and an AKS cluster in Microsoft Azure.

## Steps

1. **Clone the repository**
    git clone https://github.com/mulukelem/terraform-aks-prov.git
    cd terraform-aks-prov
   ```
2. **Initialize Terraform**

       terraform init
    ```
4. **Create a `terraform.tfvars` file**

    Create a `terraform.tfvars` file in the same directory with the following content:

    ```hcl
    resource_group_name = "your_resource_group_name"
    location = "your_location"
    tags = {
      environment = "poc"
    }
    azurerm_virtual_network = "your_virtual_network_name"
    azurerm_subnet = "your_subnet_name"
    azurerm_network_security_group = "your_network_security_group_name"
    azurerm_network_security_rule = "your_network_security_rule_name"
    ```

5. **Apply the Terraform configuration**

    terraform apply
    ```

    Confirm the apply with `yes`.

## Resources

The following resources are created by this Terraform configuration:

- **Azure Resource Group**

  resource "azurerm_resource_group" "poc-rg" {
    name     = "${var.resource_group_name}"
    location = "${var.location}"
    tags     = "${var.tags}"
  }

- **Azure Virtual Network
- 
  resource "azurerm_virtual_network" "poc-vn" {
  name                = "${var.azurerm_virtual_network}"
  resource_group_name = azurerm_resource_group.poc-rg.name
  location            = "${var.location}"
  address_space       = ["10.0.0.0/16"]

}

- **Azure Subnet
resource "azurerm_subnet" "poc-subnet" {
  name                 = "${var.azurerm_subnet}"
  resource_group_name  = azurerm_resource_group.poc-rg.name
  virtual_network_name = azurerm_virtual_network.poc-vn.name
  address_prefixes     = ["10.0.1.0/24"]
}

- **Azure Network Security Group
resource "azurerm_network_security_group" "poc-nsg" {
  name                = "${var.azurerm_network_security_group}"
  location            = "${var.location}"
  resource_group_name = azurerm_resource_group.poc-rg.name

  tags = {
    environment = "poc"
  }
}

- **Azure Network Security Rule
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

- **Azure Subnet Network Security Group Association
resource "azurerm_subnet_network_security_group_association" "poc-sga" {
  subnet_id                 = azurerm_subnet.poc-subnet.id
  network_security_group_id = azurerm_network_security_group.poc-nsg.id
}

- **Azure Public IP
resource "azurerm_public_ip" "poc-ip" {
  name                = "sol-poc-ip"
  resource_group_name = azurerm_resource_group.poc-rg.name
  location            = "${var.location}"
  allocation_method   = "Dynamic"

  tags = {
    environment = "poc"
  }
}

- **Azure Network Interface
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

- **TLS Private Key
resource "tls_private_key" "poc_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

- **Azure Kubernetes Service (AKS) Cluster
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

- **Output Client Certificate
output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks-cluster.kube_config[0].client_certificate
  sensitive = true
}

- **Output Kube Config
output "kube_config" {
  value = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
  sensitive = true
}

After running the above steps, you will have a fully functional AKS cluster along with the necessary network resources provisioned in your Azure subscription. 
You can manage and interact with your AKS cluster using standard Kubernetes tools like kubectl.


