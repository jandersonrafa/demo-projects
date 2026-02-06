data_dir = "/opt/nomad/data"

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled = true
  cni_path = "/opt/cni/bin"

  host_volume "prometheus-data" {
    path      = "/home/jandersonrafaeldasilvarosa/repositorios/demo-projects/benchmark-stacks/monitoring/infra/prometheus/data"
    read_only = false
  }

  host_volume "grafana-data" {
    path      = "/home/jandersonrafaeldasilvarosa/repositorios/demo-projects/benchmark-stacks/monitoring/infra/grafana/data"
    read_only = false
  }
}

consul {
  address = "127.0.0.1:8500"
}

telemetry {
  publish_allocation_metrics = true
  publish_node_metrics       = true
  prometheus_metrics         = true
}