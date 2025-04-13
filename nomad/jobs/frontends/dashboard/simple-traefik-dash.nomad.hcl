job "std" {
  datacenters = ["dc1"]
  type        = "service"

  group "std" {
    count = 1

    network {
      port "http" {
        to = 5050
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

    task "std" {
      driver = "docker"

      config {
        force_pull = true
        image      = "msjpq/simple-traefik-dash:latest"
        ports      = ["http"]
      }

      template {
        data        = <<EOF
{{range nomadService "traefik"}}
STD_TRAEFIK_API = "http://{{.Address}}:{{.Port}}"
{{end}}
STD_TRAEFIK_ENTRY_POINTS = "https"
STD_TRAEFIK_EXIT_PORT = "443"
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
