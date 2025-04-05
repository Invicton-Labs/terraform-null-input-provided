// Test with no input provided
run "nothing_provided_plan" {
  command = plan

  assert {
    condition     = !output.provided
    error_message = "With no input (known not provided), expected `provided` output to be `false`, but was `true`."
  }
  assert {
    condition     = output.one_if_provided == 0
    error_message = "With no input (known not provided), expected `one_if_provided` output to be `0`, but was `1`."
  }
  assert {
    condition     = output.one_if_not_provided == 1
    error_message = "With no input (known not provided), expected `one_if_not_provided` output to be `1`, but was `0`."
  }
}
run "nothing_provided_apply" {
  command = apply

  assert {
    condition     = !output.provided
    error_message = "With no input (known not provided), expected `provided` output to be `false`, but was `true`."
  }
  assert {
    condition     = output.one_if_provided == 0
    error_message = "With no input (known not provided), expected `one_if_provided` output to be `0`, but was `1`."
  }
  assert {
    condition     = output.one_if_not_provided == 1
    error_message = "With no input (known not provided), expected `one_if_not_provided` output to be `1`, but was `0`."
  }
}

// Test with null provided
run "null_provided_plan" {
  command = plan

  variables {
    input = null
  }

  assert {
    condition     = !output.provided
    error_message = "With input of `null` (known not provided), expected `provided` output to be `false`, but was `true`."
  }
  assert {
    condition     = output.one_if_provided == 0
    error_message = "With input of `null` (known not provided), expected `one_if_provided` output to be `0`, but was `1`."
  }
  assert {
    condition     = output.one_if_not_provided == 1
    error_message = "With input of `null` (known not provided), expected `one_if_not_provided` output to be `1`, but was `0`."
  }
}
run "null_provided_apply" {
  command = apply

  variables {
    input = null
  }

  assert {
    condition     = !output.provided
    error_message = "With input of `null` (known not provided), expected `provided` output to be `false`, but was `true`."
  }
  assert {
    condition     = output.one_if_provided == 0
    error_message = "With input of `null` (known not provided), expected `one_if_provided` output to be `0`, but was `1`."
  }
  assert {
    condition     = output.one_if_not_provided == 1
    error_message = "With input of `null` (known not provided), expected `one_if_not_provided` output to be `1`, but was `0`."
  }
}

// Test with a static value, known at plan time
run "static_provided_plan" {
  command = plan

  variables {
    input = "hello world"
  }

  assert {
    condition     = output.provided
    error_message = "With static input value, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = output.one_if_provided == 1
    error_message = "With static input value, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = output.one_if_not_provided == 0
    error_message = "With static input value, expected `one_if_not_provided` output to be `0`, but was `1`."
  }
}
run "static_provided_apply" {
  command = apply

  variables {
    input = "hello world"
  }

  assert {
    condition     = output.provided
    error_message = "With static input value, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = output.one_if_provided == 1
    error_message = "With static input value, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = output.one_if_not_provided == 0
    error_message = "With static input value, expected `one_if_not_provided` output to be `0`, but was `1`."
  }
}

// Test with a dynamic computed value that should be known at plan time
run "plan_time_provided_plan" {
  command = plan

  variables {
    input = base64sha256("hello world")
  }

  assert {
    condition     = output.provided
    error_message = "With plan-time known dynamic input value, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = output.one_if_provided == 1
    error_message = "With plan-time known dynamic input value, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = output.one_if_not_provided == 0
    error_message = "With plan-time known dynamic input value, expected `one_if_not_provided` output to be `0`, but was `1`."
  }
}
run "plan_time_provided_apply" {
  command = apply

  variables {
    input = base64sha256("hello world")
  }

  assert {
    condition     = output.provided
    error_message = "With plan-time known dynamic input value, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = output.one_if_provided == 1
    error_message = "With plan-time known dynamic input value, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = output.one_if_not_provided == 0
    error_message = "With plan-time known dynamic input value, expected `one_if_not_provided` output to be `0`, but was `1`."
  }
}

