# count loop will give index no, to access the index number
# >>>> var.instances[count.index]
first iteration will be 0 >> index is 0
2nd iteration will be 1 >> index is 1
3rd iteration will be 2 >> index is 2

resource "aws_ssm_parameter" "parameters" {
count = length(var.parameters)
name  = var.parameters[count.index].name
type  = var.parameters[count.index].type
value = var.parameters[count.index].string
}



variable "parameters" {}

----------------------------------------------------------
# below jenkins.username, jenkins.password are not specific to any prod/dev environment,
# so we are writing in this place, which is a common place

# to store user name (String) & password (SecureString) of JENKINS

resource "aws_ssm_parameter" "jenkins_user" {
name  = "jenkins.user"
type  = "String"
value = "admin"
}

resource "aws_ssm_parameter" "jenkins_pass" {
name  = "jenkins.pass"
type  = "SecureString"
value = "admin"
}