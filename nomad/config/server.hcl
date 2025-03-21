#region = ""
#datacenter = ""
data_dir  = "/opt/nomad/data"
bind_addr = "{{ GetInterfaceIP \"tun0\" }}"
addresses {
  http = "{{ GetInterfaceIP \"tun0\" }} 127.0.0.1"
}

server {
  enabled          = true
  bootstrap_expect = 1
}

client {
  enabled           = true
  servers           = ["127.0.0.1"]
  network_interface = "tun0"

  host_network "overlay" {
    interface = "tun0"
  }
  host_network "public" {
    interface = "ens2"
  }
}

plugin "docker" {
  config {
    allow_privileged = true
  }
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}
