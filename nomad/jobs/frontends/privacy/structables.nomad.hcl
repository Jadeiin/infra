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
        image        = "git.private.coffee/privatecoffee/structables:v0.4.1"
        ports        = ["http"]
        security_opt = ["no-new-privileges"]
        cap_drop     = ["all"]
      }

      artifact {
        source = "https://git.private.coffee/PrivateCoffee/structables/raw/branch/main/.env.example"
      }

      template {
        source      = "local/.env.example"
        destination = "local/env"
        env         = true
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
