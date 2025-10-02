job "4get" {
  datacenters = ["dc1"]
  type        = "service"

  group "4get" {
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

    task "4get" {
      driver = "docker"

      config {
        image        = "luuul/4get:1.0.33"
        ports        = ["http"]
        security_opt = ["no-new-privileges"]
        cap_drop     = ["all"]
      }

      template {
        data        = <<EOF
FOURGET_PROTO=http
{{ with nomadVar "nomad/jobs" }}
FOURGET_SERVER_NAME={{env "NOMAD_JOB_NAME"}}.{{ .domain }}
{{ end }}
EOF
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
