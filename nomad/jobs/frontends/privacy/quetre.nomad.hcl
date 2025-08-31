job "quetre" {
  datacenters = ["dc1"]
  type        = "service"

  group "quetre" {
    count = 1

    network {
      port "http" {
        to = 3000
      }
      # port "redis" {
      #   to = 6379
      # }
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

    task "quetre" {
      driver = "docker"

      config {
        image = "codeberg.org/video-prize-ranch/quetre:v8.0.0"
        ports = ["http"]
      }

      env {
        NODE_ENV     = "production"
        PORT         = "3000"
        CACHE_PERIOD = "1h"
        # REDIS_URL = "redis:6379"
        REDIS_TTL = "3600"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }

    # task "redis" {
    #   driver = "docker"

    #   config {
    #     image = "redis:6.2.19"
    #     ports = ["redis"]
    #   }

    #   resources {
    #     cpu    = 100
    #     memory = 64
    #   }
    # }
  }
}
