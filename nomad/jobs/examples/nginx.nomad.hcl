job "nginx" {
  datacenters = ["dc1"]
  type        = "service"

  group "nginx" {
    network {
      port "http" {
        #static = 8000
        to = 80
      }
    }

    service {
      name     = JOB
      port     = "http"
      provider = "nomad"
    }

    task "nginx" {
      #driver = "podman"
      driver = "docker"

      config {
        image = "nginx"
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
