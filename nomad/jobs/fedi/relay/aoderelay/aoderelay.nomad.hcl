job "aoderelay" {
  datacenters = ["dc1"]
  type        = "service"
  group "aoderelay" {
    count = 1

    volume "data" {
      type   = "host"
      source = "aoderelay"
    }

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

    task "init" {
      lifecycle {
        hook = "prestart"
      }
      driver = "docker"
      config {
        image   = "busybox"
        command = "sh"
        args    = ["-c", "chown -R 991:991 /mnt"]
      }
      volume_mount {
        volume      = "data"
        destination = "/mnt"
      }
      resources {
        cpu    = 100
        memory = 32
      }
    }

    task "aoderelay" {
      driver = "docker"

      config {
        image = "asonix/relay:0.3.116"
        ports = ["http"]
        # volumes = [
        #   "/opt/nomad-volume/aoderelay:/mnt"
        # ]
      }

      volume_mount {
        volume      = "data"
        destination = "/mnt"
      }

      template {
        data        = <<EOF
HOSTNAME = {{ env "NOMAD_JOB_NAME" }}.{{ with nomadVar "nomad/jobs" }}{{ .domain }}{{ end }}
ADDR = 0.0.0.0
PORT = 8080
DEBUG = false
RESTRICTED_MODE = false
VALIDATE_SIGNATURES = true
HTTPS = true
SLED_PATH = /mnt/sled/db-0.34
PRETTY_LOGS = false
PUBLISH_BLOCKS = true
API_TOKEN = {{ with nomadVar "nomad/jobs/aoderelay" }}{{ .api_token }}{{ end }}
EOF
        destination = "secrets/env"
        env         = true
      }

      resources {
        cpu    = 200
        memory = 256
      }
    }
  }
}
