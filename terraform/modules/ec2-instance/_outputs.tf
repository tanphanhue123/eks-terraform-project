#modules/ec2-instance/_outputs.tf
output "ec2_instance_id" {
  value       = aws_instance.ec2_instance.id
  description = "ID of the instance"
}
#modules/ec2-eip/outputs.tf
output "ec2_eip_public_ip" {
  value = aws_eip.ec2_eip.public_ip
}
