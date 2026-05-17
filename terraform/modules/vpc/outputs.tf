output "vpc_id" {
  description = "ID da VPC criada"
  value       = digitalocean_vpc.this.id
}

output "vpc_urn" {
  description = "URN da VPC criada"
  value       = digitalocean_vpc.this.urn
}
