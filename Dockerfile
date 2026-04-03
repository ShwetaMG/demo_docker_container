# STAGE 1: The Builder (Standard image)
FROM python:3.12-slim AS builder
WORKDIR /app

# Prevent python from buffering and writing pyc files
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY requirements.txt .
# Install to a specific prefix. 
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt
COPY . .

# STAGE 2: The Final Stage (Distroless)
# Using the Debian 12 version which supports Python 3.12
FROM gcr.io/distroless/python3-debian12
WORKDIR /app

# Copy the libraries from the builder stage
COPY --from=builder /install/lib/python3.12/site-packages /usr/lib/python3/dist-packages

# Copy your Django project code
COPY --from=builder /app /app

# Set environment variables
ENV PYTHONPATH=/usr/lib/python3/dist-packages
ENV PYTHONUNBUFFERED=1

EXPOSE 8000

# Exec form entrypoint
ENTRYPOINT ["python3", "manage.py", "runserver", "0.0.0.0:8000"]
