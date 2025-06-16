# Required Variables
variable "subnet_ids" {
  type = list(string)
}

variable "directus_namespace" {
  type = string
}

variable "kong" {
  type = string
}

variable "poorani" {
  type      = string
  sensitive = true
}

variable "redis" {
  type = string
}

variable "redis_namespace" {
  type    = string
  default = "redis" # Default value
}
