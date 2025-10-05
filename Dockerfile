FROM postgres:16

# Установка и генерация локалей
FROM postgres:16

RUN apt-get update && apt-get install -y --no-install-recommends locales nano \
 && sed -i 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen \
 && locale-gen ru_RU.UTF-8 \
 && rm -rf /var/lib/apt/lists/*

# Язык по умолчанию внутри контейнера
ENV LANG=ru_RU.UTF-8 \
    LC_ALL=ru_RU.UTF-8 \
    LC_MESSAGES=ru_RU.UTF-8 \
    EDITOR=nano
