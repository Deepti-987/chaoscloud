variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "volume_size" {
  description = "EC2 storage size in GB"
  type        = number
  default     = 30
}

variable "deepti_ssh_cidr" {
  description = "Deepti's public IP for SSH"
  type        = string
  default     = "223.237.177.20/32"
}

variable "teammate_ssh_cidr" {
  description = "Teammate's public IP for SSH"
  type        = string
  default     = "157.51.145.124/32"
}
