job "wikimore" {
  datacenters = ["dc1"]
  type        = "service"

  group "wikimore" {
    count = 1

    network {
      port "http" {
        to = 8109
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

    task "wikimore" {
      driver = "docker"

      config {
        image           = "privatecoffee/wikimore:v0.1.10"
        ports           = ["http"]
        readonly_rootfs = true
        security_opt    = ["no-new-privileges"]
        cap_drop        = ["all"]
      }

      env {
        PORT            = "8109"
        UWSGI_PROCESSES = "2"
        UWSGI_THREADS   = "2"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
