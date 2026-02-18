use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::IntoResponse,
    Json,
};
use std::sync::Arc;
use crate::state::AppState;

pub async fn proxy_post(
    State(state): State<Arc<AppState>>,
    Json(payload): Json<serde_json::Value>,
) -> impl IntoResponse {
    metrics::counter!("http_requests_total", "method" => "POST", "path" => "/bonus").increment(1);
    let url = format!("{}/bonus", state.monolith_url);
    match state.client.post(url).json(&payload).send().await {
        Ok(resp) => {
            let status = StatusCode::from_u16(resp.status().as_u16()).unwrap_or(StatusCode::INTERNAL_SERVER_ERROR);
            let body = resp.bytes().await.unwrap_or_default();
            (status, [("content-type", "application/json")], body).into_response()
        }
        Err(_) => (StatusCode::BAD_GATEWAY, "Failed to connect to monolith").into_response(),
    }
}

pub async fn proxy_get(
    State(state): State<Arc<AppState>>,
    Path(id): Path<String>,
) -> impl IntoResponse {
    metrics::counter!("http_requests_total", "method" => "GET", "path" => "/bonus/:id").increment(1);
    let url = format!("{}/bonus/{}", state.monolith_url, id);
    match state.client.get(url).send().await {
        Ok(resp) => {
            let status = StatusCode::from_u16(resp.status().as_u16()).unwrap_or(StatusCode::INTERNAL_SERVER_ERROR);
            let body = resp.bytes().await.unwrap_or_default();
            (status, [("content-type", "application/json")], body).into_response()
        }
        Err(_) => (StatusCode::BAD_GATEWAY, "Failed to connect to monolith").into_response(),
    }
}

pub async fn proxy_recents(
    State(state): State<Arc<AppState>>,
) -> impl IntoResponse {
    metrics::counter!("http_requests_total", "method" => "GET", "path" => "/bonus/recents").increment(1);
    let url = format!("{}/bonus/recents", state.monolith_url);
    match state.client.get(url).send().await {
        Ok(resp) => {
            let status = StatusCode::from_u16(resp.status().as_u16()).unwrap_or(StatusCode::INTERNAL_SERVER_ERROR);
            let body = resp.bytes().await.unwrap_or_default();
            (status, [("content-type", "application/json")], body).into_response()
        }
        Err(_) => (StatusCode::BAD_GATEWAY, "Failed to connect to monolith").into_response(),
    }
}

pub async fn metrics(State(state): State<Arc<AppState>>) -> String {
    state.metrics_handle.render()
}
