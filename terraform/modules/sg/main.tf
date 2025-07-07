variable vpc_id {}
variable public_subnet_cidr {}
variable app_port {}

resource "aws_security_group" "ec2_sg" {
    name = "ec2-sg"
    vpc_id = var.vpc_id

    ingress {
        cidr_blocks = ["0.0.0.0/0"] 
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"           
    }
    ingress {
        cidr_blocks = ["0.0.0.0/0"] 
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"           
    }
    ingress {
        cidr_blocks = ["0.0.0.0/0"] 
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"           
    }    
    ingress {
        description = "Allow traffic on port 5000"
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = var.app_port
        to_port     = var.app_port
        protocol    = "tcp"
    }

    egress {
        cidr_blocks = ["0.0.0.0/0"]
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
    }
}
resource "aws_security_group" "rds_sg" {
    name = "rds-sg"
    vpc_id = var.vpc_id

    ingress {
        security_groups = [aws_security_group.ec2_sg.id]
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"           
    }
}

output "sg" {
    value = aws_security_group.ec2_sg.id
}
output "rds_sg" {
    value = aws_security_group.rds_sg.id
}