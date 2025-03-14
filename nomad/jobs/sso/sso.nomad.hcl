job "sso" {
  datacenters = ["dc1"]
  type        = "service"

  group "openldap" {
    count = 1

    network {
      port "ldap" {
        to = 4593
      }
    }

    task "openldap" {
      driver = "docker"

      config {
        image = "bitnami/openldap:2.6.9"
        ports = ["ldap"]
        volumes = [
          "/opt/nomad-volume/openldap/data:/bitnami/openldap",
        ]
      }

      env {
        LDAP_ALLOW_ANON_BINDING = "no"
        LDAP_LOGLEVEL           = "none"
      }

      template {
        data        = <<EOF
{{ with nomadVar "nomad/jobs/sso" }}
LDAP_ROOT = " {{ . ldap_root }}"
LDAP_ADMIN_PASSWORD = "{{ .ldap_admin_password }}"
{{ end }}
EOF
        destination = "secrets/env"
        env         = true
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }

  group "glewlwyd" {
    count = 1

    network {
      port "http" {
        to = 4593
      }
    }

    task "glewlwyd" {
      driver = "docker"

      config {
        image = "babelouest/glewlwyd:2.7.6"
        ports = ["http"]
        volumes = [
          "/opt/nomad-volume/glewlwyd/config:/etc/glewlwyd",
          "/opt/nomad-volume/glewlwyd/data:/var/cache/glewlwyd",
        ]
      }

      env {
        GLWD_PROFILE_DELETE = "disable"
        GLWD_COOKIE_SECURE  = "1"
      }

      template {
        data        = <<EOF
{{ with nomadVar "nomad/jobs" }}
GLWD_EXTERNAL_URL = "https://glwd.{{ .domain }}"
GLWD_COOKIE_DOMAIN = "glwd.{{ .domain }}"
{{ end }}
EOF
        destination = "local/env"
        env         = true
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}
