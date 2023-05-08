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

  allow_subnets = lookup(local.subnet_cidr, each.value.allow_subnets, null)

  vpc_id = module.vpc["main"].vpc_id     # output block of entire VPC is considered for syntax
  # Synyax >> module.module_name.output_block_name
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

  allow_subnets = lookup(local.subnet_cidr, each.value.allow_subnets, null)
  vpc_id = module.vpc["main"].vpc_id     # output block of entire VPC is considered for syntax
  # Synyax >> module.module_name.output_block_name
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

  allow_subnets = lookup(local.subnet_cidr, each.value.allow_subnets, null)
  vpc_id = module.vpc["main"].vpc_id     # output block of entire VPC is considered for syntax
  # Synyax >> module.module_name.output_block_name
}


module "rabbitmq" {
  source = github.com/nelloreprt/71-tf-module-rabbitmq.git
  env = var.env
  tags = var.tags

  subnet_ids = local.db_subnet_ids
  # all the databases don't have any different subnets, it is always the same subnets

  for_each = var.rabbitmq
  instance_type    = each.value.instance_type

  allow_subnets = lookup(local.subnet_cidr, each.value.allow_subnets, null)
  vpc_id = module.vpc["main"].vpc_id     # output block of entire VPC is considered for syntax
  # Synyax >> module.module_name.output_block_name

  dns_domain = var.dns_domain
  bastion_cidr = var.bastion_cidr
}

module "alb" {
  source = github.com/nelloreprt/71-tf-module-alb.git
  env = var.env
  tags = var.tags

  subnet_ids = lookup(local.subnet_ids, each.value.subnet_name, null)
  # local + for_each iteration + lookup
  # as we are using for_each loop >> we have to go with " each.value.subnet_name "
  # and this "subnet_name" should come as a input from " main.tfvars "

  # lookup(local.subnet_ids, app, null)
  # lookup function will look for app_value in local.subnet_ids, if no value it will return as "null"

  # lookup(local.subnet_ids, web, null)
  # lookup function will look for web_value in local.subnet_ids, if no value it will return as "null"

  for_each = var.alb
  name               = each.value.name
  internal           = each.value.internal
  load_balancer_type = each.value.load_balancer_type
  enable_deletion_protection = each.value.enable_deletion_protection

  vpc_id = module.vpc["main"].vpc_id     # output block of entire VPC is considered for syntax
# Synyax >> module.module_name.output_block_name

  allow_cidr = each.value.allow_cidr
}

module "app" {
  depends_on = [module.docdb, module.elasticache, module.rabbitmq, module.rds, module.alb]

  source = github.com/nelloreprt/71-tf-module-app.git
  env = var.env
  tags = var.tags

  subnet_ids = lookup(local.subnet_ids, each.value.subnet_name, null)

  for_each = var.app
  instance_type    = each.value.instance_type
  component = each.value.component
  desired_capacity = each.value.desired_capacity
  max_size = each.value.max_size
  min_size = each.value.min_size

  vpc_id = module.vpc["main"].vpc_id

  dns_domain = var.dns_domain
  bastion_cidr = var.bastion_cidr

  port = each.value.port

  # we want cidr number not subnet_id
  allow_app_to = lookup(local.subnet_cidr, each.value.allow_app_to, null)

  alb_dns_domain = lookup(lookup(lookup(module.alb, each.value.alb, null) "alb", null) "dns_name" ,null) #  each.value.alb >> will come as input from main.tfvars

  listener_arn = lookup(lookup(lookup(module.alb, each.value.alb, null) "listener", null) "arn" ,null)

  listener_priority = each.value.listener_priority

  parameters = each.value.parameters  # used on locals.tf using concat_function in app-module / locals.tf
}

# value for >> " alb_dns_domain " >> is formulated using
output "alb" {
  value = "module.alb"
}

# elasticache module output is obtained using >> because we want ENDPOINT of elasticache
output "redis" {
  value = "module.elasticache"
}



- name: Load Schema rds-mysql
  ansible.builtin.shell: mysql -h {{ lookup('amazon.aws.aws_ssm', '{{env}}.rds.endpoint', region='us-east-1') }} -u{{ lookup('amazon.aws.aws_ssm', '{{env}}.rds.user', region='us-east-1') }} -p{{ lookup('amazon.aws.aws_ssm', '{{env}}.rds.pass', region='us-east-1') }} < /app/schema/{{component}}.sql