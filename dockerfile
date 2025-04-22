FROM kalilinux/kali-rolling

# Install system dependencies
RUN apt-get update && apt-get -y full-upgrade && apt-get install -y \
    python3 \
    python3-pip \
    nmap \
    git \
    && rm -rf /var/lib/apt/lists/*

# Configure Git and install exploitdb
RUN git config --global init.defaultBranch main && \
    git config --global advice.detachedHead false && \
    git clone https://github.com/offensive-security/exploitdb.git /opt/exploitdb && \
    ln -sf /opt/exploitdb/searchsploit /usr/local/bin/searchsploit

# Update exploitdb database
RUN searchsploit -u

# Copy application files
WORKDIR /app
COPY requirements.txt .
COPY scanner.py .

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "scanner.py"]
