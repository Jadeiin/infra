job "alpine" {
  group "alpine" {

    #network {
    #  mode = "bridge"
    #}

    constraint {
      attribute = "${node.unique.name}"
      value     = "scw-1"
    }

    volume "cache-volume" {
      type            = "csi"
      source          = "test-volume"
      attachment_mode = "file-system"
      access_mode     = "multi-node-multi-writer"
    }

    task "alpine" {
      #driver = "containerd-driver"
      #driver = "podman"
      driver = "docker"


      config {
        image   = "alpine"
        command = "sleep"
        args    = ["infinity"]
        #volumes = [
        #  "/opt/nomad-volume/alpine:/data"
        #]
      }

      volume_mount {
        volume      = "cache-volume"
        destination = "/data"
      }

      resources {
        cpu    = 50
        memory = 32
      }
    }
  }
}
