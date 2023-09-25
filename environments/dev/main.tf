module "VPC" {
  source = "../../modules/VPC"

  environment        = var.environment
  vpc-cidr           = var.vpc-cidr
  vpc-public-subnet  = var.public-subnets
  vpc-private-subnet = var.private-subnets
  vpc-azs            = var.azs
}

module "WebApp" {
  source = "../../modules/WebApp"

  vpc-id            = module.VPC.vpc-id
  environment       = var.environment
  public-subnet-id  = join(",", module.VPC.public-subnet-ids)
  private-subnet-id = join(",", module.VPC.private-subnet-ids)
  instance-type     = var.instance-type
  key-name          = var.key-name
}
