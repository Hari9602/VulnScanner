FROM kalilinux/kali-rolling

# Update system and install core dependencies
RUN apt-get update && apt-get -y full-upgrade && apt-get install -y \
    python3 \
    python3-pip \
    nmap \
    exploitdb \
    git \
    python3-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Configure environment
WORKDIR /app

# Install Python modules directly
RUN pip3 install --no-cache-dir \
    python-nmap==0.7.1 \
    requests==2.31.0

# Configure exploitdb tools
RUN ln -s /usr/share/exploitdb/searchsploit /usr/local/bin/searchsploit && \
    searchsploit -u

# Copy application files
COPY scanner.py .

# Set entrypoint
ENTRYPOINT ["python3", "scanner.py"]
