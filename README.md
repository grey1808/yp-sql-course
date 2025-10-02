# YP SQL Course: PostgreSQL + Docker Compose

Учебный стенд для практики по курсу **«SQL для разработки»** (Яндекс Практикум).
Состоит из `docker-compose.yml` с PostgreSQL, `.env` для конфигурации, `Makefile` для удобных команд и папки `initdb/` для автоинициализации схемы и данных.

## Состав проекта

```
.
├─ docker-compose.yml
├─ .env.example      # шаблон переменных окружения
├─ Makefile          # запуск/остановка/psql и т.д.
└─ initdb/           # *.sql и *.sh для первичной инициализации БД
```

- **Версия Postgres:** 16  
- **Проброс порта:** `localhost:3308 -> container:5432`  
- **Данные переживают перезапуск** — хранятся в именованном volume `pgdata`.

---

## Предварительные требования

- Docker 20+ и Docker Compose v2 (`docker compose ...`)
- Git (для клонирования, если нужно)
- Любой клиент для БД (psql, DBeaver, DataGrip и т.д.)

---

## Быстрый старт

1) Склонируй репозиторий и перейди в каталог:
```bash
git clone https://github.com/grey1808/yp-sql-course.git
cd yp-sql-course
```

2) Создай файл `.env` из примера и при необходимости поправь значения:
```bash
cp .env.example .env
```

3) Подними контейнер:
```bash
make up
# Альтернатива без Makefile:
# docker compose up -d
```

4) Проверь доступность:
```bash
make status
make logs
```

5) Подключись к базе:
- Host: `localhost`
- Port: `3308`
- DB: `practicum_db`
- User: `practicum_user`
- Password: `practicum_pass`

> Эти значения берутся из `.env`. Если менял — подставь свои.

---

## Команды Makefile

```bash
make up        # поднять БД в фоне
make down      # остановить контейнер (данные сохраняются)
make restart   # перезапуск контейнера
make logs      # поток логов PostgreSQL
make status    # состояние сервисов
make psql      # открыть psql в контейнере (использует переменные из .env)
make exec      # bash в контейнере
make build     # сборка (актуально, если добавишь свои Dockerfile)
make reset     # ПОЛНАЯ очистка данных (удаляет volume!)
```

> ⚠️ `make reset` удаляет **все** данные БД. Команда запросит подтверждение.

---

## Инициализация БД (папка `initdb/`)

Все файлы `*.sql` и `*.sh` из каталога `initdb/` выполняются **один раз** при первом старте,
когда каталог данных пуст. Это удобно для создания учебных таблиц и наполнения тестовыми данными.

Пример `initdb/first_seed.sql`:
```sql
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT now()
);

INSERT INTO users (username, email) VALUES
('alice', 'alice@example.com'),
('bob', 'bob@example.com'),
('charlie', 'charlie@example.com')
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS orders (
  id SERIAL PRIMARY KEY,
  user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  product VARCHAR(100) NOT NULL,
  amount INT NOT NULL CHECK (amount > 0),
  created_at TIMESTAMP DEFAULT now()
);

INSERT INTO orders (user_id, product, amount) VALUES
(1, 'Laptop', 1),
(1, 'Mouse', 2),
(2, 'Keyboard', 1),
(3, 'Monitor', 2),
(3, 'USB Cable', 5);
```

Если БД уже была инициализирована, новые файлы из `initdb/` **не** применятся автоматически.
Варианты:
- выполнить SQL вручную через `make psql` / клиент,
- либо сбросить БД `make reset` (с удалением volume).

---

## Подключение и проверка

Открыть psql внутри контейнера:
```bash
make psql
```
Проверить таблицы:
```sql
\dt
SELECT * FROM users;
SELECT * FROM orders;
```

---

## Частые вопросы

**Данные пропадают после `down`?**  
Нет. Данные в именованном томе `pgdata`. Удаляются только при `make reset` или `docker compose down -v`.

**Порт уже занят?**  
Смени наружный порт в `docker-compose.yml` (слева от двоеточия), например `3310:5432`, и поправь инструкции подключения.

**Windows (PowerShell) и `make` нет?**  
Либо установи `make` (через Chocolatey/Scoop), либо используй команды `docker compose` напрямую:
```powershell
docker compose up -d
docker compose down
docker compose logs -f db
```

---

## Лицензия

MIT — используй свободно в учебных целях.
