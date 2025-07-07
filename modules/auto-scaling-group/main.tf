variable public_subnet_ids {}
variable lb_target_group_arn {}
variable launch_template_id {}


resource "aws_autoscaling_group" "asg" {
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  launch_template {
    id= var.launch_template_id
    version ="$Latest"
  } 
  vpc_zone_identifier  = var.public_subnet_ids
}


resource "aws_autoscaling_attachment" "asg_attachement" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn   = var.lb_target_group_arn
}