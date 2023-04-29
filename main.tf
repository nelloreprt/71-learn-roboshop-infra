module "vpc" {
  source = // "github.com/nelloreprt/71-tf-module-vpc.git"
  env = var.env

  for_each = var.vpc     # iteration at vpc_level
  vpc_cidr = each.value.vpc_cidr

  tags = var.tags
  public_subnets = each.value.public_subnets
  private_subnets = each.value.private_subnets
  default_vpc_id = var.default_vpc_id
  default_route_table = var.default_route_table

}