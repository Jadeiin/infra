job "storage-controller" {
  datacenters = ["dc1"]
  type        = "service"

  group "controller" {
    task "controller" {
      driver = "docker"

      config {
        image = "registry.gitlab.com/rocketduck/csi-plugin-nfs:1.0.0"

        args = [
          "--type=controller",
          "--node-id=${attr.unique.hostname}",
          "--nfs-server=192.168.100.103:/srv/nfs", # Adjust accordingly
          "--mount-options=defaults",              # Adjust accordingly
        ]

        network_mode = "host" # required so the mount works even after stopping the container

        privileged = true
      }

      csi_plugin {
        id        = "nfs" # Whatever you like, but node & controller config needs to match
        type      = "controller"
        mount_dir = "/csi"
      }

      resources {
        cpu    = 50
        memory = 64
      }

    }
  }
}
