env "local" {
  # Definimos a fonte de "verdade absoluta" do esquema
  src = "file:///workspace/schema.sql"
  
  # Ambiente temporário em memória que o Atlas usa para testar as migrações 
  # (apontamos para o banco 'postgres' padrão que vem vazio para evitar docker-in-docker)
  dev = "postgres://demo_user:demo_password@demo_postgres:5432/postgres?sslmode=disable"
  
  # O banco de dados alvo
  url = "postgres://demo_user:demo_password@demo_postgres:5432/demo_db?sslmode=disable"
}
