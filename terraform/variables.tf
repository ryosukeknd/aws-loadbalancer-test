# Variables
# ### 環境ごとに変更する部分 #########################################
variable "region" {
    default = "us-west-2"
}

variable "environment" {
    default = "poc"
}
# END  環境ごとに変更する部分 #########################################

variable "service" {
    default = "aws-loadbalancer-test"
}
variable "s_service" {
    default = "aws-loadbalancer-test"
}

# Tag
locals {
    tags = {
        CmBillingGroup = "n_poc"
        env            = "${var.environment}"
        stack          = "poc-${var.s_service}"
        service        = "${var.service}"
        version        = "terraform_1.0"
    }
}
