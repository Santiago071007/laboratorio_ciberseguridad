FROM python:3.12-alpine
WORKDIR /app
RUN pip install --no-cache-dir flask requests
COPY app.py .
ENV ESTUDIANTE_NOMBRE="David Santiago Cantor Torres"
EXPOSE 8080
CMD ["python", "app.py"]
