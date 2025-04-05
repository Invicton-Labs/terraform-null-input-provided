variable "input" {
  description = "The value to check to see if it has been provided in the Terraform config."
  type        = any
  // This allows the user to pass `null` as the value, but instead
  // of this variable actually being `null`, it uses the default below.
  nullable = false
  // We define a special default value that contains
  // multiple types, so Terraform internally thinks of it
  // as an "object(any)" type.
  default = {
    __TF_MAGIC_OBJECT_LIST_5dc338f3378948dfb63e144d7fd2f148 = []
    __TF_MAGIC_OBJECT_MAP_5dc338f3378948dfb63e144d7fd2f148  = {}
  }
}
