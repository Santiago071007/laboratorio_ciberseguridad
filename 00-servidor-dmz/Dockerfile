FROM python:3.12-alpine
WORKDIR /app
COPY app.py .
# Nombre que se muestra en la pagina; se puede sobrescribir en Render con una
# variable de entorno ESTUDIANTE_NOMBRE.
ENV ESTUDIANTE_NOMBRE="David Santiago Cantor Torres"
EXPOSE 8080
CMD ["python", "app.py"]
