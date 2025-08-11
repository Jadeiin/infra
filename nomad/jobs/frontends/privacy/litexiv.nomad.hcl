job "litexiv" {
  datacenters = ["dc1"]
  type        = "service"

  group "litexiv" {
    count = 1

    network {
      port "http" {
        to = 8787
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
        // RateLimit
        "traefik.http.routers.${NOMAD_JOB_NAME}.middlewares=ratelimit",
        "traefik.http.middlewares.ratelimit.rateLimit.average=100",
        "traefik.http.middlewares.ratelimit.rateLimit.burst=50",
        "traefik.http.middlewares.ratelimit.rateLimit.period=10s",
      ]
    }

    task "litexiv" {
      driver = "docker"

      config {
        image        = "codeberg.org/litexiv/litexiv:v2.2.2"
        ports        = ["http"]
        security_opt = ["no-new-privileges"]
        cap_drop     = ["all"]
      }

      artifact {
        source = "https://codeberg.org/LiteXiv/LiteXiv/raw/branch/v2/.env.example"
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
