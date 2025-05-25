job "rimgo" {
  datacenters = ["dc1"]
  type        = "service"

  group "rimgo" {
    count = 1

    network {
      port "http" {
        to = 3000
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
        "traefik.http.routers.${NOMAD_JOB_NAME}.middlewares=ratelimit@file",
        "traefik.http.middlewares.ratelimit.rateLimit.average=100",
        "traefik.http.middlewares.ratelimit.rateLimit.burst=50",
        "traefik.http.middlewares.ratelimit.rateLimit.period=10s",
      ]
    }

    task "rimgo" {
      driver = "docker"

      user = "nobody"

      config {
        image           = "codeberg.org/rimgo/rimgo:1.3.0"
        ports           = ["http"]
        readonly_rootfs = true
        security_opt    = ["no-new-privileges"]
        cap_drop        = ["all"]
      }

      artifact {
        source = "https://codeberg.org/rimgo/rimgo/raw/branch/main/.env.example"
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
