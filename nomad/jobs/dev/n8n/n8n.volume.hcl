name      = "n8n"
type      = "host"
plugin_id = "mkdir"
parameters = {
  uid = 1000
  gid = 1000
}
capability {
  access_mode     = "single-node-writer"
  attachment_mode = "file-system"
}