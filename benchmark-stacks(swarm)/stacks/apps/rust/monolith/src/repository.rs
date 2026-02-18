use sqlx::{Pool, Postgres};
use crate::domain::{Bonus, Client};

pub struct Repository {
    pool: Pool<Postgres>,
}

impl Repository {
    pub fn new(pool: Pool<Postgres>) -> Self {
        Self { pool }
    }

    pub async fn find_client_by_id(&self, id: &str) -> Result<Option<Client>, sqlx::Error> {
        sqlx::query_as::<_, Client>("SELECT id, name, active FROM clients WHERE id = $1")
            .bind(id)
            .fetch_optional(&self.pool)
            .await
    }

    pub async fn create_bonus(&self, bonus: &Bonus) -> Result<Bonus, sqlx::Error> {
        sqlx::query_as::<_, Bonus>(
            "INSERT INTO bonus (amount, description, client_id, expiration_date, created_at) 
             VALUES ($1, $2, $3, $4, $5) RETURNING id, amount, description, client_id, expiration_date, created_at"
        )
        .bind(bonus.amount.clone())
        .bind(&bonus.description)
        .bind(&bonus.client_id)
        .bind(bonus.expiration_date)
        .bind(bonus.created_at)
        .fetch_one(&self.pool)
        .await
    }

    pub async fn find_bonus_by_id(&self, id: i32) -> Result<Option<Bonus>, sqlx::Error> {
        sqlx::query_as::<_, Bonus>(
            "SELECT id, amount, description, client_id, expiration_date, created_at FROM bonus WHERE id = $1"
        )
        .bind(id)
        .fetch_optional(&self.pool)
        .await
    }

    pub async fn find_top_100_bonus_by_id_asc(&self) -> Result<Vec<Bonus>, sqlx::Error> {
        sqlx::query_as::<_, Bonus>(
            "SELECT id, amount, description, client_id, expiration_date, created_at FROM bonus ORDER BY id ASC LIMIT 100"
        )
        .fetch_all(&self.pool)
        .await
    }
}
