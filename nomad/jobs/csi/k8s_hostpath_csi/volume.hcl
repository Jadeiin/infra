id        = "test-volume"
name      = "test-volume"
type      = "csi"
plugin_id = "hostpath.csi.k8s.io"

#capacity_min = "1MB"
#capacity_max = "1GB"

capability {
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}
