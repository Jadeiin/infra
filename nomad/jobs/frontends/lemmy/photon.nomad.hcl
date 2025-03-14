job "photon" {
  datacenters = ["dc1"]
  type        = "service"

  group "photon" {
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

    task "photon" {
      driver = "docker"

      user = "nobody"

      config {
        image           = "ghcr.io/xyphyn/photon:v1.31.4"
        ports           = ["http"]
        readonly_rootfs = true
        security_opt    = ["no-new-privileges"]
        cap_drop        = ["all"]
      }

      env {
        # TODO: Change this to the self-hosted instance
        #   PUBLIC_INSTANCE_URL = "lemmy.ml"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
