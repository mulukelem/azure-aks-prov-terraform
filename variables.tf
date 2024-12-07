variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  default     = "sol-poc-rg"
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  default = "East US"
}

variable "tags" {
  description = "A map of the tags to use on the resources that are deployed with this module."
  default = {
    source = "poc"
  }
}

variable "azurerm_subnet" {
  description = "Creates subnets within the resource group and virtual network."
  default = "sol-poc-subnet"
}
variable "azurerm_virtual_network" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
  default = "sol-poc-vn"
}

variable "azurerm_network_security_group" {
  description = "A Network Security Group ID to attach to the network interface"
  default = "sol-poc-nsg"
}

variable "azurerm_network_security_rule" {
  description = "A Network Security Rule to attach to the network interface"
  default = "sol-poc-nsr"
}

variable "azurerm_public_ip" {
  description = "Set Public IP Address"
  default = "sol-poc-ip"
}


variable "azurerm_network_interface" {
  description = "Set Azure Network Interface"
  default = "sol-poc-nic"
}

variable "admin_password" {
  description = "The admin password to be used on the VMSS that will be deployed. The password must meet the complexity requirements of Azure"
  default     = ""
}

variable "ssh_key" {
  description = "Path to the public key to be used for ssh access to the VM.  Only used with non-Windows vms and can be left as-is even if using Windows vms. If specifying a path to a certification on a Windows machine to provision a linux vm use the / in the path versus backslash. e.g. c:/home/id_rsa.pub"
  default     = "~/.ssh/id_rsa.pub"
}

variable "remote_port" {
  description = "Remote tcp port to be used for access to the vms created via the nsg applied to the nics."
  default     = ""
}

variable "admin_username" {
  description = "The admin username of the VM that will be deployed"
  default     = "adminuser"
}

variable "storage_account_type" {
  description = "Defines the type of storage account to be created. Valid options are Standard_LRS, Standard_ZRS, Standard_GRS, Standard_RAGRS, Premium_LRS."
  default     = "Premium_LRS"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_F2"
}
