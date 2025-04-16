FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    nmap \
    exploitdb \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy files
COPY requirements.txt .
COPY scanner.py .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Add searchsploit to PATH (ensure it works)
RUN ln -s /usr/share/exploitdb/searchsploit /usr/local/bin/searchsploit

# Entry point
CMD ["python", "scanner.py"]