// Test with a dynamic computed value that we know is being provided, but the 
// actual value isn't known until apply time.
run "apply_time_provided_plan" {
  command = plan

  variables {
    input = timestamp()
  }

  assert {
    condition     = output.provided
    error_message = "With apply-time known input string, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = output.one_if_provided == 1
    error_message = "With apply-time known input string, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = output.one_if_not_provided == 0
    error_message = "With apply-time known input string, expected `one_if_not_provided` output to be `0`, but was `1`."
  }
}
run "apply_time_provided_apply" {
  command = apply

  variables {
    input = timestamp()
  }

  assert {
    condition     = output.provided
    error_message = "With apply-time known input string, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = output.one_if_provided == 1
    error_message = "With apply-time known input string, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = output.one_if_not_provided == 0
    error_message = "With apply-time known input string, expected `one_if_not_provided` output to be `0`, but was `1`."
  }
}

// Test a ternary value where it's known at plan time that it will be a string
run "ternary_known_provided_plan" {
  command = plan

  variables {
    input = true ? "hello world" : null
  }

  assert {
    condition     = output.provided
    error_message = "With ternary input (known to be a static string), expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = output.one_if_provided == 1
    error_message = "With ternary input (known to be a static string), expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = output.one_if_not_provided == 0
    error_message = "With ternary input (known to be a static string), expected `one_if_not_provided` output to be `0`, but was `1`."
  }
}
run "ternary_known_provided_apply" {
  command = apply

  variables {
    input = true ? "hello world" : null
  }

  assert {
    condition     = output.provided
    error_message = "With ternary input (known to be a static string), expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = output.one_if_provided == 1
    error_message = "With ternary input (known to be a static string), expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = output.one_if_not_provided == 0
    error_message = "With ternary input (known to be a static string), expected `one_if_not_provided` output to be `0`, but was `1`."
  }
}

// Test a ternary value where it's known at plan time that it will be null
run "ternary_known_null_plan" {
  command = plan

  variables {
    input = false ? "hello world" : null
  }

  assert {
    condition     = !output.provided
    error_message = "With ternary input (known to be null), expected `provided` output to be `false`, but was `false`."
  }
  assert {
    condition     = output.one_if_provided == 0
    error_message = "With ternary input (known to be null), expected `one_if_provided` output to be `0`, but was `1`."
  }
  assert {
    condition     = output.one_if_not_provided == 1
    error_message = "With ternary input (known to be null), expected `one_if_not_provided` output to be `1`, but was `0`."
  }
}
run "ternary_known_null_apply" {
  command = apply

  variables {
    input = false ? "hello world" : null
  }

  assert {
    condition     = !output.provided
    error_message = "With ternary input (known to be null), expected `provided` output to be `false`, but was `false`."
  }
  assert {
    condition     = output.one_if_provided == 0
    error_message = "With ternary input (known to be null), expected `one_if_provided` output to be `0`, but was `1`."
  }
  assert {
    condition     = output.one_if_not_provided == 1
    error_message = "With ternary input (known to be null), expected `one_if_not_provided` output to be `1`, but was `0`."
  }
}

run "ternary_unknown_plan" {
  command = plan
  // We have to do this in a separate module because of weird behaviour with tests,
  // where it will compute function results at plan time even when in a real Terraform
  // config, they aren't known until apply time.
  module {
    source = "./tests/apply-step-function-dependency"
  }

  assert {
    condition     = module.input_provided.provided
    error_message = "With resource output as input string, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.input_provided.one_if_provided == 1
    error_message = "With resource output as input string, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.input_provided.one_if_not_provided == 0
    error_message = "With resource output as input string, expected `one_if_not_provided` output to be `0`, but was `1`."
  }
}
run "ternary_unknown_apply" {
  command = apply
  // We have to do this in a separate module because of weird behaviour with tests,
  // where it will compute function results at plan time even when in a real Terraform
  // config, they aren't known until apply time.
  module {
    source = "./tests/apply-step-function-dependency"
  }

  assert {
    condition     = module.input_provided.provided
    error_message = "With resource output as input string, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.input_provided.one_if_provided == 1
    error_message = "With resource output as input string, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.input_provided.one_if_not_provided == 0
    error_message = "With resource output as input string, expected `one_if_not_provided` output to be `0`, but was `1`."
  }
}

