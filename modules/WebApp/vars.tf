variable "environment" {
  type    = string
  default = ""
}

variable "instance-type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "public-subnet" {
  type    = list(string)
  default = [""]
}

variable "public-subnet-id" {
  description = "Public Subnet IDs"
  type        = list(string)
  default     = [""]
}

variable "private-subnet" {
  type    = list(string)
  default = []
}

variable "private-subnet-id" {
  description = "Private Subnet IDs"
  type        = list(string)
  default     = [""]
}

variable "vpc-id" {
  type    = string
  default = ""
}

variable "key-name" {
  description = "Name of Key Pair"
  type        = string
  default     = ""
}
