terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Criando primeiro container
resource "docker_image" "image_container_um" {
  name         = "nginx"
  keep_locally = false
}     

resource "docker_container" "container_um" {
  image = docker_image.image_container_um.image_id
  name  = "container_um"

  ports {
    internal = 80
    external = 8000
  }
}

# Criando segundo container
resource "docker_image" "image_container_dois" {
  name         = "ubuntu:latest"
  keep_locally = false
}

resource "docker_container" "container_dois" {
  image = docker_image.image_container_dois.image_id
  name  = var.teste_var_container_dois

  must_run          = true
  publish_all_ports = true
  command = [
    "tail",
    "-f",
    "/dev/null"
  ]
}

# Importando modulo que cria terceiro container
module "teste_module" {
  source = "./modules/teste_module"
  container_name   = "container_tres"
}
