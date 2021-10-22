terraform {
  backend "s3" {
	bucket = "eks-bucket-dev"
    	key    = "dev/terraform.tfstate"
    	region = "eu-west-1"
  }
}