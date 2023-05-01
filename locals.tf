# these variables will get declared while running terraform_apply
# locals.tf is a variable will come when you do terraform apply,
# so locals.tf file shall be made available in root/parent folder
# these are not predefined variable

locals {
  # output will come as a string
  # private_subnets_id = [ module.vpc["main"].private_subnets["db-az1"].id , module.vpc["main"].private_subnets["db-az1"].id ]

  # we need to convert output to list
  db_subnet_ids =  tolist([ "module.vpc["main"].private_subnets["db-az1"].id" , "module.vpc["main"].private_subnets["db-az1"].id" ])
  web_subnet_ids =  tolist([ "module.vpc["main"].private_subnets["web-az1"].id" , "module.vpc["main"].private_subnets["web-az1"].id" ])
  app_subnet_ids =  tolist([ "module.vpc["main"].private_subnets["app-az1"].id" , "module.vpc["main"].private_subnets["app-az1"].id" ])
}

# note: based on below output of vpc_module, to understand the output and then, Locals is designed
# output "vpc" {
#  value = module.vpc
# }