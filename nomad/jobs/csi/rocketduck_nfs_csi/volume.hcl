id        = "test-volume" # ID as seen in nomad
name      = "test-volume" # Display name
type      = "csi"
plugin_id = "nfs" # Needs to match the deployed plugin

capability {
  access_mode     = "multi-node-multi-writer"
  attachment_mode = "file-system"
}

parameters { # Optional, allows changing owner (etc) during volume creation
  uid  = "1000"
  gid  = "1000"
  mode = "770"
}
