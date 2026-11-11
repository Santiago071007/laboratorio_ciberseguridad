"""Modulo 00 - Servidor web DMZ (objetivo/victima del laboratorio).

Sirve una pagina personalizada con el nombre del estudiante y registra en los
logs cada peticion entrante, de modo que se evidencien los ataques de los
demas modulos (DoS, escaneo, fuerza bruta, credential stuffing, MITM).

Laboratorio de Ciberseguridad de David Santiago Cantor Torres.
"""
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

NOMBRE = os.environ.get("ESTUDIANTE_NOMBRE", "David Santiago Cantor Torres")
PORT = int(os.environ.get("PORT", "8080"))

# Codigos de respuesta por ruta, para que el modulo de fuerza bruta reciba
# resultados variados (401 en rutas protegidas, 404 en inexistentes).
RESPUESTAS = {
    "/admin": 401,
    "/login": 401,
    "/config.php": 404,
    "/backup.zip": 404,
    "/secret": 404,
}


def pagina(ruta: str, codigo: int) -> str:
    return f"""<!doctype html>
<html lang="es"><head><meta charset="utf-8">
<title>Servidor DMZ - {NOMBRE}</title>
<style>
  body {{ font-family: "Segoe UI", Arial, sans-serif; background: #0b1f3f; color: #e6eefa;
         display: flex; min-height: 100vh; align-items: center; justify-content: center; margin: 0; }}
  .caja {{ text-align: center; padding: 48px 56px; border: 1px solid #1a417a; border-radius: 16px;
          background: #12305a; box-shadow: 0 10px 40px rgba(0,0,0,.4); }}
  h1 {{ color: #f6c343; margin: 0 0 10px; font-size: 28px; }}
  code {{ color: #9fd0ff; }}
  .estado {{ color: #7fd8a6; font-weight: 700; }}
</style></head>
<body><div class="caja">
  <h1>Servidor DMZ Activo</h1>
  <p class="estado">Laboratorio de Ciberseguridad de <b>{NOMBRE}</b></p>
  <p>Este es el servidor objetivo (victima) del laboratorio.</p>
  <p>Ruta solicitada: <code>{ruta}</code> &middot; Respuesta: <code>{codigo}</code></p>
</div></body></html>"""


class Handler(BaseHTTPRequestHandler):
    def _responder(self):
        codigo = RESPUESTAS.get(self.path, 200)
        cuerpo = pagina(self.path, codigo).encode("utf-8")
        self.send_response(codigo)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.send_header("Content-Length", str(len(cuerpo)))
        self.end_headers()
        self.wfile.write(cuerpo)

    def do_GET(self):
        print(f"[DMZ] GET {self.path} desde {self.client_address[0]}", flush=True)
        self._responder()

    def do_POST(self):
        print(f"[DMZ] POST {self.path} desde {self.client_address[0]}", flush=True)
        self._responder()

    def log_message(self, *args):
        pass  # Se usan los prints personalizados de arriba.


if __name__ == "__main__":
    print(f"[DMZ] Servidor de {NOMBRE} escuchando en el puerto {PORT}", flush=True)
    HTTPServer(("", PORT), Handler).serve_forever()
