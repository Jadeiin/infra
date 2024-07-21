type      = "csi"
id        = "test-volume"
name      = "test-volume"
plugin_id = "org.democratic-csi.local-hostpath"
#capacity_min = "1GiB"
#capacity_max = "1GiB"

capability {
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}

#mount_options {
#  mount_flags = ["noatime", "nfsvers=3"]
#}

#context {
#  node_attach_driver = "hostpath"
#}
