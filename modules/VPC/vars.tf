variable "vpc-cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "environment" {
  type    = string
  default = ""
}

variable "vpc-azs" {
  description = "AZs covered by VPC"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "vpc-public-subnet" {
  description = "Public Subnet CIDR"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc-private-subnet" {
  description = "Private Subnet CIDR"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public-route-table-cidr" {
  description = "CIDR Block for public route table"
  type        = string
  default     = "0.0.0.0/0"
}
