job "plugin-nfs-nodes" {
  datacenters = ["dc1"]

  type = "system"

  group "nodes" {
    task "plugin" {
      driver = "docker"
      config {
        image = "registry.k8s.io/sig-storage/nfsplugin:v4.13.1"
        args = [
          "--endpoint=unix://csi/csi.sock",
          "--nodeid=${attr.unique.hostname}",
          "--logtostderr",
          "--v=5",
        ]
        privileged = true
      }

      csi_plugin {
        id        = "nfs"
        type      = "node"
        mount_dir = "/csi"
      }

      resources {
        cpu    = 100
        memory = 32
      }
    }
  }
}
