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
      ]
    }

    task "rimgo" {
      driver = "docker"

      user = "nobody"

      config {
        image           = "codeberg.org/rimgo/rimgo:1.2.6"
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
