#!/bin/bash
set -e

# ── Colores ────────────────────────────────────────────────────
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'

echo -e "${GREEN}[GOBO] Vtiger 8.4.0 – Iniciando...${NC}"

# ── 1. Esperar a que MariaDB esté lista ────────────────────────
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

# ── 2. Ejecutar migraciones SQL idempotentes ───────────────────
MIGRATIONS_DIR="/opt/gobo/migrations"
if [ -d "$MIGRATIONS_DIR" ] && [ -n "$VTIGER_DB_HOST" ]; then
    echo -e "${YELLOW}[GOBO] Verificando migraciones...${NC}"

    # Crear tabla de control si no existe
    mariadb -h"$VTIGER_DB_HOST" -u"$VTIGER_DB_USER" -p"$VTIGER_DB_PASSWORD" "$VTIGER_DB_NAME" <<-'EOSQL'
        CREATE TABLE IF NOT EXISTS gobo_migrations (
            id INT AUTO_INCREMENT PRIMARY KEY,
            filename VARCHAR(255) NOT NULL UNIQUE,
            executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
EOSQL

    # Ejecutar cada .sql que no se haya ejecutado
    APPLIED=0
    for SQL_FILE in $(ls "$MIGRATIONS_DIR"/*.sql 2>/dev/null | sort); do
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
fi

# ── 3. Permisos en directorios mutables ────────────────────────
for DIR in storage test/user_privileges cache logs; do
    FULL="/var/www/html/${DIR}"
    if [ -d "$FULL" ]; then
        chown -R www-data:www-data "$FULL"
    fi
done

echo -e "${GREEN}[GOBO] Arrancando Apache...${NC}"

# ── 4. Ejecutar CMD (apache2-foreground) ───────────────────────
exec "$@"
