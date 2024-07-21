id = "test-volume"
#external_id = "test-volume"
name      = "test-volume"
type      = "csi"
plugin_id = "nfs"

capability {
  access_mode     = "multi-node-multi-writer"
  attachment_mode = "file-system"
}

parameters {
  #context {
  server = "192.168.100.103"
  share  = "/srv/nfs"
  #subDir = "test-volume"
}

mount_options {
  fs_type = "nfs"
  #mount_flags = ["vers=4"]
  #  mount_flags = ["timeo=30", "intr", "vers=3", "_netdev", "nolock"]
}
