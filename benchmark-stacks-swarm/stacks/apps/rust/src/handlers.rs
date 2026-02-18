use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::IntoResponse,
    Json,
};
use crate::dto::CreateBonusDto;
use crate::service::Service;
use std::sync::Arc;

pub async fn create_bonus(
    State(service): State<Arc<Service>>,
    Json(payload): Json<CreateBonusDto>,
) -> impl IntoResponse {
    metrics::counter!("http_requests_total", "method" => "POST", "path" => "/bonus").increment(1);
    match service.create_bonus(payload).await {
        Ok(bonus) => (StatusCode::CREATED, Json(bonus)).into_response(),
        Err(e) if e == "Client not found" => (StatusCode::NOT_FOUND, Json(serde_json::json!({ "error": e }))).into_response(),
        Err(e) if e == "Client is inactive" => (StatusCode::BAD_REQUEST, Json(serde_json::json!({ "error": e }))).into_response(),
        Err(e) => (StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({ "error": e }))).into_response(),
    }
}

pub async fn get_bonus(
    State(service): State<Arc<Service>>,
    Path(id): Path<i32>,
) -> impl IntoResponse {
    metrics::counter!("http_requests_total", "method" => "GET", "path" => "/bonus/:id").increment(1);
    match service.get_bonus(id).await {
        Ok(Some(bonus)) => (StatusCode::OK, Json(bonus)).into_response(),
        Ok(None) => (StatusCode::OK, Json(Option::<crate::domain::Bonus>::None)).into_response(),
        Err(e) => (StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({ "error": e }))).into_response(),
    }
}

pub async fn get_recents(
    State(service): State<Arc<Service>>,
) -> impl IntoResponse {
    metrics::counter!("http_requests_total", "method" => "GET", "path" => "/bonus/recents").increment(1);
    match service.get_recents().await {
        Ok(bonuses) => (StatusCode::OK, Json(bonuses)).into_response(),
        Err(e) => (StatusCode::INTERNAL_SERVER_ERROR, Json(serde_json::json!({ "error": e }))).into_response(),
    }
}
