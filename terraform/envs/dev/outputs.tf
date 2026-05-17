output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.vpc.vpc_id
}

output "vpc_urn" {
  description = "URN da VPC criada"
  value       = module.vpc.vpc_urn
}

output "cluster_id" {
  description = "ID do cluster DOKS"
  value       = module.doks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint da API do cluster DOKS"
  value       = module.doks.cluster_endpoint
}

output "kubeconfig" {
  description = "Kubeconfig para acesso ao cluster"
  value       = module.doks.kubeconfig
  sensitive   = true
}
