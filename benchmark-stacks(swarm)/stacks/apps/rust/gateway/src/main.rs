use axum::{
    routing::{get, post},
    Router,
};
use std::sync::Arc;
use std::env;
use std::time::Duration;
use reqwest::Client;
use metrics_exporter_prometheus::PrometheusBuilder;
use gateway::{handlers, state::AppState};

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();

    let port = env::var("PORT").unwrap_or_else(|_| "3000".to_string());
    let monolith_url = env::var("MONOLITH_URL").unwrap_or_else(|_| "http://localhost:3000".to_string());

    let client = Client::builder()
        .pool_idle_timeout(Duration::from_secs(90))
        .pool_max_idle_per_host(500)
        .build()
        .expect("Failed to create reqwest client");

    let builder = PrometheusBuilder::new();
    let metrics_handle = builder.install_recorder().expect("Failed to install prometheus recorder");

    let state = Arc::new(AppState {
        monolith_url,
        client,
        metrics_handle,
    });

    let app = Router::new()
        .route("/bonus", post(handlers::proxy_post))
        .route("/bonus/recents", get(handlers::proxy_recents))
        .route("/bonus/:id", get(handlers::proxy_get))
        .route("/metrics", get(handlers::metrics))
        .with_state(state);

    let listener = tokio::net::TcpListener::bind(format!("0.0.0.0:{}", port)).await.unwrap();
    println!("Gateway listening on 0.0.0.0:{}", port);
    axum::serve(listener, app).await.unwrap();
}
