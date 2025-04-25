job "voyager" {
  datacenters = ["dc1"]
  type        = "service"

  group "voyager" {
    count = 1

    network {
      port "http" {
        to = 5314
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

    task "voyager" {
      driver = "docker"

      user = "nobody"

      config {
        image           = "ghcr.io/aeharding/voyager:2.31.0"
        ports           = ["http"]
        readonly_rootfs = true
        security_opt    = ["no-new-privileges"]
        cap_drop        = ["all"]
      }

      env {
        # TODO: Change this to the self-hosted instance
        #   CUSTOM_LEMMY_SERVERS = "lemmy.world,lemmy.ml,sh.itjust.works"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
