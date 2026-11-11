FROM alpine:latest
RUN apk add --no-cache curl python3
WORKDIR /app
COPY entrypoint.sh /app/entrypoint.sh
# Dependencia "comprometida" simulada: solo imprime un mensaje, sin acciones reales.
RUN printf '#!/bin/sh\necho "[SUPPLY] (SIMULADO) Carga maliciosa en ejecucion: en un ataque real enviaria datos a un servidor C2. Ninguna accion real se realiza en este laboratorio."\n' > /app/dependencia_maliciosa.sh \
    && chmod +x /app/dependencia_maliciosa.sh /app/entrypoint.sh
EXPOSE 8080
ENTRYPOINT ["/app/entrypoint.sh"]
