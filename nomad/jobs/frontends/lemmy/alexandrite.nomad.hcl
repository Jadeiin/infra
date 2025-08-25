job "alexandrite" {
  datacenters = ["dc1"]
  type        = "service"

  group "alexandrite" {
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
      ]
    }

    task "alexandrite" {
      driver = "docker"

      user = "nobody"

      config {
        image           = "ghcr.io/sheodox/alexandrite:0.8.20"
        ports           = ["http"]
        readonly_rootfs = true
        security_opt    = ["no-new-privileges"]
        cap_drop        = ["all"]
      }

      env {
        # TODO: Change this to the self-hosted instance
        # ALEXANDRITE_DEFAULT_INSTANCE = "lemmy.world"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
