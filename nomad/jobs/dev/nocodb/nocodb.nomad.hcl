job "nocodb" {
  group "nocodb" {

    volume "data" {
      type   = "host"
      source = "nocodb"
    }

    network {
      port "http" {
        to = "8080"
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

    task "nocodb" {
      driver = "docker"

      config {
        image = "nocodb/nocodb:0.263.8"
        ports = ["http"]
        #volumes = [
        #  "/opt/nomad-volume/nocodb:/usr/app/data"
        #]
        #mount = {
        #  type   = "bind"
        #  target = "/usr/app/data"
        #  source = "local"
        #}
      }

      volume_mount {
        volume      = "data"
        destination = "/usr/app/data"
      }

      env {
        #NC_PUBLIC_URL   = "https://${var.domain}"
        NC_DISABLE_TELE = true
      }

      resources {
        cpu    = 200
        memory = 256
      }
    }
  }
}
