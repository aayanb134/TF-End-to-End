variable "region" {
  description = "Region where AWS resources are deployed"
  type        = string
  default     = ""
}

variable "azs" {
  type    = list(string)
  default = []
}

variable "environment" {
  description = "Dev/Staging = 1 NATGW & EIP. Prod = 1 NATGW & EIP per public subnet"
  type        = string
  default     = ""
}

variable "vpc-cidr" {
  description = "VPC CIDR"
  type        = string
  default     = ""
}

variable "public-subnets" {
  type = list(string)
}

variable "private-subnets" {
  type = list(string)
}


variable "instance-type" {
  type    = string
  default = ""
}

variable "key-name" {
  type    = string
  default = ""
}

variable "aws-region" {
  description = "Region in which AWS Resources will be deployed"
  type        = string
  default     = ""
}
