output "results" {
  value = {
    for idx in range(length(local.keys)) :
    (local.keys[idx]) => module.input_provided[idx]
  }
}
