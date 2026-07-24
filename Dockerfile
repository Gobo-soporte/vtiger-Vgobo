# ==============================================================
#  Vtiger CRM 8.4.0  –  Imagen base Gobo Tecnología
#  PHP 8.3 + Apache 2.4 (Debian Bookworm)
# ==============================================================
FROM php:8.3-apache

LABEL maintainer="Gobo Tecnología S.A.S <soporte@gobo.com.co>"
LABEL org.opencontainers.image.source="https://github.com/Gobo-soporte/vtiger-Vgobo"

# ── 1. Extensiones PHP requeridas por Vtiger 8.4 ────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    libc-client-dev libkrb5-dev libpng-dev libjpeg62-turbo-dev \
    libfreetype6-dev libxml2-dev libzip-dev libonig-dev \
    libldap2-dev libcurl4-openssl-dev zlib1g-dev \
    libicu-dev \
    cron unzip wget default-mysql-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) \
    mysqli pdo_mysql gd imap xml zip \
    mbstring bcmath intl ldap opcache \
    && pecl install apcu && docker-php-ext-enable apcu \
    && apt-get purge -y --auto-remove libc-client-dev libkrb5-dev \
    libpng-dev libjpeg62-turbo-dev libfreetype6-dev \
    libxml2-dev libzip-dev libonig-dev libldap2-dev \
    libcurl4-openssl-dev zlib1g-dev libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# ── 2. Configuración PHP optimizada ────────────────────────────
RUN { \
    echo "upload_max_filesize = 50M"; \
    echo "post_max_size = 128M"; \
    echo "max_execution_time = 600"; \
    echo "max_input_time = 120"; \
    echo "max_input_vars = 10000"; \
    echo "memory_limit = 512M"; \
    echo "output_buffering = On"; \
    echo "display_errors = Off"; \
    echo "log_errors = On"; \
    echo "error_reporting = E_WARNING & ~E_NOTICE"; \
    echo "short_open_tag = Off"; \
    echo "default_charset = UTF-8"; \
    } > /usr/local/etc/php/conf.d/vtiger.ini

# ── 3. Configuración OPcache ───────────────────────────────────
RUN { \
    echo "opcache.enable=1"; \
    echo "opcache.memory_consumption=256"; \
    echo "opcache.interned_strings_buffer=16"; \
    echo "opcache.max_accelerated_files=10000"; \
    echo "opcache.validate_timestamps=0"; \
    echo "opcache.revalidate_freq=0"; \
    } > /usr/local/etc/php/conf.d/opcache.ini

# ── 4. Apache: mod_rewrite + headers X-Forwarded (Traefik) ────
RUN a2enmod rewrite headers
RUN { \
    echo '<VirtualHost *:80>'; \
    echo '    DocumentRoot /var/www/html'; \
    echo '    <Directory /var/www/html>'; \
    echo '        AllowOverride All'; \
    echo '        Require all granted'; \
    echo '    </Directory>'; \
    echo '    # Confiar en Traefik para HTTPS'; \
    echo '    SetEnvIf X-Forwarded-Proto "https" HTTPS=on'; \
    echo '</VirtualHost>'; \
    } > /etc/apache2/sites-available/000-default.conf

# ── 5. Descargar e instalar Vtiger 8.4.0 ──────────────────────
#    Se descarga durante el build — no necesitas el .tar.gz en el repo
ARG VTIGER_URL="https://sourceforge.net/projects/vtigercrm/files/vtiger%20CRM%208.4.0/Core%20Product/vtigercrm8.4.0.tar.gz/download"
RUN wget -q --show-progress -O /tmp/vtiger.tar.gz "$VTIGER_URL" \
    && tar xzf /tmp/vtiger.tar.gz -C /tmp \
    && cp -a /tmp/vtigercrm/. /var/www/html/ \
    && rm -rf /tmp/vtiger.tar.gz /tmp/vtigercrm \
    && chown -R www-data:www-data /var/www/html

# ── 6. Aplicar personalizaciones de Gobo ───────────────────────
#    Todo lo que pongas en custom/ se copia encima del código base
COPY --chown=www-data:www-data custom/ /var/www/html/

# ── 7. Copiar migraciones SQL ──────────────────────────────────
COPY migrations/ /opt/gobo/migrations/

# ── 8. Entrypoint: ejecuta migraciones y arranca Apache ────────
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# ── 9. Directorios que deben persistir como volúmenes ──────────
VOLUME ["/var/www/html/storage", "/var/www/html/test/user_privileges"]

EXPOSE 80
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]