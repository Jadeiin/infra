job "trafiboard" {
  datacenters = ["dc1"]
  type        = "service"

  group "trafiboard" {
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

    task "trafiboard" {
      driver = "docker"

      config {
        image      = "ghcr.io/bartoszkaszewczuk/trafiboard:v0.15.0"
        ports      = ["http"]
      }

      template {
        data        = <<EOF
{{range nomadService "traefik"}}
TB_HOSTS = '[{"url":"http://{{.Address}}:{{.Port}}","username":"","password":""}]'
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
