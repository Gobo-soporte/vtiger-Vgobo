#!/bin/bash
set -e

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${GREEN}[GOBO] Vtiger 8.4.0 – Iniciando...${NC}"

# ── 1. Preparar directorios y permisos ─────────────────────────
echo -e "${YELLOW}[GOBO] Verificando directorios y permisos...${NC}"
mkdir -p /var/www/html/cache/images \
         /var/www/html/cache/import \
         /var/www/html/logs \
         /var/www/html/storage \
         /var/www/html/test/user_privileges \
         /var/www/html/user_privileges \
         /var/www/html/test/templates_c

# Crear config.inc.php si no existe (necesario para el wizard)
if [ ! -f /var/www/html/config.inc.php ]; then
    touch /var/www/html/config.inc.php
    echo -e "${YELLOW}[GOBO] config.inc.php creado.${NC}"
fi

# Asignar permisos completos a toda la raíz HTML de forma recursiva
# Esto evita el bug donde Vtiger falla al sobrescribir archivos post-instalación
chown -R www-data:www-data /var/www/html

chmod 666 /var/www/html/config.inc.php
chmod -R 775 /var/www/html/cache \
    /var/www/html/logs \
    /var/www/html/storage \
    /var/www/html/test/user_privileges \
    /var/www/html/test/templates_c \
    /var/www/html/user_privileges

echo -e "${GREEN}[GOBO] Directorios listos.${NC}"


# ── 2. Configurar e iniciar CRON de Vtiger ─────────────────────
echo -e "${YELLOW}[GOBO] Configurando Cron...${NC}"
# Inyecta la tarea cron para el usuario www-data si no existe ya
if ! crontab -u www-data -l 2>/dev/null | grep -q "vtigercron.php"; then
    (crontab -u www-data -l 2>/dev/null; echo "*/5 * * * * /usr/local/bin/php -f /var/www/html/vtigercron.php > /dev/null 2>&1") | crontab -u www-data -
fi
# Inicia el demonio de cron en segundo plano
service cron start
echo -e "${GREEN}[GOBO] Cron iniciado.${NC}"


# ── 3. Esperar a que MariaDB esté lista ────────────────────────
if [ -n "$VTIGER_DB_HOST" ]; then
    echo -e "${YELLOW}[GOBO] Esperando a MariaDB en ${VTIGER_DB_HOST}...${NC}"
    MAX_TRIES=30
    COUNT=0
    until mariadb -h"$VTIGER_DB_HOST" -u"$VTIGER_DB_USER" -p"$VTIGER_DB_PASSWORD" -e "SELECT 1" &>/dev/null; do
        COUNT=$((COUNT + 1))
        if [ $COUNT -ge $MAX_TRIES ]; then
            echo -e "${RED}[GOBO] MariaDB no respondió después de ${MAX_TRIES} intentos. Abortando.${NC}"
            exit 1
        fi
        echo -e "${YELLOW}[GOBO] Intento ${COUNT}/${MAX_TRIES}...${NC}"
        sleep 2
    done
    echo -e "${GREEN}[GOBO] MariaDB lista.${NC}"
fi


# ── 4. Ejecutar migraciones SQL idempotentes ───────────────────
MIGRATIONS_DIR="/opt/gobo/migrations"
if [ -d "$MIGRATIONS_DIR" ] && [ -n "$VTIGER_DB_HOST" ]; then
    # Solo ejecutar si ya hay install.lock (Vtiger ya instalado)
    if [ -f /var/www/html/test/install.lock ]; then
        echo -e "${YELLOW}[GOBO] Verificando migraciones...${NC}"

        mariadb -h"$VTIGER_DB_HOST" -u"$VTIGER_DB_USER" -p"$VTIGER_DB_PASSWORD" "$VTIGER_DB_NAME" <<-'EOSQL'
            CREATE TABLE IF NOT EXISTS gobo_migrations (
                id INT AUTO_INCREMENT PRIMARY KEY,
                filename VARCHAR(255) NOT NULL UNIQUE,
                executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
EOSQL

        APPLIED=0
        # Uso de glob seguro en bash
        for SQL_FILE in "$MIGRATIONS_DIR"/*.sql; do
            # Si no hay coincidencias, el bucle recibe el literal "*.sql". Esta línea lo salta.
            [ -e "$SQL_FILE" ] || continue
            
            BASENAME=$(basename "$SQL_FILE")
            ALREADY=$(mariadb -h"$VTIGER_DB_HOST" -u"$VTIGER_DB_USER" -p"$VTIGER_DB_PASSWORD" \
                "$VTIGER_DB_NAME" -N -e \
                "SELECT COUNT(*) FROM gobo_migrations WHERE filename='${BASENAME}';")

            if [ "$ALREADY" = "0" ]; then
                echo -e "${YELLOW}[GOBO] Aplicando: ${BASENAME}${NC}"
                if mariadb -h"$VTIGER_DB_HOST" -u"$VTIGER_DB_USER" -p"$VTIGER_DB_PASSWORD" \
                    "$VTIGER_DB_NAME" < "$SQL_FILE"; then
                    mariadb -h"$VTIGER_DB_HOST" -u"$VTIGER_DB_USER" -p"$VTIGER_DB_PASSWORD" \
                        "$VTIGER_DB_NAME" -e \
                        "INSERT INTO gobo_migrations (filename) VALUES ('${BASENAME}');"
                    APPLIED=$((APPLIED + 1))
                    echo -e "${GREEN}[GOBO] OK: ${BASENAME}${NC}"
                else
                    echo -e "${RED}[GOBO] ERROR en: ${BASENAME} – continuando...${NC}"
                fi
            fi
        done

        if [ $APPLIED -eq 0 ]; then
            echo -e "${GREEN}[GOBO] Sin migraciones pendientes.${NC}"
        else
            echo -e "${GREEN}[GOBO] ${APPLIED} migración(es) aplicada(s).${NC}"
        fi
    else
        echo -e "${YELLOW}[GOBO] Vtiger no instalado aún (sin install.lock). Saltando migraciones.${NC}"
    fi
fi

echo -e "${GREEN}[GOBO] Arrancando Apache...${NC}"
exec "$@"
