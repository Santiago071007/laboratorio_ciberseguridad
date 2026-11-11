#!/bin/sh
# Modulo 05 - Ataque a la cadena de suministro - DEMOSTRACION CONTROLADA
# Laboratorio de Ciberseguridad de David Santiago Cantor Torres.
# Simula una dependencia comprometida incluida en la imagen. El script
# "malicioso" solo imprime un mensaje: NO realiza ninguna accion real.
set -u

PORT="${PORT:-8080}"
INTERVALO="${INTERVALO:-60}"
DEP="/app/dependencia_maliciosa.sh"

demo() {
  echo "=============================================================="
  echo "[SUPPLY] $(date '+%Y-%m-%d %H:%M:%S') Revisando dependencias de la imagen"
  if [ -f "$DEP" ]; then
    echo "[SUPPLY] ALERTA: dependencia comprometida detectada en $DEP"
    sh "$DEP"
  else
    echo "[SUPPLY] No se detectaron dependencias comprometidas."
  fi
  echo "[SUPPLY] Revision completada."
}

( while true; do demo; sleep "$INTERVALO"; done ) &

cat > /app/index.html <<HTML
<!doctype html><meta charset="utf-8"><title>Modulo 05 - Cadena de suministro - dscantor</title>
<body style="font-family:Arial;background:#1a0b14;color:#fff;padding:40px">
<h1>Modulo 05 - Ataque a la cadena de suministro (simulado)</h1>
<p>Laboratorio de Ciberseguridad de David Santiago Cantor Torres</p>
<p>Detecta y "ejecuta" una dependencia comprometida de ejemplo cada $INTERVALO s.</p></body>
HTML

cd /app
exec python3 -m http.server "$PORT"
