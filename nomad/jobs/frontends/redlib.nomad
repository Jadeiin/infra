job "redlib" {
  datacenters = ["dc1"]
  type        = "service"

  group "redlib" {
    count = 1

    network {
      port "http" {
        to = 8080
      }
    }

    service {
      name     = JOB
      port     = "http"
      provider = "nomad"
      check {
        type     = "http"
        path     = "/settings"
        interval = "5m"
        timeout  = "3s"
      }
    }

    task "redlib" {
      driver = "docker"

      config {
        image = "quay.io/redlib/redlib:latest"
        ports = ["http"]
      }

      artifact {
        source      = "https://github.com/redlib-org/redlib/raw/refs/heads/main/.env.example"
        destination = "local/env.example"
      }

      template {
        source      = "local/env.example"
        destination = "local/env"
        env         = true
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}