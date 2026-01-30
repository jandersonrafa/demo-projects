use crate::domain::Bonus;
use crate::dto::CreateBonusDto;
use crate::repository::Repository;
use chrono::{Duration, Utc};
use std::sync::Arc;
use bigdecimal::{BigDecimal, FromPrimitive};

pub struct Service {
    repo: Arc<Repository>,
}

impl Service {
    pub fn new(repo: Arc<Repository>) -> Self {
        Self { repo }
    }

    pub async fn create_bonus(&self, dto: CreateBonusDto) -> Result<Bonus, String> {
        let client = self.repo.find_client_by_id(&dto.client_id)
            .await
            .map_err(|e| e.to_string())?
            .ok_or_else(|| "Client not found".to_string())?;

        if !client.active {
            return Err("Client is inactive".to_string());
        }

        let mut amount = dto.amount;
        let limit = BigDecimal::from_i32(100).unwrap();
        if amount > limit {
            let multiplier = BigDecimal::from_f64(1.1).unwrap();
            amount = (amount * multiplier).with_scale(2);
        }

        let now = Utc::now().naive_utc();
        let expiration_date = now + Duration::days(30);

        let bonus = Bonus {
            id: 0,
            amount,
            description: format!("RUST - {}", dto.description),
            client_id: dto.client_id,
            expiration_date: Some(expiration_date),
            created_at: now,
        };

        self.repo.create_bonus(&bonus).await.map_err(|e| e.to_string())
    }

    pub async fn get_bonus(&self, id: i32) -> Result<Option<Bonus>, String> {
        self.repo.find_bonus_by_id(id).await.map_err(|e| e.to_string())
    }
}
