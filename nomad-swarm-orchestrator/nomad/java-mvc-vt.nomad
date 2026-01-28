job "java-mvc-vt" {
  datacenters = ["dc1"]
  type = "service"
  
  group "services" {
    count = 1
    
    network {
      port "postgres" {
        static = 5432
      }
      port "monolith" {
        static = 3000
      }
      port "gateway" {
        static = 8080
      }
    }
    
    task "postgres" {
      driver = "docker"
      
      lifecycle {
        hook    = "prestart"
        sidecar = true
      }
      
      config {
        image = "postgres:15-alpine"
        network_mode = "host"
        volumes = [
          "postgres_data:/var/lib/postgresql/data"
        ]
      }

      env {
        POSTGRES_DB       = "benchmark"
        POSTGRES_USER     = "postgres"
        POSTGRES_PASSWORD = "postgres"
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }
    
    task "monolith" {
      driver = "docker"
      
      config {
        image = "java-mvc-vt-monolith:local"
        network_mode = "host"
        force_pull = false
      }

      env {
        SERVER_PORT = "3000"
        DB_HOST     = "127.0.0.1"
        DB_PORT     = "5432"
        DB_NAME     = "benchmark"
        DB_USER     = "postgres"
        DB_PASSWORD = "postgres"
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }
    
    task "wait-for-postgres" {
      driver = "docker"
      
      lifecycle {
        hook = "prestart"
      }
      
      config {
        image = "postgres:15-alpine"
        network_mode = "host"
        command = "sh"
        args = ["-c", "until pg_isready -h 127.0.0.1 -p 5432; do sleep 1; done"]
      }
      
      resources {
        cpu    = 100
        memory = 64
      }
    }
    
    task "gateway" {
      driver = "docker"
      
      config {
        image = "java-mvc-vt-gateway:local"
        network_mode = "host"
        force_pull = false
      }

      env {
        SERVER_PORT  = "8080"
        MONOLITH_URL = "http://127.0.0.1:3000"
      }

      resources {
        cpu    = 500
        memory = 512
      }
    }
  }
}
