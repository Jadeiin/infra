type = "csi"
id = "juicefs-volume"
name = "juicefs-volume"

capability {
access_mode = "multi-node-multi-writer"
attachment_mode = "file-system"
}
plugin_id = "juicefs0"

secrets {
  name="juicefs-volume"
  metaurl="sqlite3://jfs.db"
  bucket="192.168.100.103:/srv/nfs/test"
  storage="nfs"
}
