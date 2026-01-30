FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN mkdir -p /tmp/prometheus_multiproc
CMD gunicorn app.main:app --workers 6 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:${PORT:-8000}
