job "mlmym" {
  datacenters = ["dc1"]
  type        = "service"

  group "mlmym" {
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
      ]
    }

    task "mlmym" {
      driver = "docker"

      user = "nobody"

      config {
        image           = "ghcr.io/rystaf/mlmym:0.0.50"
        ports           = ["http"]
        readonly_rootfs = true
        security_opt    = ["no-new-privileges"]
        cap_drop        = ["all"]
      }

      env {
        # TODO: Change this to the self-hosted instance
        # LEMMY_DOMAIN = "lemmydomain.com"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
