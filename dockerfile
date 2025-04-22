FROM kalilinux/kali-rolling

# Update and install system dependencies
RUN apt-get update && apt-get -y upgrade && apt-get install -y \
    python3 \
    python3-pip \
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
RUN pip3 install --no-cache-dir -r requirements.txt

# Verify searchsploit installation and add to PATH if needed
RUN searchsploit -u && \
    chmod +x /usr/bin/searchsploit

# Entry point
ENTRYPOINT ["python3", "scanner.py"]
