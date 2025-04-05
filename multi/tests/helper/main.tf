terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">=3.7.1"
    }
  }
}

resource "random_string" "this" {
  length  = 2
  numeric = false
}

module "inputs_provided" {
  source = "../../"
  inputs = {
    static_null                        = null
    static_string                      = "hello world"
    dynamic_known_plan                 = base64sha256("hello world")
    dynamic_unknown_plan               = uuid()
    ternary_static_string              = true ? "hello world" : null
    ternary_static_null                = false ? "hello world" : null
    ternary_unknown_plan               = uuid() != "" ? "hello world" : null
    resource_dependency                = random_string.this.result
    resource_dependency_ternary_string = random_string.this.result != "" ? "hello world" : null
    resource_dependency_ternary_null   = random_string.this.result == "" ? "hello world" : null
    ternary_double_null                = uuid() == "" ? null : null
  }
}
