job "hello-world" {
  datacenters = ["dc1"]

  group "example" {
    count = 3

    network {
      # require a random port named "http"
      port "http" {}
    }

    task "server" {
      # we will run a docker container
      driver = "docker"

      config {
        # docker image to run
        image = "hashicorp/http-echo"
        args = [
          "-listen", ":${NOMAD_PORT_http}",
          "-text", "hello world",
        ]
        ports = [
          "http"
        ]
      }

      # exposed service
      service {
        # service name, compose the url like 'hello-world.service.myorg.com'
        name = "hello-world"
        # service will bind to this port
        port = "http"
        # tell traefik to expose this service
        tags = ["traefik.enable=true"]
      }
    }
  }
}