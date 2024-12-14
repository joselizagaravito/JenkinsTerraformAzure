output "kube_config" {
  value       = azurerm_kubernetes_cluster.aks.kube_config_raw
  description = "Kubernetes config for AKS"
  sensitive   = true
}
