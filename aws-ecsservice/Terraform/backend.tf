terraform {
  backend "s3" {
	bucket = "zip-api-bucket"
    	key    = "dev/terraform.tfstate"
    	region = "eu-west-1"
  }
}