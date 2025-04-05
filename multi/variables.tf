variable "inputs" {
  description = "A map of values, where each value is checked to see if it was provided as an input, or set to `null`."
  type        = any
  nullable    = false
  default     = {}
  validation {
    condition     = can(keys(var.inputs))
    error_message = "The `inputs` variable must be a map."
  }
}
