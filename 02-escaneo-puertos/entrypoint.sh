#!/bin/sh
# Modulo 02 - Escaneo de puertos - DEMOSTRACION CONTROLADA
# Laboratorio de Ciberseguridad de David Santiago Cantor Torres.
# Comprueba puertos comunes UNICAMENTE en el servidor DMZ propio.
set -u

DMZ_HOST="${DMZ_HOST:-servidor-web-dmz-dscantor.onrender.com}"
PORT="${PORT:-8080}"
INTERVALO="${INTERVALO:-60}"
PUERTOS="21 22 80 443 8080 3306"

demo() {
  echo "=============================================================="
  echo "[SCAN] $(date '+%Y-%m-%d %H:%M:%S') Escaneando $DMZ_HOST"
  for p in $PUERTOS; do
    if nc -z -w 3 "$DMZ_HOST" "$p" 2>/dev/null; then
      echo "[SCAN] Puerto $p: ABIERTO"
    else
      echo "[SCAN] Puerto $p: cerrado/filtrado"
    fi
  done
  echo "[SCAN] Escaneo completado."
}

( while true; do demo; sleep "$INTERVALO"; done ) &

cat > /app/index.html <<HTML
<!doctype html><meta charset="utf-8"><title>Modulo 02 - Escaneo de puertos - dscantor</title>
<body style="font-family:Arial;background:#0b1a0b;color:#fff;padding:40px">
<h1>Modulo 02 - Escaneo de puertos</h1>
<p>Laboratorio de Ciberseguridad de David Santiago Cantor Torres</p>
<p>Escaneo de puertos ($PUERTOS) cada $INTERVALO s sobre el DMZ.</p>
<p>Objetivo: $DMZ_HOST</p></body>
HTML

cd /app
exec python3 -m http.server "$PORT"
