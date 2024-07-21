{{ with nomadVar "nomad/jobs/multi-scrobbler" }}
{
  "sources": [
    {
      "type": "lastfm",
      "enable": true,
      "name": "Last.FM",
      "data": {
        "apiKey": "{{ .lastfm_apikey }}",
        "secret": "{{ .lastfm_secret }}"
      }
    }
  ],
  "clients": [
    {
      "type": "listenbrainz",
      "enable": true,
      "name": "ListenBrainz",
      "data": {
        "token": "{{ .listenbrainz_token }}",
        "username": "{{ .listenbrainz_username }}"
      }
    },
    {
      "type": "maloja",
      "enable": true,
      "name": "Maloja",
      "data": {
        "url": "{{ .maloja_url }}",
        "apiKey": "{{ .maloja_apiKey }}"
      }
    }
  ]
}
{{ end }}
