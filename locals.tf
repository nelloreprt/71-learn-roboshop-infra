# these variables will get declared while running terraform_apply
# locals.tf is a variable will come when you do terraform apply,
# so locals.tf file shall be made available in root/parent folder
# these are not predefined variable

locals {
  # output will come as a string
  # private_subnets_id = [ module.vpc["main"].private_subnets["db-az1"].id , module.vpc["main"].private_subnets["db-az1"].id ]

  # we need to convert output to list
  db_subnet_ids =  tolist([ "module.vpc["main"].private_subnets["db-az1"].id" , "module.vpc["main"].private_subnets["db-az2"].id" ])
  web_subnet_ids =  tolist([ "module.vpc["main"].private_subnets["web-az1"].id" , "module.vpc["main"].private_subnets["web-az2"].id" ])
  app_subnet_ids =  tolist([ "module.vpc["main"].private_subnets["app-az1"].id" , "module.vpc["main"].private_subnets["app-az2"].id" ])

  subnet_ids = {
    db = tolist([ "module.vpc["main"].private_subnets["db-az1"].id" , "module.vpc["main"].private_subnets["db-az2"].id" ])
    web = tolist([ "module.vpc["main"].private_subnets["web-az1"].id" , "module.vpc["main"].private_subnets["web-az2"].id" ])
    app = tolist([ "module.vpc["main"].private_subnets["app-az1"].id" , "module.vpc["main"].private_subnets["app-az2"].id" ])
    public = tolist([ "module.vpc["main"].public_subnets["public-az1"].id" , "module.vpc["main"].private_subnets["public-az2"].id" ])
  }

  # after sub_net creation, if we want cidr, use >> " cidr_block " inplace of "id"
  subnet_cidr = {
    db = tolist([ "module.vpc["main"].private_subnets["db-az1"].cidr_block" , "module.vpc["main"].private_subnets["db-az2"].cidr_block" ])
    web = tolist([ "module.vpc["main"].private_subnets["web-az1"].cidr_block" , "module.vpc["main"].private_subnets["web-az2"].cidr_block" ])
    app = tolist([ "module.vpc["main"].private_subnets["app-az1"].cidr_block" , "module.vpc["main"].private_subnets["app-az2"].cidr_block" ])
    public = tolist([ "module.vpc["main"].public_subnets["public-az1"].cidr_block" , "module.vpc["main"].private_subnets["public-az2"].cidr_block" ])
  }
}

# note: based on below output of vpc_module, to understand the output and then, Locals is designed
# output "vpc" {
#  value = module.vpc
# }
# /////////////////////////////////////////////////////////////

# to Public_alb >> we want to attach web_subnet_ids (web_subnet_ids is Pvt_Subnets)
# to Private_alb >> we want to attach app_subnet_ids (app_subnet_ids is Pvt_Subnets)