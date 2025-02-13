CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    age INT CHECK (age > 0)
);

INSERT INTO users (name, email, age) 
SELECT * FROM (VALUES
    ('Alice Dupont', 'alice.dupont@example.com', 28),
    ('Bob Martin', 'bob.martin@example.com', 35),
    ('Charlie Durand', 'charlie.durand@example.com', 22),
    ('Diane Leroy', 'diane.leroy@example.com', 30)
) AS new_users(name, email, age)
WHERE NOT EXISTS (SELECT 1 FROM users WHERE users.email = new_users.email);

