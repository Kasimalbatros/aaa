# Use official Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements if any
# COPY requirements.txt .

# Install dependencies (if requirements.txt exists)
# RUN pip install -r requirements.txt

# Copy app code
COPY . .

# Expose port
EXPOSE 8000

# Run the Flask app
CMD ["python", "main.py"]
