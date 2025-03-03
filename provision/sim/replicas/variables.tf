variable "replica_count" {
  type        = number
  description = "Number of replicas to create"
}

variable "volume_id" {
  type        = string
  description = "Base volume ID to clone for each node"
}

variable "network_id" {
  type        = string
  description = "Network ID to attach nodes to"
}

variable "memory" {
  type    = number
  default = 1024
}
