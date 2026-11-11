"""Modulo 07 - Proxy MITM (man-in-the-middle) - DEMOSTRACION CONTROLADA.

Reenvia las peticiones GET al servidor DMZ propio, registra las cabeceras e
inyecta un banner/comentario HTML en la respuesta, demostrando como un
intermediario puede observar y modificar el trafico.

Laboratorio de Ciberseguridad de David Santiago Cantor Torres.
"""
import os

import requests
from flask import Flask, Response, request

app = Flask(__name__)

NOMBRE = os.environ.get("ESTUDIANTE_NOMBRE", "David Santiago Cantor Torres")
DMZ_HOST = os.environ.get("DMZ_HOST", "servidor-web-dmz-dscantor.onrender.com")
TARGET = os.environ.get("TARGET_URL", f"https://{DMZ_HOST}").rstrip("/")
PORT = int(os.environ.get("PORT", "8080"))

BANNER = (
    f'\n<!-- [ALERTA MITM] Trafico interceptado y modificado por el '
    f'Laboratorio de Ciberseguridad de {NOMBRE} -->\n'
    f'<div style="position:fixed;bottom:0;left:0;right:0;background:#c4372f;color:#fff;'
    f'font-family:Arial;padding:8px;text-align:center">[ALERTA MITM] Interceptado por '
    f'el laboratorio de {NOMBRE}</div>\n'
)


@app.route("/", defaults={"ruta": ""}, methods=["GET", "POST"])
@app.route("/<path:ruta>", methods=["GET", "POST"])
def proxy(ruta):
    print(f"[MITM] {request.method} /{ruta} desde {request.remote_addr}", flush=True)
    for clave, valor in request.headers.items():
        print(f"[MITM]   {clave}: {valor}", flush=True)

    url = f"{TARGET}/{ruta}"
    try:
        respuesta = requests.get(url, timeout=10)
    except Exception as error:  # noqa: BLE001
        print(f"[MITM] Error al contactar el objetivo: {error}", flush=True)
        return Response(f"[MITM] Error al contactar el objetivo: {error}", status=502)

    cuerpo = respuesta.text + BANNER
    print(f"[MITM] Banner inyectado en la respuesta de {url} (HTTP {respuesta.status_code})", flush=True)
    return Response(cuerpo, status=respuesta.status_code, content_type="text/html; charset=utf-8")


if __name__ == "__main__":
    print(f"[MITM] Proxy de {NOMBRE} escuchando en {PORT}; objetivo {TARGET}", flush=True)
    app.run(host="0.0.0.0", port=PORT)
