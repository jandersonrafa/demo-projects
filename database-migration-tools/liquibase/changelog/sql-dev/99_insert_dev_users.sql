-- liquibase formatted sql
-- changeset dev_demo:3
INSERT INTO users (username, email) VALUES ('dev_user_1', 'dev1@example.com');
INSERT INTO users (username, email) VALUES ('dev_user_2', 'dev2@example.com');
-- rollback DELETE FROM users WHERE username IN ('dev_user_1', 'dev_user_2');
