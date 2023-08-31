variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  type        = string
  default     = null
}

variable "vm_key_pair" {
  type    = string
  default = "timin_rsa"
}

variable "vm_key_path" {
  type    = string
  default = "~/.ssh/"
}

variable "vm_name" {
  description = "Name to be used for EC2 instance created"
  type        = string
  default     = "timin_#"
}

variable "vm_ssm_parameter" {
  description = "SSM parameter name for the AMI ID. For Amazon Linux AMI SSM parameters see [reference](https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters-ami.html)"
  type        = string
  default     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

variable "vm_ami" {
  description = "AWS id of AMI to use for creating EC2 instance"
  type        = string
  default     = "ami-0a5dcff6fb7af3fc9"
}

variable "vm_region" {
  description = "AWS region in which EC2 instance will be created"
  type        = string
  default     = "ap-south-1"
}

variable "vm_zone" {
  description = "AWS zone in which EC2 instance will be created"
  type        = string
  default     = null
}

variable "vm_type" {
  type    = string
  default = "t4g.xlarge"
}

variable "vm_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "vm_volume_size" {
  type    = string
  default = "30"
}

variable "vm_tags" {
  description = "Additional tags for EC2 instance"
  type        = map(string)
  default     = {}
}
