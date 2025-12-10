variable "name" {
  type    = string
  default = "bg-demo"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "tags" {
  type    = map(string)
  default = {
    Project = "Blue-Green"
    Env     = "prod"
  }
}
