CREATE TABLE IF NOT EXISTS clients (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    active BOOLEAN DEFAULT TRUE
);

-- Seed clients
INSERT INTO clients (id, name) 
SELECT 'client_' || i, 'Client Name ' || i
FROM generate_series(1, 100) s(i)
ON CONFLICT (id) DO NOTHING;

CREATE TABLE IF NOT EXISTS bonus (
    id SERIAL PRIMARY KEY,
    amount DECIMAL(15, 2) NOT NULL,
    description VARCHAR(255) NOT NULL,
    client_id VARCHAR(255) NOT NULL REFERENCES clients(id),
    expiration_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
