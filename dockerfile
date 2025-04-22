FROM kalilinux/kali-rolling

# Install system dependencies
RUN apt-get update && apt-get -y full-upgrade && apt-get install -y \
    python3 \
    python3-nmap \
    nmap \
    exploitdb \
    git \
    && rm -rf /var/lib/apt/lists/*

# Configure exploitdb
RUN ln -s /usr/share/exploitdb/searchsploit /usr/local/bin/searchsploit && \
    searchsploit -u

# Install Python requirements
WORKDIR /app
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy application files
COPY scanner.py .

# Entry point
ENTRYPOINT ["python3", "scanner.py"]