// Test with a resource output value that isn't known until apply time.
run "resource_output_plan" {
  command = plan

  module {
    source = "./tests/resource-dependency"
  }

  // This tests the output of the resource directly.
  assert {
    condition     = module.input_provided.provided
    error_message = "With resource output as input string, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.input_provided.one_if_provided == 1
    error_message = "With resource output as input string, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.input_provided.one_if_not_provided == 0
    error_message = "With resource output as input string, expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // Test the use of the resource output in ternary conditions (see the helper module files for details)
  assert {
    condition     = module.input_provided_ternary.provided
    error_message = "With resource output used in a ternary to select the input, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.input_provided_ternary.one_if_provided == 1
    error_message = "With resource output used in a ternary to select the input, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.input_provided_ternary.one_if_not_provided == 0
    error_message = "With resource output used in a ternary to select the input, expected `one_if_not_provided` output to be `0`, but was `1`."
  }
}
run "resource_output_apply" {
  command = apply

  module {
    source = "./tests/resource-dependency"
  }

  // This tests the output of the resource directly.
  assert {
    condition     = module.input_provided.provided
    error_message = "With resource output as input string, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.input_provided.one_if_provided == 1
    error_message = "With resource output as input string, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.input_provided.one_if_not_provided == 0
    error_message = "With resource output as input string, expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // Test the use of the resource output in ternary conditions (see the helper module files for details)
  // This is one of the special conditions. Even though we know the apply-time input will be `null`,
  // this module doesn't know that at plan time, when it determines if an input was provided.
  // Since the input is unknown at plan time, the module defaults to "input provided".
  assert {
    condition     = module.input_provided_ternary.provided
    error_message = "With resource output used in a ternary to select the input, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.input_provided_ternary.one_if_provided == 1
    error_message = "With resource output used in a ternary to select the input, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.input_provided_ternary.one_if_not_provided == 0
    error_message = "With resource output used in a ternary to select the input, expected `one_if_not_provided` output to be `0`, but was `1`."
  }
}

// This tests a weird edge case with a ternary where the condition isn't known at
// plan time, but the result is known at plan time because both sides of the ternary
// are `null`. In this case, Terraform seems to discard the condition evaluation and
// simplify the ternary to just being `null`.
run "ternary_double_null_plan" {
  command = plan
  // We have to do this in a separate module because of weird behaviour with tests,
  // where it will compute function results at plan time even when in a real Terraform
  // config, they aren't known until apply time.
  module {
    source = "./tests/ternary-double-null"
  }

  assert {
    // Even though the condition can't be evaluated until the apply step, Terraform knows at the 
    // plan step that since both sides of the ternary are `null`, the input is guaranteed to be `null`
    condition     = !module.input_provided.provided
    error_message = "With resource output as input string, expected `provided` output to be `false`, but was `true`."
  }
  assert {
    condition     = module.input_provided.one_if_provided == 0
    error_message = "With resource output as input string, expected `one_if_provided` output to be `0`, but was `1`."
  }
  assert {
    condition     = module.input_provided.one_if_not_provided == 1
    error_message = "With resource output as input string, expected `one_if_not_provided` output to be `1`, but was `0`."
  }
}
run "ternary_double_null_apply" {
  command = apply
  // We have to do this in a separate module because of weird behaviour with tests,
  // where it will compute function results at plan time even when in a real Terraform
  // config, they aren't known until apply time.
  module {
    source = "./tests/ternary-double-null"
  }

  assert {
    // Even though the condition can't be evaluated until the apply step, Terraform knows at the 
    // plan step that since both sides of the ternary are `null`, the input is guaranteed to be `null`
    condition     = !module.input_provided.provided
    error_message = "With resource output as input string, expected `provided` output to be `false`, but was `true`."
  }
  assert {
    condition     = module.input_provided.one_if_provided == 0
    error_message = "With resource output as input string, expected `one_if_provided` output to be `0`, but was `1`."
  }
  assert {
    condition     = module.input_provided.one_if_not_provided == 1
    error_message = "With resource output as input string, expected `one_if_not_provided` output to be `1`, but was `0`."
  }
}
