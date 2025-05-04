job "structables" {
  datacenters = ["dc1"]
  type        = "service"

  group "structables" {
    count = 1

    network {
      port "http" {
        to = 8002
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

    task "structables" {
      driver = "docker"

      config {
        image        = "git.private.coffee/privatecoffee/structables:v0.4.3"
        ports        = ["http"]
        security_opt = ["no-new-privileges"]
        cap_drop     = ["all"]
      }

      env {
        PORT            = "8002"
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
