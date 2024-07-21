job "democratic-csi" {
  datacenters = ["dc1"]
  type        = "system"
  priority    = 90

  group "csi" {

    volume "host-volume" {
      type   = "host"
      source = "nomad-volume"
    }

    #network {
    #  port "grpc" {}
    #}

    task "plugin" {
      driver = "docker"

      config {
        image = "democraticcsi/democratic-csi:v1.9.3"

        #ports = ["grpc"]

        args = [
          "--csi-version=1.9.0",
          "--csi-name=org.democratic-csi.local-hostpath",
          "--driver-config-file=${NOMAD_TASK_DIR}/driver-config-file.yaml",
          "--log-level=error",
          "--csi-mode=controller",
          "--csi-mode=node",
          "--server-socket=/csi-data/csi.sock",
          #"--server-address=0.0.0.0",
          #"--server-port=${NOMAD_PORT_grpc}",
        ]

        privileged = true
      }

      csi_plugin {
        id             = "org.democratic-csi.local-hostpath"
        type           = "monolith"
        mount_dir      = "/csi-data"
        #health_timeout = "150s"
      }

      volume_mount {
        volume      = "host-volume"
        destination = "/opt/csi"
      }

      template {
        destination = "${NOMAD_TASK_DIR}/driver-config-file.yaml"

        data = <<EOH
driver: local-hostpath
instance_id:
local-hostpath:
  # generally shareBasePath and controllerBasePath should be the same for this
  # driver, this path should be mounted into the csi-driver container
  shareBasePath: "/opt/csi"
  controllerBasePath: "/opt/csi"
  dirPermissionsMode: "0777"
  dirPermissionsUser: 0
  dirPermissionsGroup: 0
  snapshots:
    # can create multiple snapshot classes each with a parameters.driver value which
    # overrides the default, a single install can use all 3 simultaneously if desired
    #
    # available options:
    # - filecopy = rsync/cp
    # - restic
    # - kopia
    #
    default_driver: restic

    # snapshot hostname will be set to the csiDriver.name value, in the case
    # of local-hostpath the node name will be appended
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
      env:
        RESTIC_PASSWORD: {{ with nomadVar "nomad/jobs/democratic-csi" }}{{ .restic_password }}{{ end }}
        RESTIC_REPOSITORY: {{ with nomadVar "nomad/jobs/democratic-csi" }}{{ .restic_repository }}{{ end }}
      # AWS_ACCESS_KEY_ID=<MY_ACCESS_KEY>
      # AWS_SECRET_ACCESS_KEY=<MY_SECRET_ACCESS_KEY>
      # B2_ACCOUNT_ID=<MY_APPLICATION_KEY_ID>
      # B2_ACCOUNT_KEY=<MY_APPLICATION_KEY>

    # snapshot hostname will be set to the csiDriver.name value, in the case
    # of local-hostpath the node name will be appended
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
        cpu    = 50
        memory = 128
      }
    }
  }
}

