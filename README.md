# Laboratorio de Ciberseguridad — dscantor

Laboratorio educativo de **David Santiago Cantor Torres** (IU Digital de Antioquia).
Despliega un **servidor DMZ (víctima)** y **siete módulos atacantes** en contenedores
Docker sobre [Render](https://render.com), con fines **exclusivamente educativos**.

> ⚠️ **Entorno cerrado y autorizado.** Todos los módulos atacantes se dirigen
> ÚNICAMENTE al servidor DMZ propio de este laboratorio. Las intensidades son
> de **demostración** (ráfagas pequeñas, intervalos amplios), suficientes para
> evidenciar la técnica en los logs sin afectar servicios de terceros. No apuntes
> estos módulos a ningún sistema que no sea el DMZ de este laboratorio.

## Módulos

| Carpeta | Módulo | Qué hace (contra el DMZ propio) |
|---|---|---|
| `00-servidor-dmz` | Servidor DMZ (víctima) | Página web con tu nombre; registra cada petición en los logs |
| `01-ataque-dos` | Denegación de servicio | Ráfagas de peticiones HTTP y mide el tiempo de respuesta |
| `02-escaneo-puertos` | Escaneo de puertos | Prueba puertos comunes (21, 22, 80, 443, 8080, 3306) |
| `03-fuerza-bruta-rutas` | Descubrimiento de rutas | Prueba rutas comunes (`/admin`, `/login`, `/config.php`, …) |
| `04-exfiltracion-dns` | Exfiltración por DNS (simulada) | Codifica un dato de ejemplo y lo consulta como subdominio |
| `05-cadena-suministro` | Cadena de suministro (simulada) | Detecta y "ejecuta" una dependencia comprometida de ejemplo |
| `06-credential-stuffing` | Credential stuffing | Prueba usuarios con una clave fija (el DMZ responde 401) |
| `07-proxy-mitm` | Proxy MITM | Reenvía el tráfico al DMZ e inyecta un banner en la respuesta |

Cada módulo expone además una pequeña página de estado en el puerto `8080` para
que Render mantenga el servicio en estado **Live**.

## Despliegue en Render

### 1. Servidor DMZ (primero)
1. Render → **New + → Web Service → Build and deploy from a Git repository**.
2. Conecta este repositorio.
3. Configura:
   - **Name:** `servidor-web-dmz-dscantor`
   - **Root Directory:** `00-servidor-dmz`
   - **Runtime:** Docker · **Instance Type:** Free
4. **Create Web Service** y espera a **Live**. Copia la URL pública
   (ej. `https://servidor-web-dmz-dscantor.onrender.com`).

### 2. Módulos atacantes (01 al 07)
Para cada carpeta repite **New + → Web Service** con el mismo repositorio:
- **Name:** `modulo-0X-...-dscantor` (incluye tu identificador).
- **Root Directory:** la carpeta del módulo (`01-ataque-dos`, `02-escaneo-puertos`, …).
- **Runtime:** Docker · **Instance Type:** Free.

**Apuntar al DMZ:** los módulos ya usan por defecto
`https://servidor-web-dmz-dscantor.onrender.com`. Si tu URL de DMZ es distinta,
tienes dos opciones:
- En Render, pestaña **Environment** del módulo, añade una variable
  `TARGET_URL` (o `DMZ_HOST` en los módulos 02 y 04) con tu URL/host real, **o**
- Edita el valor por defecto en el `entrypoint.sh` / `app.py` del módulo en GitHub.

## Verificación (para el video y el PDF)
- Abre la URL del **DMZ**: muestra "Servidor DMZ Activo — Laboratorio de David Santiago Cantor Torres".
- Abre la URL del **módulo 07 (MITM)**: la página del DMZ aparece con el banner rojo inyectado.
- En cada servicio, pestaña **Logs**: se evidencian las ráfagas (DoS), el escaneo
  de puertos, las rutas probadas, la consulta DNS, etc., con fecha y hora.

El video (máx. 7 min) debe mostrar las URLs con el identificador `dscantor` y el
mensaje personalizado del DMZ. El PDF de evidencia recoge los logs de cada módulo.

## Probar en local (opcional)
```bash
# Servidor DMZ
docker build -t dmz ./00-servidor-dmz && docker run -p 8080:8080 dmz
# Un módulo atacante apuntando al DMZ local
docker build -t dos ./01-ataque-dos
docker run -e TARGET_URL=http://host.docker.internal:8080 dos
```
