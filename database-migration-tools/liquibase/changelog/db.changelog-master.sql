-- liquibase formatted sql

-- changeset dev_demo:1
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- rollback DROP TABLE users;

-- changeset dev_demo:2
INSERT INTO users (username, email) VALUES ('admin_liquibase', 'admin@example.com');
-- rollback DELETE FROM users WHERE username = 'admin_liquibase';
