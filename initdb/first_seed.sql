-- Создание таблицы пользователей
CREATE TABLE users (
                       id SERIAL PRIMARY KEY,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       email VARCHAR(100) NOT NULL UNIQUE,
                       created_at TIMESTAMP DEFAULT now()
);

-- Добавим немного пользователей
INSERT INTO users (username, email) VALUES
                                        ('alice', 'alice@example.com'),
                                        ('bob', 'bob@example.com'),
                                        ('charlie', 'charlie@example.com');

-- Создание таблицы заказов
CREATE TABLE orders (
                        id SERIAL PRIMARY KEY,
                        user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                        product VARCHAR(100) NOT NULL,
                        amount INT NOT NULL CHECK (amount > 0),
                        created_at TIMESTAMP DEFAULT now()
);

-- Добавим несколько заказов
INSERT INTO orders (user_id, product, amount) VALUES
                                                  (1, 'Laptop', 1),
                                                  (1, 'Mouse', 2),
                                                  (2, 'Keyboard', 1),
                                                  (3, 'Monitor', 2),
                                                  (3, 'USB Cable', 5);
