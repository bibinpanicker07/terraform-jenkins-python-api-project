variable "vpc_name"{
    type        = string
    description = "vpc name"
}
variable "vpc_cidr_block"{
    type        = string
    description = "vpc cidr block"    
}
variable "private_subnet_cidr"{
    type        = list(string)
    description = "private subnet cidr block"    
}
variable "public_subnet_cidr"{
    type        = list(string)
    description = "public subnet cidr block"    
}
variable "az"{
    type        = list(string)
    description = "vpc cidr block"    
}
variable "domain_name"{
    type        = string
    description = "domain name"    
}
variable "key_name"{
    type        = string
    description = "key name"    
}
