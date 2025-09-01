FROM python:3.9-slim

# Set working directory inside container
WORKDIR /app

# Install dependencies first (faster builds if code changes)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Default command to run your app
CMD ["python", "app/main.py"]
