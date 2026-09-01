# ==============================================================
#  Vtiger CRM 8.4.0  –  Imagen base Gobo Tecnología
#  PHP 8.3 + Apache 2.4 (Debian Bookworm)
# ==============================================================
FROM php:8.3-apache-bookworm

LABEL maintainer="Gobo Tecnología S.A.S <soporte@gobo.com.co>"
LABEL org.opencontainers.image.source="https://github.com/Gobo-soporte/vtiger-Vgobo"

# ── 1. Librerías RUNTIME (estas se quedan) ─────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpng16-16 libjpeg62-turbo libfreetype6 libzip4 \
    libonig5 libldap-2.5-0 libicu72 libkrb5-3 \
    libc-client2007e libxml2 libcurl4 zlib1g \
    cron unzip wget default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

# ── 2. Librerías DEV (solo para compilar, se borran después) ───
RUN apt-get update && apt-get install -y --no-install-recommends \
    libc-client-dev libkrb5-dev libpng-dev libjpeg62-turbo-dev \
    libfreetype6-dev libxml2-dev libzip-dev libonig-dev \
    libldap2-dev libcurl4-openssl-dev zlib1g-dev libicu-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) \
    mysqli pdo_mysql gd imap xml zip \
    mbstring bcmath intl ldap opcache exif soap curl \
    && pecl install apcu && docker-php-ext-enable apcu \
    && apt-get purge -y --auto-remove \
    libc-client-dev libkrb5-dev libpng-dev libjpeg62-turbo-dev \
    libfreetype6-dev libxml2-dev libzip-dev libonig-dev \
    libldap2-dev libcurl4-openssl-dev zlib1g-dev libicu-dev \
    && rm -rf /var/lib/apt/lists/*

# ── 2.1. Instalar ionCube Loader para PHP 8.3 ─────────────────
RUN cd /tmp \
    && wget -q https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
    && tar -xzf ioncube_loaders_lin_x86-64.tar.gz \
    && EXT_DIR=$(php -r 'echo ini_get("extension_dir");') \
    && cp ioncube/ioncube_loader_lin_8.3.so $EXT_DIR/ \
    && echo "zend_extension = $EXT_DIR/ioncube_loader_lin_8.3.so" > /usr/local/etc/php/conf.d/00-ioncube.ini \
    && rm -rf /tmp/ioncube*

# ── 3. Configuración PHP optimizada ───────────────────────────
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

# ── 4. Configuración OPcache ──────────────────────────────────
RUN { \
    echo "opcache.enable=1"; \
    echo "opcache.memory_consumption=256"; \
    echo "opcache.interned_strings_buffer=16"; \
    echo "opcache.max_accelerated_files=10000"; \
    echo "opcache.validate_timestamps=1"; \
    echo "opcache.revalidate_freq=2"; \
    } > /usr/local/etc/php/conf.d/opcache.ini

# ── 5. Apache: mod_rewrite + headers X-Forwarded (Traefik) ────
RUN a2enmod rewrite headers
RUN { \
    echo '<VirtualHost *:80>'; \
    echo '    DocumentRoot /var/www/html'; \
    echo '    <Directory /var/www/html>'; \
    echo '        AllowOverride All'; \
    echo '        Require all granted'; \
    echo '    </Directory>'; \
    echo '    SetEnvIf X-Forwarded-Proto "https" HTTPS=on'; \
    echo '</VirtualHost>'; \
    } > /etc/apache2/sites-available/000-default.conf

# ── 6. Descargar e instalar Vtiger 8.4.0 ──────────────────────
ARG VTIGER_URL="https://sourceforge.net/projects/vtigercrm/files/vtiger%20CRM%208.4.0/Core%20Product/vtigercrm8.4.0.tar.gz/download"
RUN wget -q --show-progress -O /tmp/vtiger.tar.gz "$VTIGER_URL" \
    && tar xzf /tmp/vtiger.tar.gz -C /tmp \
    && cp -a /tmp/vtigercrm/. /var/www/html/ \
    && rm -rf /tmp/vtiger.tar.gz /tmp/vtigercrm

# ── 7. Preparar directorios con permisos correctos ────────────
RUN mkdir -p /var/www/html/cache/images \
    /var/www/html/cache/import \
    /var/www/html/logs \
    /var/www/html/storage \
    /var/www/html/test/user_privileges \
    /var/www/html/user_privileges \
    && touch /var/www/html/config.inc.php \
    && chown -R www-data:www-data /var/www/html \
    && chmod 775 /var/www/html \
    && chmod 666 /var/www/html/config.inc.php

# ── 8. Aplicar personalizaciones de Gobo ──────────────────────
COPY --chown=www-data:www-data custom/ /var/www/html/

# ── 9. Copiar migraciones SQL ─────────────────────────────────
COPY migrations/ /opt/gobo/migrations/

# ── 10. Entrypoint ────────────────────────────────────────────
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# NOTA (30-ago-2026): se removió "/var/www/html/storage" de esta declaración.
# La imagen forzaba un volumen anónimo ahí en cada recreación del contenedor,
# tapando la carpeta real de adjuntos (~36GB) montada vía el volumen de
# /var/www/html. "storage" ya queda cubierto como subcarpeta normal del
# volumen de la app — no necesita su propia entrada VOLUME.
VOLUME ["/var/www/html/test/user_privileges"]
EXPOSE 80
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
