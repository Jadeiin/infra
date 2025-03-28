job "anonymousoverflow" {
  datacenters = ["dc1"]
  type        = "service"

  group "anonymousoverflow" {
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
      tags = [
        "traefik.enable=true",
        "traefik.http.routers.${NOMAD_JOB_NAME}.tls=true",
        "traefik.http.routers.${NOMAD_JOB_NAME}.tls.certresolver=letsencrypt",
      ]
    }

    task "anonymousoverflow" {
      driver = "docker"

      config {
        image = "ghcr.io/httpjamesm/anonymousoverflow:release"
        ports = ["http"]
      }

      template {
        data        = <<EOF
APP_URL = "https://{{env "NOMAD_JOB_NAME"}}.{{ with nomadVar "nomad/jobs" }}{{ .domain }}{{ end }}"
JWT_SIGNING_SECRET = "secret"
EOF
        destination = "secrets/env"
        env         = true
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
