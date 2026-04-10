variable "resource_group_name" {
  description = "Azure resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "acr_name" {
  description = "Azure Container Registry name"
  type        = string
}

variable "aks_cluster_name" {
  description = "AKS cluster name"
  type        = string
}

variable "aks_dns_prefix" {
  description = "AKS DNS prefix"
  type        = string
  default     = "food-delivery"
}

variable "node_count" {
  description = "AKS node count"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "AKS node VM size"
  type        = string
  default     = "Standard_B2s"
}

variable "tags" {
  description = "Tags for all resources"
  type        = map(string)
  default = {
    project = "food-delivery"
    env     = "dev"
  }
}
