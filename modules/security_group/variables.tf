variable "name" {
  description = "Name of the security group."
  type        = string
}

variable "description" {
  description = "Human-readable description of the security group."
  type        = string

  validation {
    condition     = length(trimspace(var.description)) > 0
    error_message = "description must not be empty."
  }
}

variable "vpc_id" {
  description = "VPC ID where the security group is created."
  type        = string
}

variable "ingress_rules" {
  description = "Map of standalone ingress rules supporting CIDR, referenced security group, or prefix list."
  type = map(object({
    description                  = string
    from_port                    = optional(number)
    to_port                      = optional(number)
    protocol                     = string
    cidr_ipv4                    = optional(string)
    referenced_security_group_id = optional(string)
    prefix_list_id               = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for _, r in var.ingress_rules : !(
        r.cidr_ipv4 == "0.0.0.0/0" &&
        r.from_port != null && r.to_port != null &&
        ((r.from_port <= 22 && r.to_port >= 22) || (r.from_port <= 3389 && r.to_port >= 3389))
      )
    ])
    error_message = "Unrestricted 0.0.0.0/0 ingress on administrative ports (22/SSH or 3389/RDP) is forbidden. Use AWS SSM Session Manager or narrow CIDR blocks."
  }
}

variable "egress_rules" {
  description = "Map of standalone egress rules supporting CIDR, referenced security group, or prefix list."
  type = map(object({
    description                  = string
    from_port                    = optional(number)
    to_port                      = optional(number)
    protocol                     = string
    cidr_ipv4                    = optional(string)
    referenced_security_group_id = optional(string)
    prefix_list_id               = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "Additional tags applied to the security group and its rules."
  type        = map(string)
  default     = {}
}
