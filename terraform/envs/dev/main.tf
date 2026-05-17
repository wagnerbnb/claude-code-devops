module "vpc" {
  source = "../../modules/vpc"
  name   = var.vpc_name
  region = var.region
}

module "doks" {
  source       = "../../modules/doks"
  region       = var.region
  cluster_name = var.cluster_name
  node_size    = var.node_size
  node_count   = var.node_count
  vpc_id       = module.vpc.vpc_id
}
