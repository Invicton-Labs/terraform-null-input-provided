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

module "input_provided" {
  source = "../../"
  input  = random_string.this.result
}

// At plan-time, this would be "provided"
// At apply-time, when the ternary condition is known (to be null),
// it should theoretically be "not provided"
module "input_provided_ternary" {
  source = "../../"
  // We know this will always be known after apply as "false"
  // since the random string is configured not to use numeric characters,
  // but the module won't know that at plan time, so it should 
  // consider this to be a provided input since it's not known at plan time.
  input = random_string.this.result == "22" ? "foo" : null
}
