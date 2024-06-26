provider "aws" {
  region = var.region

  default_tags {
    tags = var.tags
  }
}

terraform {
  backend "s3" {
    bucket = "or-asraf-demo"
    region = var.region
  }
}

