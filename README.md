AZURE AKS PROVISIONING USING TERRAFORM :

1. Define the Required Providers
Defines the necessary provider required for deploying resources. The azurerm provider is specified with a version to ensure compatibility with Azure services.

2. Configure the Azure Provider
Configures the Microsoft Azure provider, enabling Terraform to interact with Azure services. It includes default features required for managing Azure resources.

3. Create a Resource Group
Defines a resource group, which acts as a container for managing related Azure resources. The resource group is created in a specified location and tagged for identification.

4. Create a Virtual Network
Creates a virtual network (VNet) within the resource group. This VNet allows resources to communicate securely within an isolated network.

5. Create a Subnet
Defines a subnet within the virtual network. The subnet segments the network, allowing different Azure services to be logically grouped.

6. Create a Network Security Group (NSG)
Deploys a Network Security Group (NSG) to control inbound and outbound traffic for network resources. The NSG is assigned to the resource group.

7. Create a Network Security Rule
Defines a security rule within the NSG to allow or restrict specific types of traffic based on direction, protocol, and port ranges.

8. Associate the NSG with the Subnet
Links the Network Security Group (NSG) to the previously created subnet, ensuring traffic is filtered according to the defined security rules.

9. Create a Public IP Address
Allocates a dynamic public IP address, which can be assigned to a virtual machine or other network resources that require external access.

10. Create a Network Interface (NIC)
Creates a Network Interface (NIC) that enables a virtual machine to communicate within the virtual network. It includes private and public IP configurations.

11. Generate an SSH Key Pair
Creates an RSA-based SSH key pair for secure authentication when accessing virtual machines or Kubernetes clusters.

12. Create an Azure Kubernetes Cluster (AKS)
Deploys an Azure Kubernetes Service (AKS) cluster with a specified version and node pool. The cluster is assigned a system identity for managing resources.

13. Output Kubernetes Configuration
Provides the Kubernetes cluster configuration, including the client certificate and kubeconfig file, allowing secure access to the AKS cluster.


TO CONNECT TO AZURE PORTAL FROM GITHUB
Create a service principal and configure its access to Azure resources, and extract the authentication info below.
az ad sp create-for-rbac --name "sol-aks-poc" --role="Contributor" --scopes="/subscriptions/my-subscription-id" --sdk-auth

Add the below in Azure-CREDENTIAL to authenticate to azure portal
{
  "clientId": "******************************************",
  "clientSecret": "**************************************",
  "subscriptionId": "*************************************",
  "tenantId": "*******************************************"
}

Get the RESOURCE GROUP and CLUSTER NAME
$ az group list

GET CREDENTIALS TO VIEW K8s NODES AND PODS
az aks get-credentials --resource-group resource_group_name --name kubernetes_cluster_name

VERIFY
kubectl get nodes
kubectl get pods -A
kubectl get svc




