
# Create VPC Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.3"

  # VPC Basic Details
  name                         = var.vpc_name
  cidr                         = var.vpc_cidr_block
  azs                          = var.vpc_availability_zones
  public_subnets               = var.vpc_public_subnets
  private_subnets              = var.vpc_private_subnets
  create_database_subnet_group = var.vpc_create_database_subnet_group

  map_public_ip_on_launch = true

  # NAT Gateways - Outbound Communication
  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway

  enable_dhcp_options = true

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags     = local.common_tags
  vpc_tags = local.common_tags

  # Additional Tags to Subnets
  public_subnet_tags = {
    Type                    = "Public Subnets"
    map_public_ip_on_launch = true
  }
  private_subnet_tags = {
    Type = "Private Subnets"
  }
}

locals {
  common_tags = {
    Owner       = "NYU"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = module.vpc.igw_id
}
