job "multi-scrobbler" {
  datacenters = ["dc1"]
  type        = "service"

  group "multi-scrobbler" {

    ephemeral_disk {
      migrate = true
    }

    network {
      port "http" {
        to = 9078
      }
    }

    service {
      name     = JOB
      port     = "http"
      provider = "nomad"
    }

    task "multi-scrobbler" {
      driver = "docker"

      config {
        image = "foxxmd/multi-scrobbler:0.8.1-alpine"
        ports = ["http"]
        #volumes = [
        #  "secrets/config.json:/config/config.json",
        #]
      }

      env {
        CONFIG_DIR = NOMAD_TASK_DIR
      }

      template {
        data        = <<EOF
{{ $name := env "NOMAD_JOB_NAME"}}
{{ range nomadService $name }}
BASE_URL = "http://{{ .Address }}:{{ .Port }}"
{{ end }}
EOF
        destination = "local/env"
        env         = true
      }

      template {
        data        = file("config.json.tpl")
        destination = "local/config.json"
        #destination = "secrets/config.json"
      }

      resources {
        cpu    = 200
        memory = 256
      }
    }
  }
}
