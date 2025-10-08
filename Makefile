 
# === Настройки проекта ===
PROJECT_NAME ?= yp-sql-course
CONTAINER     ?= yp-sql-db
COMPOSE       ?= docker-compose

# Подхватываем переменные из .env для целей типа psql
ifneq (,$(wildcard .env))
	include .env
	export
endif

.PHONY: help build up down restart logs status psql exec stop prune reset

help:
	@echo "Команды:"
	@echo "  make build    - (необязательно) собрать образы, если добавишь свои Dockerfile"
	@echo "  make up       - поднять БД в фоне"
	@echo "  make down     - остановить контейнер и сеть (данные сохранятся)"
	@echo "  make restart  - быстрый рестарт контейнера"
	@echo "  make logs     - логи PostgreSQL (Ctrl+C для выхода)"
	@echo "  make status   - показать состояние контейнера"
	@echo "  make psql     - открыть psql в контейнере (исп. переменные из .env)"
	@echo "  make exec     - интерактивная оболочка внутри контейнера"
	@echo "  make stop     - мягко остановить контейнер"
	@echo "  make reset    - ПОЛНАЯ очистка данных (удаляет volume!)"

build:
	$(COMPOSE) --project-name $(PROJECT_NAME) build

up:
	$(COMPOSE) --project-name $(PROJECT_NAME) up -d
	@echo "PostgreSQL доступен на localhost:3308 (внутри контейнера порт 5432)."

down:
	$(COMPOSE) --project-name $(PROJECT_NAME) down

restart:
	$(COMPOSE) --project-name $(PROJECT_NAME) restart

logs:
	$(COMPOSE) --project-name $(PROJECT_NAME) logs -f db

status:
	@$(COMPOSE) --project-name $(PROJECT_NAME) ps

psql:
	@docker exec -it $(CONTAINER) psql -U $(POSTGRES_USER) -d $(POSTGRES_DB)

exec:
	@docker exec -it $(CONTAINER) bash

stop:
	@docker stop $(CONTAINER) || true

# Осторожно: удаляет volume с данными!
reset:
	@echo "ВНИМАНИЕ: Это удалит все данные базы (volume 'pgdata')."
	@read -p "Продолжить? (type 'YES'): " ans; \
	if [ "$$ans" = "YES" ]; then \
		$(COMPOSE) --project-name $(PROJECT_NAME) down -v; \
		docker volume rm $$(docker volume ls -q | grep -E '^$(PROJECT_NAME)_pgdata$$') 2>/dev/null || true; \
		echo "Очищено. Запусти 'make up' для инициализации заново."; \
	else \
		echo "Отменено."; \
	fi
