variable vpc_id {}
variable app_port {}
variable protocol {}
variable sg {}
variable public_subnet_ids {}
variable acm_arn {}





resource "aws_lb" "lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "tg" {
    vpc_id                 = var.vpc_id
    port                   = var.app_port
    protocol               = var.protocol
    health_check {
        path               = "/health"
        port               = var.app_port
        healthy_threshold  = 6
        unhealthy_threshold = 2
        timeout            = 2
        interval           = 5
        matcher            = "200"
    }
}
/*
resource "aws_lb_listener" "lb_listener" {
    load_balancer_arn = aws_lb.lb.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.tg.arn
    }
}
*/
# https listner on port 443
resource "aws_lb_listener" "lb_https_listner" {
    load_balancer_arn = aws_lb.lb.arn
    port              = "443"
    protocol          = "HTTPS"
    ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
    certificate_arn   = var.acm_arn
    default_action {
      type             = "forward"
      target_group_arn = aws_lb_target_group.tg.arn
    }
}



output "alb_dns_name" {
    value = aws_lb.lb.dns_name
}
output "alb_zone_id" {
    value = aws_lb.lb.zone_id
}
output "lb_target_group_arn" {
  value = aws_lb_target_group.tg.arn
}