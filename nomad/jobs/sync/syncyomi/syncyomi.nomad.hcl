job "syncyomi" {
  datacenters = ["dc1"]
  type        = "service"

  group "syncyomi" {

    volume "data" {
      type   = "host"
      source = "syncyomi"
    }

    network {
      port "http" {
        to = 8282
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

    task "syncyomi" {
      driver = "docker"

      config {
        image = "ghcr.io/syncyomi/syncyomi:v1.1.4"
        ports = ["http"]
        # volumes = [
        #   "/opt/nomad-volume/syncyomi:/config"
        # ]
      }

      # env {
      #   TZ = "Asia/Shanghai"
      # }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
