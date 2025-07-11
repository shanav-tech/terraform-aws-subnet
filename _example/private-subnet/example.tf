provider "aws" {
  region = "us-east-1"
}

##-----------------------------------------------------------------------------
## VPC Module call.
##-----------------------------------------------------------------------------
module "vpc" {
  source                              = "git::https://github.com/shanav-tech/terraform-aws-vpc.git?ref=v1.0.0"
  name                                = "app"
  environment                         = "test"
  cidr_block                          = "10.0.0.0/16"
  enable_flow_log                     = false
  create_flow_log_cloudwatch_iam_role = false
  additional_cidr_block               = ["172.3.0.0/16", "172.2.0.0/16"]
  dhcp_options_domain_name            = "service.consul"
  dhcp_options_domain_name_servers    = ["127.0.0.1", "10.10.0.2"]
  assign_generated_ipv6_cidr_block    = true
}

##-----------------------------------------------------------------------------
## Subnet Module call.
##-----------------------------------------------------------------------------
module "private-subnets" {
  source      = "./../../"
  name        = "app"
  environment = "test"
  type        = "public-private"

  availability_zones = ["us-east-1a"]
  vpc_id             = module.vpc.id
  cidr_block         = module.vpc.vpc_cidr_block
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block

  ipv4_public_cidrs  = ["10.0.1.0/24"]
  ipv4_private_cidrs = ["10.0.3.0/24"]
  igw_id             = module.vpc.igw_id

  nat_gateway_enabled = true
  single_nat_gateway  = true

  enable             = true
  enable_flow_log    = false
  enable_ipv6        = true
  enable_private_acl = true

  private_subnet_assign_ipv6_address_on_creation                = false
  private_subnet_ipv6_native                                    = false
  private_subnet_private_dns_hostname_type_on_launch            = null
  private_subnet_enable_resource_name_dns_a_record_on_launch    = false
  private_subnet_enable_resource_name_dns_aaaa_record_on_launch = false
  private_subnet_enable_dns64                                   = false

  nat_gateway_destination_cidr_block = "0.0.0.0/0"
  public_rt_ipv4_destination_cidr    = "0.0.0.0/0"
  public_rt_ipv6_destination_cidr    = "::/0"
}
