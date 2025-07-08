variable user_data {}
variable instance_type {}
variable ami_id {}
variable sg {}
variable key_name {}
variable instance_profile_name {}

resource "aws_launch_template" "launch_temp" {
  name_prefix     = "ec2_launch_template_"
  image_id        = var.ami_id
  instance_type   = var.instance_type
  user_data       = base64encode(var.user_data)
  vpc_security_group_ids = [var.sg]
  monitoring {
    enabled = true
  }
  key_name        = var.key_name
  lifecycle {
    create_before_destroy = true
  }
  iam_instance_profile {
    name = var.instance_profile_name
  }
}

output launch_template_id {
  value = aws_launch_template.launch_temp.id
}
