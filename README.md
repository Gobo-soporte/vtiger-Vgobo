# vtiger-Vgobo

Imagen Docker de Vtiger CRM 8.4.0 para el proyecto de migración.

**Stack:** PHP 8.3 + Apache 2.4 + MariaDB 11.8 (LTS)

## Requisito previo

Descarga el instalador oficial de Vtiger 8.4.0 y colócalo en la raíz del repo:

```bash
# Desde SourceForge
wget -O vtigercrm-8.4.0.tar.gz \
  "https://sourceforge.net/projects/vtigercrm/files/vtiger%20CRM%208.4.0/Core%20Product/vtigercrm8.4.0.tar.gz/download"
```

> **Nota:** El `.tar.gz` está en `.gitignore` (es ~110 MB).
> El workflow de GitHub Actions necesita que lo subas como
> artifact o lo descargues en el step de build.

## Estructura

```
├── Dockerfile              ← imagen base
├── docker-entrypoint.sh    ← espera DB + migraciones + Apache
├── custom/                 ← tus personalizaciones (se copian sobre /var/www/html/)
│   └── layouts/v7/modules/Quotes/resources/CPQManager.js  (ejemplo)
├── migrations/             ← SQL versionado (NNN_descripcion.sql)
└── .github/workflows/      ← CI/CD → GHCR + Portainer webhook
```

## Build local

```bash
docker compose -f docker-compose.dev.yml up --build
```

## Tags generados

| Evento              | Tag ejemplo                                    |
|---------------------|------------------------------------------------|
| Push a `main`       | `ghcr.io/soportegobo26/vtiger-Vgobo:dev`  |
| Tag `v1.0.0`        | `ghcr.io/soportegobo26/vtiger-Vgobo:1.0.0`|
| Cualquier push      | `ghcr.io/soportegobo26/vtiger-Vgobo:a3f9c21` |

## Personalización

Coloca archivos en `custom/` respetando la estructura de Vtiger:

```
custom/
├── layouts/v7/modules/MiModulo/resources/MiScript.js
├── modules/MiModulo/MiModulo.php
└── modules/MiModulo/views/List.php
```

Todo se copia con `COPY custom/ /var/www/html/` en el build.

## Migraciones SQL

Nombra los archivos `NNN_descripcion.sql` en `migrations/`.
El entrypoint los ejecuta en orden y registra cuáles ya se aplicaron
en la tabla `gobo_migrations`.
