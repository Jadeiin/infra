job "redlib" {
  datacenters = ["dc1"]
  type        = "service"

  group "redlib" {
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
        // RateLimit
        "traefik.http.routers.${NOMAD_JOB_NAME}.middlewares=ratelimit@file",
        "traefik.http.middlewares.ratelimit.rateLimit.average=100",
        "traefik.http.middlewares.ratelimit.rateLimit.burst=50",
        "traefik.http.middlewares.ratelimit.rateLimit.period=10s",
      ]
      check {
        type     = "http"
        path     = "/settings"
        interval = "5m"
        timeout  = "3s"
      }
    }

    task "redlib" {
      driver = "docker"

      user = "nobody"

      config {
        force_pull      = true
        image           = "quay.io/redlib/redlib:latest"
        ports           = ["http"]
        readonly_rootfs = true
        security_opt    = ["no-new-privileges"]
        cap_drop        = ["all"]
      }

      artifact {
        source = "https://github.com/redlib-org/redlib/raw/refs/heads/main/.env.example"
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
