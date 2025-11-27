FROM postgis/postgis:16-3.4

# Установка и генерация локалей
RUN apt-get update && apt-get install -y --no-install-recommends locales nano \
 && sed -i 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen \
 && locale-gen ru_RU.UTF-8 \
 && rm -rf /var/lib/apt/lists/*

ENV LANG=ru_RU.UTF-8 \
    LC_ALL=ru_RU.UTF-8 \
    LC_MESSAGES=ru_RU.UTF-8 \
    EDITOR=nano
