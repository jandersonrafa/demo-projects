use serde::Deserialize;
use bigdecimal::BigDecimal;

#[derive(Debug, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct CreateBonusDto {
    pub amount: BigDecimal,
    pub description: String,
    pub client_id: String,
}
