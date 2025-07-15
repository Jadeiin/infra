job "komari" {
  group "komari" {

    volume "data" {
      type   = "host"
      source = "komari"
    }

    network {
      port "http" {
        to = "25774"
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

    task "komari" {
      driver = "docker"

      config {
        image = "ghcr.io/komari-monitor/komari:0.1.6"
        ports = ["http"]
      }
    }

    volume_mount {
      volume      = "data"
      destination = "/app/data"
    }

    resources {
      cpu    = 100
      memory = 128
    }
  }
}