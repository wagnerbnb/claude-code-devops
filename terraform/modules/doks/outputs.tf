output "cluster_id" {
  description = "ID do cluster DOKS"
  value       = digitalocean_kubernetes_cluster.this.id
}

output "cluster_endpoint" {
  description = "Endpoint da API do cluster DOKS"
  value       = digitalocean_kubernetes_cluster.this.endpoint
}

output "kubeconfig" {
  description = "Kubeconfig para acesso ao cluster"
  value       = digitalocean_kubernetes_cluster.this.kube_config[0].raw_config
  sensitive   = true
}
