module "input_provided" {
  source = "../../"
  input  = uuid() == "" ? "foo" : null
}
