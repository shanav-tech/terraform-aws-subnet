provider "aws" {
  region = "us-east-1"
}

##-----------------------------------------------------------------------------
## Vpc Module call.
##-----------------------------------------------------------------------------
module "vpc" {
  source                              = "git::https://github.com/shanav-tech/terraform-aws-vpc.git?ref=v1.0.0"
  name                                = "app"
  environment                         = "test"
  cidr_block                          = "10.0.0.0/16"
  enable_flow_log                     = true # Flow logs will be stored in cloudwatch log group. Variables passed in default.
  create_flow_log_cloudwatch_iam_role = true
}

##-----------------------------------------------------------------------------
## Subnet Module call.
##-----------------------------------------------------------------------------

module "subnets" {
  source                                         = "./../../"
  name                                           = "app"
  environment                                    = "test"
  nat_gateway_enabled                            = true
  availability_zones                             = ["us-east-1a", "us-east-1b"]
  vpc_id                                         = module.vpc.id
  type                                           = "public-private"
  igw_id                                         = module.vpc.igw_id
  cidr_block                                     = module.vpc.vpc_cidr_block
  ipv6_cidr_block                                = module.vpc.ipv6_cidr_block
  public_subnet_assign_ipv6_address_on_creation  = true
  enable_ipv6                                    = true
  private_subnet_assign_ipv6_address_on_creation = true

}
