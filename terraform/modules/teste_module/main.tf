
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

resource "docker_image" "image_container_um" {
  name         = "ubuntu:latest"
  keep_locally = false
}

resource "docker_container" "container_um" {
  image = docker_image.image_container_um.image_id
  name  = var.container_name

  must_run          = true
  publish_all_ports = true
  command = [
    "tail",
    "-f",
    "/dev/null"
  ]
}