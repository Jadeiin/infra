job "priviblur" {
  datacenters = ["dc1"]
  type        = "service"

  group "priviblur" {
    count = 1

    network {
      port "http" {
        to = 8000
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

    task "priviblur" {
      driver = "docker"

      config {
        image = "quay.io/syeopite/priviblur:0.3.0"
        ports = ["http"]
      }

      env {
        PRIVIBLUR_CONFIG_LOCATION = "${NOMAD_TASK_DIR}/config.toml"
      }

      artifact {
        source = "https://github.com/syeopite/priviblur/raw/refs/heads/master/config.example.toml"
      }

      template {
        source      = "local/config.example.toml"
        destination = "local/config.toml"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }

    # task "redis" {
    #   driver = "docker"

    #   config {
    #     image = "redis:8.6.1"
    #     ports = ["redis"]
    #   }

    #   resources {
    #     cpu    = 100
    #     memory = 64
    #   }
    # }
  }
}
