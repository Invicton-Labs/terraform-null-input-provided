locals {
  keys = keys(var.inputs)
}

module "input_provided" {
  source = "../"
  count  = length(local.keys)
  input  = var.inputs[local.keys[count.index]]
}
