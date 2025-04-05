run "plan" {
  command = plan

  module {
    source = "./tests/helper"
  }

  // Test the static null input
  assert {
    condition     = !module.inputs_provided.results.static_null.provided
    error_message = "With input of `null` (known not provided), expected `provided` output to be `false`, but was `true`."
  }
  assert {
    condition     = module.inputs_provided.results.static_null.one_if_provided == 0
    error_message = "With input of `null` (known not provided), expected `one_if_provided` output to be `0`, but was `1`."
  }
  assert {
    condition     = module.inputs_provided.results.static_null.one_if_not_provided == 1
    error_message = "With input of `null` (known not provided), expected `one_if_not_provided` output to be `1`, but was `0`."
  }

  // Test a static string input
  assert {
    condition     = module.inputs_provided.results.static_string.provided
    error_message = "With static input value, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.static_string.one_if_provided == 1
    error_message = "With static input value, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.static_string.one_if_not_provided == 0
    error_message = "With static input value, expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // Test a known dynamic input
  assert {
    condition     = module.inputs_provided.results.dynamic_known_plan.provided
    error_message = "With plan-time known dynamic input value, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.dynamic_known_plan.one_if_provided == 1
    error_message = "With plan-time known dynamic input value, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.dynamic_known_plan.one_if_not_provided == 0
    error_message = "With plan-time known dynamic input value, expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // Test an unknown dynamic input
  assert {
    condition     = module.inputs_provided.results.dynamic_unknown_plan.provided
    error_message = "With apply-time known input string, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.dynamic_unknown_plan.one_if_provided == 1
    error_message = "With apply-time known input string, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.dynamic_unknown_plan.one_if_not_provided == 0
    error_message = "With apply-time known input string, expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // Test a ternary that we know evaluates to a string
  assert {
    condition     = module.inputs_provided.results.ternary_static_string.provided
    error_message = "With ternary input (known to be a static string), expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_static_string.one_if_provided == 1
    error_message = "With ternary input (known to be a static string), expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_static_string.one_if_not_provided == 0
    error_message = "With ternary input (known to be a static string), expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // Test a ternary that we know evaluates to null
  assert {
    condition     = !module.inputs_provided.results.ternary_static_null.provided
    error_message = "With ternary input (known to be null), expected `provided` output to be `false`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_static_null.one_if_provided == 0
    error_message = "With ternary input (known to be null), expected `one_if_provided` output to be `0`, but was `1`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_static_null.one_if_not_provided == 1
    error_message = "With ternary input (known to be null), expected `one_if_not_provided` output to be `1`, but was `0`."
  }

  // Test a ternary that we don't know whether it resolves to a value or a null
  assert {
    condition     = module.inputs_provided.results.ternary_unknown_plan.provided
    error_message = "With resource output as input string, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_unknown_plan.one_if_provided == 1
    error_message = "With resource output as input string, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_unknown_plan.one_if_not_provided == 0
    error_message = "With resource output as input string, expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // Test a direct output from a resource
  assert {
    condition     = module.inputs_provided.results.resource_dependency.provided
    error_message = "With resource output as input string, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.resource_dependency.one_if_provided == 1
    error_message = "With resource output as input string, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.resource_dependency.one_if_not_provided == 0
    error_message = "With resource output as input string, expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // Test the use of the resource output in ternary conditions (see the helper module files for details)
  assert {
    condition     = module.inputs_provided.results.resource_dependency_ternary_string.provided
    error_message = "With resource output used in a ternary to select the input, resolving at apply time to a static input, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.resource_dependency_ternary_string.one_if_provided == 1
    error_message = "With resource output used in a ternary to select the input, resolving at apply time to a static input, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.resource_dependency_ternary_string.one_if_not_provided == 0
    error_message = "With resource output used in a ternary to select the input, resolving at apply time to a static input, expected `one_if_not_provided` output to be `0`, but was `1`."
  }
  // Test the use of the resource output in ternary conditions (see the helper module files for details)
  assert {
    condition     = module.inputs_provided.results.resource_dependency_ternary_null.provided
    error_message = "With resource output used in a ternary to select the input, resolving at apply time to null, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.resource_dependency_ternary_null.one_if_provided == 1
    error_message = "With resource output used in a ternary to select the input, resolving at apply time to null, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.resource_dependency_ternary_null.one_if_not_provided == 0
    error_message = "With resource output used in a ternary to select the input, resolving at apply time to null, expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // This tests a weird edge case with a ternary where the condition isn't known at
  // plan time, but the result is known at plan time because both sides of the ternary
  // are `null`. In this case, Terraform seems to discard the condition evaluation and
  // simplify the ternary to just being `null`.
  assert {
    // Even though the condition can't be evaluated until the apply step, Terraform knows at the 
    // plan step that since both sides of the ternary are `null`, the input is guaranteed to be `null`
    condition     = !module.inputs_provided.results.ternary_double_null.provided
    error_message = "With resource output as input string, expected `provided` output to be `false`, but was `true`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_double_null.one_if_provided == 0
    error_message = "With resource output as input string, expected `one_if_provided` output to be `0`, but was `1`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_double_null.one_if_not_provided == 1
    error_message = "With resource output as input string, expected `one_if_not_provided` output to be `1`, but was `0`."
  }
}

run "apply" {
  command = apply

  module {
    source = "./tests/helper"
  }

  // Test the static null input
  assert {
    condition     = !module.inputs_provided.results.static_null.provided
    error_message = "With input of `null` (known not provided), expected `provided` output to be `false`, but was `true`."
  }
  assert {
    condition     = module.inputs_provided.results.static_null.one_if_provided == 0
    error_message = "With input of `null` (known not provided), expected `one_if_provided` output to be `0`, but was `1`."
  }
  assert {
    condition     = module.inputs_provided.results.static_null.one_if_not_provided == 1
    error_message = "With input of `null` (known not provided), expected `one_if_not_provided` output to be `1`, but was `0`."
  }

  // Test a static string input
  assert {
    condition     = module.inputs_provided.results.static_string.provided
    error_message = "With static input value, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.static_string.one_if_provided == 1
    error_message = "With static input value, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.static_string.one_if_not_provided == 0
    error_message = "With static input value, expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // Test a known dynamic input
  assert {
    condition     = module.inputs_provided.results.dynamic_known_plan.provided
    error_message = "With plan-time known dynamic input value, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.dynamic_known_plan.one_if_provided == 1
    error_message = "With plan-time known dynamic input value, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.dynamic_known_plan.one_if_not_provided == 0
    error_message = "With plan-time known dynamic input value, expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // Test an unknown dynamic input
  assert {
    condition     = module.inputs_provided.results.dynamic_unknown_plan.provided
    error_message = "With apply-time known input string, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.dynamic_unknown_plan.one_if_provided == 1
    error_message = "With apply-time known input string, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.dynamic_unknown_plan.one_if_not_provided == 0
    error_message = "With apply-time known input string, expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // Test a ternary that we know evaluates to a string
  assert {
    condition     = module.inputs_provided.results.ternary_static_string.provided
    error_message = "With ternary input (known to be a static string), expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_static_string.one_if_provided == 1
    error_message = "With ternary input (known to be a static string), expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_static_string.one_if_not_provided == 0
    error_message = "With ternary input (known to be a static string), expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // Test a ternary that we know evaluates to null
  assert {
    condition     = !module.inputs_provided.results.ternary_static_null.provided
    error_message = "With ternary input (known to be null), expected `provided` output to be `false`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_static_null.one_if_provided == 0
    error_message = "With ternary input (known to be null), expected `one_if_provided` output to be `0`, but was `1`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_static_null.one_if_not_provided == 1
    error_message = "With ternary input (known to be null), expected `one_if_not_provided` output to be `1`, but was `0`."
  }

  // Test a ternary that we don't know whether it resolves to a value or a null
  assert {
    condition     = module.inputs_provided.results.ternary_unknown_plan.provided
    error_message = "With resource output as input string, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_unknown_plan.one_if_provided == 1
    error_message = "With resource output as input string, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_unknown_plan.one_if_not_provided == 0
    error_message = "With resource output as input string, expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // Test a direct output from a resource
  assert {
    condition     = module.inputs_provided.results.resource_dependency.provided
    error_message = "With resource output as input string, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.resource_dependency.one_if_provided == 1
    error_message = "With resource output as input string, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.resource_dependency.one_if_not_provided == 0
    error_message = "With resource output as input string, expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // Test the use of the resource output in ternary conditions (see the helper module files for details)
  assert {
    condition     = module.inputs_provided.results.resource_dependency_ternary_string.provided
    error_message = "With resource output used in a ternary to select the input, resolving at apply time to a static input, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.resource_dependency_ternary_string.one_if_provided == 1
    error_message = "With resource output used in a ternary to select the input, resolving at apply time to a static input, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.resource_dependency_ternary_string.one_if_not_provided == 0
    error_message = "With resource output used in a ternary to select the input, resolving at apply time to a static input, expected `one_if_not_provided` output to be `0`, but was `1`."
  }
  // Test the use of the resource output in ternary conditions (see the helper module files for details)
  assert {
    condition     = module.inputs_provided.results.resource_dependency_ternary_null.provided
    error_message = "With resource output used in a ternary to select the input, resolving at apply time to null, expected `provided` output to be `true`, but was `false`."
  }
  assert {
    condition     = module.inputs_provided.results.resource_dependency_ternary_null.one_if_provided == 1
    error_message = "With resource output used in a ternary to select the input, resolving at apply time to null, expected `one_if_provided` output to be `1`, but was `0`."
  }
  assert {
    condition     = module.inputs_provided.results.resource_dependency_ternary_null.one_if_not_provided == 0
    error_message = "With resource output used in a ternary to select the input, resolving at apply time to null, expected `one_if_not_provided` output to be `0`, but was `1`."
  }

  // This tests a weird edge case with a ternary where the condition isn't known at
  // plan time, but the result is known at plan time because both sides of the ternary
  // are `null`. In this case, Terraform seems to discard the condition evaluation and
  // simplify the ternary to just being `null`.
  assert {
    // Even though the condition can't be evaluated until the apply step, Terraform knows at the 
    // plan step that since both sides of the ternary are `null`, the input is guaranteed to be `null`
    condition     = !module.inputs_provided.results.ternary_double_null.provided
    error_message = "With resource output as input string, expected `provided` output to be `false`, but was `true`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_double_null.one_if_provided == 0
    error_message = "With resource output as input string, expected `one_if_provided` output to be `0`, but was `1`."
  }
  assert {
    condition     = module.inputs_provided.results.ternary_double_null.one_if_not_provided == 1
    error_message = "With resource output as input string, expected `one_if_not_provided` output to be `1`, but was `0`."
  }
}
