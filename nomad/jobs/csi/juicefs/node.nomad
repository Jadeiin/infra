job "jfs-node" {
  datacenters = ["dc1"]
  type        = "system"

  group "nodes" {
    task "juicefs-plugin" {
      driver = "docker"

      config {
        image = "juicedata/juicefs-csi-driver:v0.26.1"

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
        type      = "node"
        mount_dir = "/csi"
      }
      resources {
        cpu    = 100
        memory = 64
      }
      env {
        POD_NAME = "csi-node"
      }
    }
  }
}
