-- liquibase formatted sql
-- changeset dev_demo:2
INSERT INTO users (username, email) VALUES ('admin_liquibase', 'admin@example.com');
-- rollback DELETE FROM users WHERE username = 'admin_liquibase';
