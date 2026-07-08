job "wandb" {
  datacenters = ["dc1"]
  type        = "service"

  group "wandb" {
    count = 1

    volume "data" {
      type   = "host"
      source = "wandb"
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

    task "wandb" {
      driver = "docker"

      config {
        image = "wandb/local:0.82.2"
        ports = ["http"]
      }

      volume_mount {
        volume      = "data"
        destination = "/vol"
      }

      env {
        LICENSE = ""
      }

      template {
        data        = <<EOF
{{ with nomadVar "nomad/jobs/wandb" }}
LICENSE = "{{ .license }}"
{{ end }}
EOF
        destination = "local/env"
        env         = true
      }

      resources {
        cpu    = 500
        memory = 1024
      }
    }
  }
}
