
output "deepti_instance_id" {
  value = aws_instance.deepti.id
}

output "deepti_public_ip" {
  value = aws_instance.deepti.public_ip
}

output "deepti_private_ip" {
  value = aws_instance.deepti.private_ip
}

output "teammate_instance_id" {
  value = aws_instance.teammate.id
}

output "teammate_public_ip" {
  value = aws_instance.teammate.public_ip
}

output "teammate_private_ip" {
  value = aws_instance.teammate.private_ip
}

output "vpc_id" {
  value = aws_vpc.chaoscloud_vpc.id
}
