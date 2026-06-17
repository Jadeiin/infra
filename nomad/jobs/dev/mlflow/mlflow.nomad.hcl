job "mlflow" {
  datacenters = ["dc1"]
  type        = "service"

  group "mlflow" {
    count = 1

    volume "data" {
      type   = "host"
      source = "mlflow"
    }

    network {
      port "http" {
        to = 5000
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

    task "mlflow" {
      driver = "docker"

      config {
        image = "ghcr.io/mlflow/mlflow:v3.14.0"
        ports = ["http"]
        args = [
          "mlflow", "server",
          "--host", "0.0.0.0",
          "--port", "5000",
          "--backend-store-uri", "sqlite:///mlflow/mlflow.db",
          "--default-artifact-root", "/mlflow/artifacts",
        ]
      }

      volume_mount {
        volume      = "data"
        destination = "/mlflow"
      }

      resources {
        cpu    = 200
        memory = 512
      }
    }
  }
}
