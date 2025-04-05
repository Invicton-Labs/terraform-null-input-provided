# Terraform Input Provided

This module checks during the plan step whether a non-null, or possibly non-null, input value was provided. Generally, it can make this determination **even if the actual value of the input is not known until the apply step** (`known after apply`).

This is extremely useful when using a conditional count value for a resource in a module, where the presence of an input variable is used to determine whether a resource should be created. Normally, this can only be done if the value of that input variable is known during the plan step; this module allows you to use that same pattern even if the input value isn't known until the apply step.

It does this by taking advantage of Terraform's typing system. If an input is `null`, and is known to be `null` during the plan step (i.e. not a ternary where it *might* be null, such as `timestamp() == "2022-08-16T07:44:12Z" ? "foo" : null`), then it uses a default value of a unique type, and does a comparison of the input with the default value. If the input was known to be `null`, it will return `false` since the input variable value will match the unique default type.

Special cases:
- If the input may or may not be null, depending on a condition that isn't known until the apply step, even if we know looking at it that the input value will evaluate to `null` (e.g. `timestamp() == "" ? "foo" : null`), then the `provided` output will be `true`.
- If the `input` variable is given a ternary where the condition isn't known until apply-time, but both sides of the ternary are `null` (e.g. `uuid() == "" ? null : null`), Terraform seems to discard the condition evalution and knows during the plan step that the result will be `null` regardless of the condition. Therefore, the module will return `false` for the `provided` output since the input is known to be `null` during the plan step.


### Example:

```terraform
module "provided_known_string" {
    source = "Invicton-Labs/input-provided/null"
    input = "foo"
}
output "provided_known_string" {
    value = module.provided_known_string.provided
}

module "provided_unknown_string" {
    source = "Invicton-Labs/input-provided/null"
    input = uuid()
}
output "provided_unknown_string" {
    value = module.provided_unknown_string.provided
}

module "provided_known_null" {
    source = "Invicton-Labs/input-provided/null"
    input = null
}
output "provided_known_null" {
    value = module.provided_known_null.provided
}

module "provided_unknown_possibly_null" {
    source = "Invicton-Labs/input-provided/null"
    input = uuid() == "" ? "bar" : null
}
output "provided_unknown_possibly_null" {
    value = module.provided_unknown_possibly_null.provided
}

module "provided_unknown_definitely_null" {
    source = "Invicton-Labs/input-provided/null"
    input = uuid() == "" ? null : null
}
output "provided_unknown_definitely_null" {
    value = module.provided_unknown_definitely_null.provided
}

```

`terraform apply`
```
Plan: 0 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + provided_known_null              = false
  + provided_known_string            = true
  + provided_unknown_definitely_null = false
  + provided_unknown_possibly_null   = true
  + provided_unknown_string          = true
```

As we can see, it will return `true` whenever any value that could *possibly* not be `null` is provided, and `false` if a value that is known to be `null` is provided.


## Usage

For a sample use case, consider the scenario where you have a module that needs a random string for internal use. We want to have an option for the random string to be externally generated and passed as an input variable. If no string is passed as an input, it should generate a new random string internally.

Your external (calling) file might look like this:

`./main.tf`
```terraform
resource "random_string" "external" {
  length = 16
}

// Use the demo module, where an externally generated value IS provided
module "existing" {
  source                 = "./demo"
  existing_random_string = random_string.external.result
}

// Use the demo module, where an externally generated value IS NOT provided
module "non_existing" {
  source                 = "./demo"
}
```

### Problem

For the module, you might initially try something like this:
`./demo/main.tf`
```terraform
variable "existing_random_string" {
  type    = string
  default = null
}

// If the input variable is `null` (no external value provided), generate a value internally.
resource "random_string" "internal" {
  count  = var.existing_random_string == null ? 1 : 0
  length = 16
}

// Do something with the random string value (the external one if an external one was provided, or
// the internal one if no external one was provided).
output "random_string" {
  value = var.existing_random_string != null ? var.existing_random_string : random_string.internal[0].result
}
```

