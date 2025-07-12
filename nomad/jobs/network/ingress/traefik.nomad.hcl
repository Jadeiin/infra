job "traefik" {
  region      = "global"
  datacenters = ["dc1"]
  type        = "service"

  group "traefik" {
    count = 1

    constraint {
      attribute = "${node.unique.name}"
      value     = "sf-1"
    }

    ephemeral_disk {
      migrate = true
    }

    network {
      port "http" {
        static = 80
      }

      port "https" {
        static = 443
      }

      port "dashboard" {
        host_network = "overlay"
        static       = 8080
      }
    }

    service {
      name     = JOB
      provider = "nomad"
      port     = "dashboard"

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }

      tags = [
        "traefik.enable=true",

        // Redirect all http requests to HTTPS
        "traefik.http.middlewares.https-redirect.redirectscheme.permanent=true",
        "traefik.http.middlewares.https-redirect.redirectscheme.scheme=https",
        "traefik.http.routers.http-catchall.entrypoints=http",
        "traefik.http.routers.http-catchall.rule=HostRegexp(`{any:.+}`)",
        "traefik.http.routers.http-catchall.middlewares=https-redirect",
      ]
    }

    task "traefik" {
      driver = "docker"

      config {
        image = "traefik:v3.4.4"
        #ports        = ["http", "https", "api"]
        network_mode = "host"
        args = [
          "--configFile=local/traefik.toml",
        ]

        #volumes = [
        #  "local/acme.json:/acme.json",  # permission 600 plz
        #  "local/traefik.toml:/etc/traefik/traefik.toml:ro",
        #]

        #mount {
        #  type   = "bind"
        #  target = "/acme.json"
        #  source = "local/acme.json"
        #}

        # mount {
        #   type     = "bind"
        #   target   = "/etc/traefik/traefik.toml"
        #   source   = "local/traefik.toml"
        #   readonly = true
        # }
      }

      template {
        data = <<EOF
[entryPoints]
  [entryPoints.http]
  address = ":{{env "NOMAD_PORT_http"}}"
  [entryPoints.https]
  address = ":{{env "NOMAD_PORT_https"}}"
  [entryPoints.traefik]
  address = ":{{env "NOMAD_PORT_dashboard"}}"

[certificatesResolvers.letsencrypt.acme]
  email = "{{ with nomadVar "nomad/jobs" }}{{ .email }}{{ end }}"
  storage = "local/acme.json"
  [certificatesResolvers.letsencrypt.acme.httpChallenge]
    entryPoint = "http"

[api]
  dashboard = true
  insecure  = true

[providers.nomad]
  exposedByDefault = false
  defaultRule = "Host(`{{`{{normalize .Name}}`}}.{{ with nomadVar "nomad/jobs" }}{{ .domain }}{{ end }}`)"
EOF
        # http://127.0.0.1:4646 (default) or unix://{{env "NOMAD_SECRETS_DIR"}}/api.sock (401) or unix:///secrets/api.sock (401)
        destination = "local/traefik.toml"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}
