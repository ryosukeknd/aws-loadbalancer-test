terraform {
    backend "s3" {
        bucket  = "poc-tfstate-artifact"
        key     = "terraform/poc/aws-loadbalancer-test/terraform.tfstate"
        region  = "us-west-2"
        profile = "fg-poc"
        encrypt = true
    }
}
