job "n8n" {
  group "n8n" {

    volume "data" {
      type   = "host"
      source = "n8n"
    }

    network {
      port "http" {
        to = "5678"
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

    task "n8n" {
      driver = "docker"

      config {
        image = "n8nio/n8n:1.112.1"
        ports = ["http"]
        # volumes = [
        #   "/opt/nomad-volume/n8n:/home/node/.n8n"
        # ]
      }

      volume_mount {
        volume      = "data"
        destination = "/home/node/.n8n"
      }

      env {
        N8N_PROTOCOL                = "https"
        NODE_ENV                    = "production"
        EXECUTIONS_DATA_PRUNE       = true
        DB_SQLITE_VACUUM_ON_STARTUP = true
      }

      template {
        data        = <<EOF
{{ with nomadVar "nomad/jobs" }}
N8N_HOST = {{env "NOMAD_JOB_NAME"}}.{{ .domain }}
WEBHOOK_URL = https://{{env "NOMAD_JOB_NAME"}}.{{ .domain }}/
{{ end }}
EOF
        destination = "local/env"
        env         = true
      }

      resources {
        cpu    = 200
        memory = 256
      }
    }
  }
}
