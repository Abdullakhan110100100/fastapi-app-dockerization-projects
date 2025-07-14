FROM python:3.9-slim

# Install system dependencies for psycopg2
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    python3-dev \
    libpq-dev \
    netcat-openbsd && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY wait-for-it.sh .
RUN chmod +x wait-for-it.sh

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["./wait-for-it.sh", "db:5432", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]