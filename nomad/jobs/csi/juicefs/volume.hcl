type      = "csi"
id        = "test-volume"
name      = "test-volume"
plugin_id = "juicefs0"

capability {
  access_mode     = "multi-node-multi-writer"
  attachment_mode = "file-system"
}

secrets {
  name    = "test-volume"
  metaurl = "sqlite3://jfs.db"
  bucket  = "192.168.100.103:/srv/nfs/test"
  storage = "nfs"
}
