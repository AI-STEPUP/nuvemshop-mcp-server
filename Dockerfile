# Dockerfile for Tiendanube MCP Server
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY requirements.txt .

# declarar as variáveis de ambiente baseadas no arquivo .env
ENV TIENDANUBE_STORE_ID="your_store_id_here"
ENV TIENDANUBE_ACCESS_TOKEN="your_access_token_here"

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8080/health', timeout=2)" || exit 1

CMD ["sh", "start.sh"]