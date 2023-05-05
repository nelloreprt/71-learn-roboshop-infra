# any time to add a parameter
name
value
type
are mandatory

# When you use COUNT, all the attributes (output) will come as a list

parameters = [
 {name = "test1" , value = "hello universe" , type = "string"  ,
 {name = "dev.cart.REDIS_HOST", value = "redis-dev.nellore.online" , type = "string" } ,
 {name = "dev.cart.CATALOGUE_HOST", value = "catalogue-dev.nellore.online" , type = "string" } ,
 { name = "dev.catalogue.MONGO", value = "true" , type = "string"  ,
 { name = "dev.catalogue.MONGO_URL", value = "mongodb://mongodb-dev.nellore.online:27017/catalogue" , type = "string" } ,

# The Frontend is communicating to the components over the LoadBalancer, but The LoadBalancer listens on Port_80, so we need to update port_8080 to port_80.
# Each and every component will be accessed by Frontend over LoadBalancer
 { name = "dev.frontend.CATALOGUE_URL", value = "http://catalogue-dev.nellore.online:80/" , type = "string" } ,
 { name = "dev.frontend.USER_URL", value = "http://user-dev.nellore.online:80/" , type = "string" } ,
 { name = "dev.frontend.CART_URL", value = "http://cart-dev.nellore.online:80/" , type = "string" } ,
 { name = "dev.frontend.SHIPPING_URL", value = "http://shipping-dev.nellore.online:80/" , type = "string" } ,
 { name = "dev.frontend.PAYMENT_URL", value = "http://payment-dev.nellore.online:80/" , type = "string" } ,

 { name = "dev.payment.CART_HOST", value = "cart-dev.nellore.online" , type = "string" } ,
 { name = "dev.payment.CART_PORT", value = "8080" , type = "string" } ,
 { name = "dev.payment.USER_HOST", value = "user-dev.nellore.online" , type = "string" } ,
 { name = "dev.payment.USER_PORT", value = "8080" , type = "string" } ,
 { name = "dev.payment.AMQP_HOST", value = "rabbitmq-dev.nellore.online" , type = "string" } ,
 { name = "dev.payment.AMQP_USER", value = "roboshop"  , type = "string" } ,
 { name = "dev.shipping.CART_ENDPOINT", value = "cart-dev.nellore.online:8080" , type = "string" } ,
 { name = "dev.shipping.DB_HOST", value = "mysql-dev.nellore.online" , type = "string" } ,
 { name = "dev.user.MONGO", value = "true" , type = "string" } ,
 { name = "dev.user.MONGO_URL", value = "mongodb://mongodb-dev.nellore.online:27017/users" , type = "string" } ,
 { name = "dev.user.REDIS_HOST", value = "redis-dev.nellore.online" , type = "string" } ,

]

secrets = [
# {name = "test1" , value = "hello universe" , type = "string"  ,
{ name = "dev.docdb.user", value = "admin1" , type = "SecureString" } ,    # creating docdb parameter for USER
{ name = "dev.docdb.pass", value = "RoboShop1" , type = "SecureString" } , # creating docdb parameter for PASSWORD

]
























