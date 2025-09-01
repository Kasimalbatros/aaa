FROM python:3.9-slim

# Set working directory inside container
WORKDIR /app

# Install dependencies first
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose Flask app port
EXPOSE 8000

# Run Flask app on 0.0.0.0:8000 so it's accessible outside container
CMD ["python", "app/main.py", "--host=0.0.0.0", "--port=8000"]
