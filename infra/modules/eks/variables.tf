variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.28"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
  default = {
    Project = "Blue-Green"
    Env     = "prod"
  }
}

variable "node_group_desired_capacity" {
  type    = number
  default = 2
}

variable "node_group_max_capacity" {
  type    = number
  default = 3
}

variable "node_group_min_capacity" {
  type    = number
  default = 1
}

variable "node_group_instance_types" {
  type    = list(string)
  default = ["t3.small"]
}