Unfortunately, we get an error because whether or not the input variable is `null` isn't known during the plan step, and therefore the `count` of the `random_string` resource isn't known during the plan step.
```terraform
│ Error: Invalid count argument
│
│   on demo\main.tf line 8, in resource "random_string" "internal":
│    8:   count  = var.existing_random_string == null ? 1 : 0
│
│ The "count" value depends on resource attributes that cannot be determined until apply, so Terraform cannot predict how many instances will be created. To work around this, use the -target argument to first    
│ apply only the resources that the count depends on.
```

### Conventional Workaround

The conventional workaround for this is to have a second input variable as a boolean flag of whether or not to create the internal resource. We see this approach often in the [community AWS modules](https://registry.terraform.io/namespaces/terraform-aws-modules). It works, but it adds extra variables and requires keeping the two input variables in sync.


### This Module

This module allows a more convenient and cleaner solution.

`./demo/main.tf`
```terraform
variable "existing_random_string" {
  type    = string
  default = null
}

// Use this module to check if the input variable is provided (could possibly be non-null)
module "var_is_provided" {
  source = "Invicton-Labs/input-provided/null"
  input  = var.existing_random_string
}

// Use the module's output variable that is 1 if the `provided` output value is `false`
resource "random_string" "internal" {
  count  = module.var_is_provided.one_if_not_provided
  length = 16
}

// Use the `provided` output value to determine if we should use an externally provided value or 
// an internally-generated value.
output "random_string" {
  value = module.var_is_provided.provided ? var.existing_random_string : random_string.internal[0].result
}
```

And now, we get the correct plan with no errors:
```terraform
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_string.external will be created
  + resource "random_string" "external" {
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + numeric     = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }

  # module.non_existing.random_string.internal[0] will be created
  + resource "random_string" "internal" {
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + numeric     = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }

Plan: 2 to add, 0 to change, 0 to destroy.
```

As you can see, it correctly decides *not* to create a `random_string` resource for the `existing` module, and *does* create a `random_string` resource for the `non_existing` module.

For a real-world example, see our [Invicton-Labs/github-oidc/aws](https://registry.terraform.io/modules/Invicton-Labs/github-oidc/aws/latest) module, which uses it to determine whether a `aws_iam_openid_connect_provider` resource should be created within the module.


## Limitations

Always keep in mind that if there's a possibility that the `input` value **could** be a value other than `null` **and** whether it is or not isn't known until the `apply` step, it will return `true` for the `provided` output, even if the input does turn out to be `null` during the apply step.

This means that you cannot use this module to conditionally create a resource based on a value that isn't known until the `apply` step. For example:

`main.tf`
```terraform
resource "random_string" "external" {
  length = 16
}

// If it's before the year 2022, use the externally generated string
// NOTE: timestamp() doesn't return a known value until the apply step; during the plan step, it's unknown.
module "existing" {
  source                 = "./demo"
  existing_random_string = tonumber(formatdate("YYYY", timestamp())) < 2022 ? random_string.external.result : null
}
```

`terraform plan`
```terraform
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_string.external will be created
  + resource "random_string" "external" {
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + numeric     = true
      + result      = (known after apply)
      + special     = true
      + upper       = true
    }
```

Since it's the input value *could* be non-null, and we don't know during the plan step whether it will be or not, the module will return `true` for the `provided` output. In this case, we're not providing the external random string (the year is not less than 2022), so we *do* want the module to create an internal random string, but it won't do that because it doesn't know during the plan step if the input value will be `null` or not (`timestamp()` doesn't provide a known value until the apply step).


## Multi Version

In the `multi` subdirectory is a version of this module that can handle multiple inputs in a key/value map. This is useful if you want to check multiple values, but don't want to initialize many instances of this module.