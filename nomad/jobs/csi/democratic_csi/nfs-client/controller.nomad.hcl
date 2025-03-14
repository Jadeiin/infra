job "storage-controller" {
  datacenters = ["dc1"]
  type        = "service"

  group "controller" {
    network {
      port "grpc" {}
    }

    task "controller" {
      driver = "docker"

      config {
        image = "democraticcsi/democratic-csi:v1.9.4"
        ports = ["grpc"]

        args = [
          "--csi-version=1.5.0",
          "--csi-name=org.democratic-csi.nfs",
          "--driver-config-file=${NOMAD_TASK_DIR}/driver-config-file.yaml",
          "--log-level=error",
          "--csi-mode=controller",
          "--server-socket=/csi-data/csi.sock",
          "--server-address=0.0.0.0",
          "--server-port=${NOMAD_PORT_grpc}",
        ]

        privileged = true
      }

      csi_plugin {
        id        = "democratic-csi"
        type      = "controller"
        mount_dir = "/csi-data"
      }

      template {
        destination = "${NOMAD_TASK_DIR}/driver-config-file.yaml"

        data = <<EOH
# common options for the controller service

csi:
  # manual override of the available access modes for the deployment
  # generally highly uncessary to alter so only use in advanced scenarios
  #access_modes: []
EOH
      }

      resources {
        cpu    = 30
        memory = 50
      }
    }
  }
}

