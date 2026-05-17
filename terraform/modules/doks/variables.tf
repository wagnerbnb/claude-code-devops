variable "region" {
  description = "Região da DigitalOcean onde o cluster será criado"
  type        = string
}

variable "cluster_name" {
  description = "Nome do cluster DOKS"
  type        = string
}

variable "node_size" {
  description = "Tipo/tamanho dos nodes (ex: s-2vcpu-2gb)"
  type        = string
}

variable "node_count" {
  description = "Quantidade fixa de nodes no pool"
  type        = number
}

variable "vpc_id" {
  description = "ID da VPC onde o cluster será criado"
  type        = string
}
