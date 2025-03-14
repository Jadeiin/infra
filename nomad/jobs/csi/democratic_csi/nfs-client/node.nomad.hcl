job "storage-node" {
  datacenters = ["dc1"]
  type        = "system"

  group "node" {
    task "node" {
      driver = "docker"

      config {
        image = "democraticcsi/democratic-csi:v1.9.4"

        args = [
          "--csi-version=1.5.0",
          "--csi-name=org.democratic-csi.nfs",
          "--driver-config-file=${NOMAD_TASK_DIR}/driver-config-file.yaml",
          "--log-level=error",
          "--csi-mode=node",
          "--server-socket=/csi-data/csi.sock",
        ]

        privileged = true
      }

      csi_plugin {
        id        = "democratic-csi"
        type      = "node"
        mount_dir = "/csi-data"
      }

      template {
        destination = "${NOMAD_TASK_DIR}/driver-config-file.yaml"

        data = <<EOH
driver: nfs-client
instance_id:
nfs:
  shareHost: server address
  shareBasePath: "/some/path"
  # shareHost:shareBasePath should be mounted at this location in the controller container
  controllerBasePath: "/storage"
  dirPermissionsMode: "0777"
  dirPermissionsUser: root
  dirPermissionsGroup: wheel
  snapshots:
    # can create multiple snapshot classes each with a parameters.driver value which
    # overrides the default, a single install can use all 3 simultaneously if desired
    #
    # available options:
    # - filecopy = rsync/cp
    # - restic
    # - kopia
    #
    default_driver: filecopy

    # snapshot hostname will be set to the csiDriver.name value, in the case
    # it is assumed that the repo has been created beforehand
    restic:
      global_flags: []
      #  - --insecure-tls

      # these are added to snapshots, but are NOT used for querying/selectors by democratic-csi
      # it is *HIGHLY* recommended to set the instance_id parameter when using restic, it should be a universally unique ID for every deployment
      # host will be set to csi driver name
      tags: []
      #  - foobar
      #  - baz=bar

      # automatically prune when a snapshot is deleted
      prune: true

      # at a minimum RESTIC_PASSWORD and RESTIC_REPOSITORY must be set, additionally
      # any relevant env vars for connecting to RESTIC_REPOSITORY should be set
      env: {}
      # RESTIC_PASSWORD
      # RESTIC_REPOSITORY
      # AWS_ACCESS_KEY_ID=<MY_ACCESS_KEY>
      # AWS_SECRET_ACCESS_KEY=<MY_SECRET_ACCESS_KEY>
      # B2_ACCOUNT_ID=<MY_APPLICATION_KEY_ID>
      # B2_ACCOUNT_KEY=<MY_APPLICATION_KEY>

    # snapshot hostname will be set to the csiDriver.name value, in the case
    # it is assumed that the repo has been created beforehand
    kopia:
      # kopia repository status -t -s
      config_token:
      global_flags: []
      # <key>:<value>
      tags: []
      #  - "foobar:true"
      env: {}
EOH
      }

      resources {
        cpu    = 30
        memory = 50
      }
    }
  }
}

