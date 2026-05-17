variable "region" {
  description = "Região da DigitalOcean"
  type        = string
  default     = "nyc1"
}

variable "vpc_name" {
  description = "Nome da VPC do ambiente dev"
  type        = string
  default     = "kube-news-dev"
}

variable "cluster_name" {
  description = "Nome do cluster DOKS"
  type        = string
  default     = "kube-news-dev"
}

variable "node_size" {
  description = "Tipo dos nodes do cluster"
  type        = string
  default     = "s-2vcpu-2gb"
}

variable "node_count" {
  description = "Quantidade de nodes no pool"
  type        = number
  default     = 2
}
