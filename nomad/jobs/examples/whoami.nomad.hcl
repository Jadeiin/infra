job "whoami" {
  datacenters = ["dc1"]

  type = "service"

  group "whoami" {
    count = 1

    constraint {
      attribute = "${attr.unique.hostname}"
      value     = "scw-1"
    }

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

    task "server" {
      env {
        WHOAMI_PORT_NUMBER = "${NOMAD_PORT_http}"
      }

      driver = "docker"

      config {
        image = "traefik/whoami"
        ports = ["http"]
      }

      resources {
        cpu    = 100
        memory = 16
      }
    }
  }
}
