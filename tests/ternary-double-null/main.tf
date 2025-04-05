module "input_provided" {
  source = "../../"
  input  = uuid() == "" ? null : null
}
