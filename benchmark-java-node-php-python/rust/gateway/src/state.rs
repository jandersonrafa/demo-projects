use reqwest::Client;
use metrics_exporter_prometheus::PrometheusHandle;

pub struct AppState {
    pub monolith_url: String,
    pub client: Client,
    pub metrics_handle: PrometheusHandle,
}
