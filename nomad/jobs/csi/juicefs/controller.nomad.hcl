job "jfs-controller" {
  datacenters = ["dc1"]
  type        = "service"

  group "controller" {
    task "plugin" {
      driver = "docker"

      config {
        image = "juicedata/juicefs-csi-driver:v0.27.0"

        args = [
          "--endpoint=unix://csi/csi.sock",
          "--logtostderr",
          "--v=5",
          "--nodeid=${attr.unique.hostname}",
          "--by-process=true",
        ]

        privileged = true
      }

      csi_plugin {
        id        = "juicefs0"
        type      = "controller"
        mount_dir = "/csi"
      }
      resources {
        cpu    = 100
        memory = 64
      }
      env {
        POD_NAME = "csi-controller"
      }
    }
  }
}
