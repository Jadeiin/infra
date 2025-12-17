job "trala" {
  datacenters = ["dc1"]
  type        = "service"

  group "trala" {
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

    task "trala" {
      driver = "docker"

      config {
        image = "ghcr.io/dannybouwers/trala:0.11.0"
        ports = ["http"]
      }

      template {
        data        = <<EOF
{{range nomadService "traefik"}}
TRAEFIK_API_HOST = "http://{{.Address}}:{{.Port}}"
{{end}}
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
