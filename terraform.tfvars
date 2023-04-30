#/ We need to create tags which is common to all the environments (for both prod/dev).
#/ that is why we are creating tags not at resource level but at root/parent_level

tags = {
    env = var.env
    app_mname = "roboshop"
    business_unit = "ecommerce"
    owner = "ecommerce-robot"
    cost_center = 1001

}

# along with default VPC, default Route Table is required
default_vpc_id = "vpc-asdf1a135a1sdf31a3"
default_route_table = "rtb-asda45a4f34afds65"