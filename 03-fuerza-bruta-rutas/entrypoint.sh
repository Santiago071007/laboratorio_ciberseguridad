#!/bin/sh
# Modulo 03 - Fuerza bruta de rutas (descubrimiento de directorios)
# DEMOSTRACION CONTROLADA. Laboratorio de David Santiago Cantor Torres.
# Prueba rutas comunes UNICAMENTE contra el servidor DMZ propio.
set -u

DMZ_HOST="${DMZ_HOST:-servidor-web-dmz-dscantor.onrender.com}"
TARGET_URL="${TARGET_URL:-https://$DMZ_HOST}"
PORT="${PORT:-8080}"
INTERVALO="${INTERVALO:-60}"
RUTAS="/ /index.html /admin /login /config.php /backup.zip /secret"

demo() {
  echo "=============================================================="
  echo "[RUTAS] $(date '+%Y-%m-%d %H:%M:%S') Probando rutas en $TARGET_URL"
  for r in $RUTAS; do
    code=$(curl -s -o /dev/null -w "%{http_code}" "$TARGET_URL$r")
    echo "[RUTAS] $r -> HTTP $code"
  done
  echo "[RUTAS] Descubrimiento completado."
}

( while true; do demo; sleep "$INTERVALO"; done ) &

cat > /app/index.html <<HTML
<!doctype html><meta charset="utf-8"><title>Modulo 03 - Fuerza bruta de rutas - dscantor</title>
<body style="font-family:Arial;background:#1a140b;color:#fff;padding:40px">
<h1>Modulo 03 - Fuerza bruta de rutas</h1>
<p>Laboratorio de Ciberseguridad de David Santiago Cantor Torres</p>
<p>Prueba de rutas comunes cada $INTERVALO s sobre el DMZ.</p>
<p>Objetivo: $TARGET_URL</p></body>
HTML

cd /app
exec python3 -m http.server "$PORT"
