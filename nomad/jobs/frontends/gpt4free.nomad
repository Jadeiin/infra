job "g4f" {
  datacenters = ["dc1"]
  type        = "service"

  group "g4f" {
    count = 1

    network {
      port "http" {
        to = 1337
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
    }

    task "g4f-api" {
      driver = "docker"

      config {
        image   = "hlohaus789/g4f:0.4.2.3-slim"
        ports   = ["http"]
        command = "python -m g4f.cli api"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
