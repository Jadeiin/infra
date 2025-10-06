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
        image = "ghcr.io/komari-monitor/komari:1.1.1"
        ports = ["http"]
      }

      volume_mount {
        volume      = "data"
        destination = "/app/data"
      }

      #       template {
      #         data        = <<EOF
      # {{ with nomadVar "nomad/jobs/komari" }}
      # KOMARI_ENABLE_CLOUDFLARED = true
      # KOMARI_CLOUDFLARED_TOKEN = {{ . cloudflared_token }}
      # {{ end }}
      # EOF
      #         destination = "local/env"
      #         env         = true
      #       }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}