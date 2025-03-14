job "mozhi" {
  datacenters = ["dc1"]
  type        = "service"

  group "mozhi" {
    count = 1

    network {
      port "http" {
        to = 3000
      }
    }

    service {
      name     = JOB
      port     = "http"
      provider = "nomad"
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.${NOMAD_JOB_NAME}.tls=true",
        "traefik.http.routers.${NOMAD_JOB_NAME}.tls.certresolver=letsencrypt",
      ]
      check {
        type     = "http"
        path     = "/api/version"
        interval = "30s"
        timeout  = "5s"
      }
    }

    task "mozhi" {
      driver = "docker"

      config {
        image = "codeberg.org/aryak/mozhi:latest"
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
