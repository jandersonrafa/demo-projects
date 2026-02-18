use axum::{
    routing::{get, post},
    Router,
};
use sqlx::postgres::PgPoolOptions;
use std::sync::Arc;
use std::env;
use metrics_exporter_prometheus::PrometheusBuilder;
use monolith::{repository, service, handlers};

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();

    // Port definition
    let port = env::var("PORT").unwrap_or_else(|_| "3000".to_string());
    
    // DB setup
    let db_host = env::var("DB_HOST").unwrap_or_else(|_| "localhost".to_string());
    let db_port = env::var("DB_PORT").unwrap_or_else(|_| "5432".to_string());
    let db_user = env::var("DB_USER").unwrap_or_else(|_| "postgres".to_string());
    let db_pass = env::var("DB_PASSWORD").unwrap_or_else(|_| "postgres".to_string());
    let db_name = env::var("DB_NAME").unwrap_or_else(|_| "benchmark".to_string());

    let database_url = format!("postgres://{}:{}@{}:{}/{}", db_user, db_pass, db_host, db_port, db_name);

    let max_pool_size = env::var("DB_MAX_POOL_SIZE")
        .ok()
        .and_then(|s| s.parse::<u32>().ok())
        .unwrap_or(15);

    let pool = PgPoolOptions::new()
        .max_connections(max_pool_size)
        .connect(&database_url)
        .await
        .expect("Failed to create pool");

    // Prometheus recorder
    let builder = PrometheusBuilder::new();
    let handle = builder.install_recorder().expect("Failed to install prometheus recorder");

    let repo = Arc::new(repository::Repository::new(pool));
    let service = Arc::new(service::Service::new(repo));

    let app = Router::new()
        .route("/bonus", post(handlers::create_bonus))
        .route("/bonus/recents", get(handlers::get_recents))
        .route("/bonus/:id", get(handlers::get_bonus))
        .route("/metrics", get(move || async move { handle.render() }))
        .with_state(service);

    let listener = tokio::net::TcpListener::bind(format!("0.0.0.0:{}", port)).await.unwrap();
    println!("Monolith listening on 0.0.0.0:{}", port);
    axum::serve(listener, app).await.unwrap();
}
