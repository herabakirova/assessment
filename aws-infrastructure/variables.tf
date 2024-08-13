variable region {
  type        = string
  default     = "us-east-2"
  description = "provide the region"
}

variable vpc_name {
  type        = string
  default     = "myvpc"
  description = "provide vpc name"
}

variable cidr {
  type        = string
  default     = "10.0.0.0/16"
  description = "provide the cidr block"
}

variable subnet1_cidr {
  type        = string
  default     = "10.0.1.0/24"
  description = "provide cidr block for subnet 1"
}

variable subnet1_name {
  type        = string
  default     = "subnet1"
  description = "provide subnet 1 name"
}

variable subnet2_cidr {
  type        = string
  default     = "10.0.2.0/24"
  description = "provide cidr block for subnet 2"
}

variable subnet2_name {
  type        = string
  default     = "subnet2"
  description = "provide subnet 2 name"
}

variable subnet1_az {
  type        = string
  default     = "us-east-2a"
  description = "provide cidr block for subnet 3"
}

variable subnet2_az {
  type        = string
  default     = "us-east-2a"
  description = "provide subnet 3 name"
}

variable internetgtw_name {
  type        = string
  default     = "internetgtw"
  description = "provide internet gateway name"
}

variable rt_cidr {
  type        = string
  default     = "0.0.0.0/0"
  description = "provide route table cidr block"
}

variable rt_name {
  type        = string
  default     = "route-table"
  description = "provide route table name"
}

variable cluster_name {
  type        = string
  default     = "mycluster"
  description = "provide cluster name"
}

variable "ports" {
  type = list(object({
    from_port = number
    to_port   = number
  }))
  default = [
    { from_port = 80, to_port = 80 },
    { from_port = 22, to_port = 22 }
  ]
}

variable "subnet" {
  type = list(object({
    cidr        = string
    subnet_name = string
  }))
  default = [
    { cidr = "10.0.1.0/24", subnet_name = "subnet1" },
    { cidr = "10.0.2.0/24", subnet_name = "subnet2" }
  ]
}
