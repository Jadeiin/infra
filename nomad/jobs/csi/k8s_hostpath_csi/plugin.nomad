job "csi-driver-host-path" {
  type        = "system"
  datacenters = ["dc1"]

  group "csi" {

    volume "host-volume" {
      type   = "host"
      source = "nomad-volume"
    }

    task "plugin" {
      driver = "docker"

      config {
        image = "registry.k8s.io/sig-storage/hostpathplugin:v1.15.0"

        args = [
          "--drivername=hostpath.csi.k8s.io",
          "--v=5",
          "--endpoint=${CSI_ENDPOINT}",
          "--nodeid=node-${NOMAD_ALLOC_INDEX}",
        ]

        privileged = true
      }

      csi_plugin {
        id        = "hostpath.csi.k8s.io"
        type      = "monolith" #node" # doesn't support Controller RPCs
        mount_dir = "/csi"
      }

      volume_mount {
        volume      = "host-volume"
        destination = "/csi-data-dir"
      }

      resources {
        cpu    = 50
        memory = 32
      }
    }
  }
}
