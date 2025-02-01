job "privtracker" {
  datacenters = ["dc1"]
  type        = "service"

  group "privtracker" {
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

    task "privtracker" {
      driver = "docker"

      config {
        image = "meehow/privtracker:v1.2.0"
        ports = ["http"]
      }

      env {
        PORT = 1337
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
