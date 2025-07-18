output "private_subnet_cidrs" {
  value       = module.private-subnets.private_subnet_cidrs
  description = "The ID of the subnet."
}

output "private_tags" {
  value       = module.private-subnets.private_tags
  description = "A mapping of tags to assign to the resource."
}
# resourceoutput "igw_id" {
#   value = aws_internet_gateway.default[0].id
# }
