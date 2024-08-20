variable "config" {
  description = "Directory and script details for automation"
  type = object({
    src    = string
    dest   = string
    script = string
    args   = string
  })
  default = null
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use"
  type        = string
}

variable "security_group_ids" {
  description = "The security group ids to use"
  type        = list(string)
}

variable "ssh_user" {
  description = "The ssh user to use"
  type        = string
}

variable "subnet" {
  description = "List of subnet IDs"
  type        = string
}

variable "troubleshoot" {
  description = "Enable troubleshooting"
  type        = bool
}

variable "windows_instance" {
  description = "Create a Windows instance"
  type        = bool
}

variable "enable_public_ip" {
  description = "Enable public IP"
  type        = bool
  default     = false
}

variable "instance_count" {
  description = "The number of instances to create"
  type        = number
  default     = 1
}