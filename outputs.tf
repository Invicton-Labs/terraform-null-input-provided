locals {
  provided = var.input != {
    __TF_MAGIC_OBJECT_LIST_5dc338f3378948dfb63e144d7fd2f148 = []
    __TF_MAGIC_OBJECT_MAP_5dc338f3378948dfb63e144d7fd2f148  = {}
  }
}

output "provided" {
  description = "Whether a value, other than a definitive (known at the plan step) `null`, was provided as an input."
  value       = local.provided
}

output "one_if_provided" {
  description = "1 if the `provided` output is `true`, 0 if `false`. Useful for `count` arguments of resources."
  value       = local.provided ? 1 : 0
}

output "one_if_not_provided" {
  description = "1 if the `provided` output is `false`, 0 if `true`. Useful for `count` arguments of resources."
  value       = local.provided ? 0 : 1
}
