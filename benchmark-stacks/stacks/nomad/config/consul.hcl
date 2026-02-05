server = true
bootstrap_expect = 1
ui = true
data_dir = "/tmp/consul"

connect {
  enabled = true
}

ports {
  grpc = 8502
  dns = 8600
  http = 8500
}
