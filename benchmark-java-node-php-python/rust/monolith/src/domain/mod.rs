use serde::{Deserialize, Serialize};
use sqlx::FromRow;
use bigdecimal::BigDecimal;
use chrono::NaiveDateTime;

#[derive(Debug, Serialize, Deserialize, FromRow)]
pub struct Client {
    pub id: String,
    pub name: String,
    pub active: bool,
}

#[derive(Debug, Serialize, Deserialize, FromRow)]
#[serde(rename_all = "camelCase")]
pub struct Bonus {
    pub id: i32,
    pub amount: BigDecimal,
    pub description: String,
    pub client_id: String,
    pub expiration_date: Option<NaiveDateTime>,
    pub created_at: NaiveDateTime,
}
