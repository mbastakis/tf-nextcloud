output "efs_id" {
  description = "ID of the EFS"
  value       = module.efs.id
}

output "efs_mount_targets" {
  description = "Mount targets of the EFS"
  value       = module.efs.mount_targets
}
