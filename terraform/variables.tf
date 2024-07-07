variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "tft_my_ipaddress_cidr" {
  type        = string
  description = "(Required)Mapping to Inbound rule on ec2'security group."
}

variable "tft_env" {
  type        = string
  default     = "dev"
  description = "Enter Environment prd, stg or dev. Default is dev."

  validation {
    condition     = contains(["prd", "stg", "dev"], var.tft_env)
    error_message = "The tftEnv variable must be one of: prd, stg, dev."
  }
}

variable "tft_envmap" {
  description = "Environment Mapping"
  type = map(object({
    instance_type       = string
    vpc_cidr            = string
    public_subnet_cidr  = string
    private_subnet_cidr = string
  }))
  default = {
    prd = {
      instance_type       = "t3.small"
      vpc_cidr            = "10.2.0.0/21"
      public_subnet_cidr  = "10.2.1.0/24"
      private_subnet_cidr = "10.2.2.0/24"
    },
    stg = {
      instance_type       = "t3.small"
      vpc_cidr            = "10.1.0.0/21"
      public_subnet_cidr  = "10.1.1.0/24"
      private_subnet_cidr = "10.1.2.0/24"
    },
    dev = {
      instance_type       = "t3.micro"
      vpc_cidr            = "10.0.0.0/21"
      public_subnet_cidr  = "10.0.1.0/24"
      private_subnet_cidr = "10.0.2.0/24"
    }
  }
}