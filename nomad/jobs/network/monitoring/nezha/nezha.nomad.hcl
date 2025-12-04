job "nezha" {
  group "nezha" {

    volume "data" {
      type   = "host"
      source = "nezha"
    }

    network {
      port "http" {
        to = "8008"
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

    task "nezha" {
      driver = "docker"

      config {
        image = "ghcr.io/nezhahq/nezha:v1.14.10"
        ports = ["http"]
      }

      volume_mount {
        volume      = "data"
        destination = "/dashboard/data"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}