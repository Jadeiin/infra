job "blorp" {
  datacenters = ["dc1"]
  type        = "service"

  group "blorp" {
    count = 1

    network {
      port "http" {
        to = 80
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

    task "blorp" {
      driver = "docker"

      user = "nobody"

      config {
        image           = "christianjuth/blorp:v1.10.1"
        ports           = ["http"]
        readonly_rootfs = true
        security_opt    = ["no-new-privileges"]
        cap_drop        = ["all"]
      }

      env {
        # TODO: Change this to the self-hosted instance
        # REACT_APP_DEFAULT_INSTANCE = "https://lemmy.zip"
        # REACT_APP_NAME = "Blorp"
        # REACT_APP_LOCK_TO_DEFAULT_INSTANCE = false
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
