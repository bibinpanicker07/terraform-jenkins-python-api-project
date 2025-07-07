provider "aws" {
  region         = "us-east-1"
}
module "networking" {
    source              = "./modules/networking"
    vpc_cidr_block      = var.vpc_cidr_block
    vpc_name            = var.vpc_name
    private_subnet_cidr = var.private_subnet_cidr
    public_subnet_cidr  = var.public_subnet_cidr  
    az                  = var.az
}
module "security_group" {
    source              = "./modules/sg"
    vpc_id              = module.networking.vpc_id
    public_subnet_cidr  = var.public_subnet_cidr
    app_port            = "5000"
}
module "launch_template" {
    source              = "./modules/launch-template"
    ami_id              = "ami-020cba7c55df1f615"
    user_data           = templatefile("./template/user-data.sh", {})
    instance_type       = "t2.micro"
    sg                  = module.security_group.sg
    key_name            = var.key_name
}
module "lb" {
    source              = "./modules/lb-target-grp"
    sg                  = module.security_group.sg
    vpc_id              = module.networking.vpc_id
    public_subnet_ids   = module.networking.public_subnet_ids
    app_port            = 5000
    protocol            = "HTTP"
    acm_arn             = module.aws_ceritification_manager.acm_arn
}
module "autoscaling_group" {
  source               = "./modules/auto-scaling-group"
  public_subnet_ids    = module.networking.public_subnet_ids
  lb_target_group_arn  = module.lb.lb_target_group_arn
  launch_template_id  = module.launch_template.launch_template_id
}
module "rds_db_instance" {
  source               = "./modules/rds"
  db_subnet_group_name = "rds_subnet_group"
  subnet_groups        = tolist(module.networking.public_subnet_ids)
  rds_mysql_sg_id      = module.security_group.rds_sg
  mysql_db_identifier  = "mydb"
  mysql_username       = "dbuser"
  mysql_password       = "dbpassword"
  mysql_dbname         = "devprojdb"
}
module "hosted_zone" {
  source          = "./modules/hosted-zone"
  domain_name     = var.domain_name
  aws_lb_dns_name = module.lb.alb_dns_name
  aws_lb_zone_id  = module.lb.alb_zone_id
}
module "aws_ceritification_manager" {
  source         = "./modules/certificate-manager"
  domain_name    = var.domain_name
  hosted_zone_id = module.hosted_zone.hosted_zone_id
}

