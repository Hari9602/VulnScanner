FROM kalilinux/kali-rolling

# Install system packages
RUN apt-get update && apt-get -y full-upgrade && apt-get install -y \
    python3 \
    python3-pip \
    nmap \
    exploitdb \
    git \
    && rm -rf /var/lib/apt/lists/*

# Configure exploitdb properly
RUN searchsploit -u  # Updates database without symlink creation

# Set working directory
WORKDIR /app

# Copy application files
COPY requirements.txt .
COPY scanner.py .

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Entry point
ENTRYPOINT ["python3", "scanner.py"]
