# first S3 bucket shall be already created, to push the state file in remote loaction
# below script to keep the state file in a remote location
terraform {
  backend "s3" {}
}