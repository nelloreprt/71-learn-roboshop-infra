module "vpc" {
  source = github.com/nelloreprt/71-tf-module-vpc.git
  env = var.env

  for_each = var.vpc     # iteration at vpc_level
  vpc_cidr = each.value.vpc_cidr

  tags = var.tags
  public_subnets = each.value.public_subnets
  private_subnets = each.value.private_subnets
  default_vpc_id = var.default_vpc_id
  default_route_table = var.default_route_table

}

module "docdb" {
  source = github.com/nelloreprt/v71-tf-module-docdb.git
  env = var.env
  tags = var.tags

  for_each = var.docdb
  engine = each.value.engine
  backup_retention_period = each.value.backup_retention_period
  preferred_backup_window = each.value.preferred_backup_window
  skip_final_snapshot     = each.value.skip_final_snapshot
  engine_version = each.value.engine_version

  subnet_ids = local.db_subnet_ids

  no_of_instances = each.value.no_of_instances
  instance_class = each.value.instance_class
}

module "rds" {
  source = github.com/nelloreprt/71-tf-module-rds.git
  env = var.env
  tags = var.tags

  subnet_ids = local.db_subnet_ids

  no_of_instances = each.value.no_of_instances
  instance_class = each.value.instance_class

  for_each = var.rds
  engine                  = each.value.engine
  engine_version          = each.value.engine_version
  database_name = each.value.database_name
  backup_retention_period = each.value.backup_retention_period
  preferred_backup_window = each.value.preferred_backup_window
}

#
# output "vpc" {
#        value = local.db_subnet_ids
# }


module "elasticache" {
  source = github.com/nelloreprt/71-tf-module-elasticache.git
  env = var.env
  tags = var.tags
  subnet_ids = local.db_subnet_ids

  for_each = var.elasticache
  engine                  = each.value.engine
  engine_version          = each.value.engine_version
  node_type               = each.value.node_type
  num_cache_nodes = each.value.num_cache_nodes

}


module "rabbitmq" {
  source = github.com/nelloreprt/71-tf-module-rabbitmq.git
  env = var.env
  tags = var.tags

  subnet_ids = local.db_subnet_ids

  for_each = var.rabbitmq
  instance_type    = each.value.instance_type

}