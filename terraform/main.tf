terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.66"
    }
  }
}

output "server_id" {
  value = aws_instance.hab_server.id
}

output "server_private_ip" {
  value = aws_instance.hab_server.private_ip
}

output "server_public_ipv4" {
  value = aws_instance.hab_server.public_ip
}

output "server_key_pair" {
  value = aws_instance.hab_server.key_name
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value = try(
    aws_instance.this[0].tags_all,
    aws_instance.ignore_ami[0].tags_all,
    aws_spot_instance_request.this[0].tags_all,
    {},
  )
}
