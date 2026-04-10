output "cluster_name" {
  value = azurerm_kubernetes_cluster.main.name
}

output "kubelet_object_id" {
  value = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}
