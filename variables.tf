variable "name" {
  description = "A name which will be pre-pended to the resources created"
  type        = string
}

variable "instance_group_version_name" {
  description = "A name to give to the instance group version control (e.g. app_name + app_version)"
  type        = string
}

variable "region" {
  description = "The name of the region to deploy within"
  type        = string
}

variable "network" {
  description = "The name of the network to deploy within"
  type        = string
}

variable "subnetwork" {
  description = "The name of the sub-network to deploy within; if populated will override the 'network' setting"
  type        = string
  default     = ""
}

variable "machine_type" {
  description = "The machine type to use"
  type        = string
  default     = "e2-small"
}

variable "target_size" {
  description = "The number of servers to deploy"
  default     = 1
  type        = number
}

variable "associate_public_ip_address" {
  description = "Whether to assign a public ip address to this instance; if false this instance must be behind a Cloud NAT to connect to the internet"
  type        = bool
  default     = true
}

variable "ssh_block_project_keys" {
  description = "Whether to block project wide SSH keys"
  type        = bool
  default     = true
}

variable "ssh_key_pairs" {
  description = "The list of SSH key-pairs to add to the servers"
  default     = []
  type = list(object({
    user_name  = string
    public_key = string
  }))
}

variable "named_port_http" {
  description = "The name to give to the bound port on the instance group"
  type        = string
  default     = ""
}

variable "ingress_port" {
  description = "The port that the service will be bound to and exposed over HTTP"
  type        = number
  default     = -1
}

variable "health_check_path" {
  description = "The path to bind for health checks"
  type        = string
  default     = ""
}

variable "timeout_sec" {
  description = "How long (in seconds) to wait before claiming failure"
  type        = number
  default     = 5
}

variable "check_interval_sec" {
  description = "How often (in seconds) to send a health check"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "A so-far unhealthy instance will be marked healthy after this many consecutive successes"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "A so-far healthy instance will be marked unhealthy after this many consecutive failures"
  type        = number
  default     = 10
}

variable "user_supplied_script" {
  description = "The user-data script extension to execute"
  type        = string
}

variable "ubuntu_20_04_source_image" {
  description = "The source image to use which must be based of of Ubuntu 20.04; by default the latest community version is used"
  default     = ""
  type        = string
}

variable "service_account_email" {
  description = "The name of the service account email address to bind to the deployment"
  type        = string
}

variable "labels" {
  description = "The labels to append to this resource"
  default     = {}
  type        = map(string)
}
