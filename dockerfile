FROM kalilinux/kali-rolling

# Install system dependencies
RUN apt-get update && apt-get -y full-upgrade && apt-get install -y \
    python3 \
    python3-pip \
    nmap \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install exploitdb from source (GitHub)
RUN git clone https://github.com/offensive-security/exploitdb.git /opt/exploitdb && \
    ln -sf /opt/exploitdb/searchsploit /usr/local/bin/searchsploit && \
    cp -n /opt/exploitdb/.searchsploit_rc ~/

# Configure Git before updating
RUN git config --global init.defaultBranch main && \
    git -C /opt/exploitdb config core.filemode false

# Update exploitdb
RUN searchsploit -u

# Copy application files
WORKDIR /app
COPY requirements.txt .
COPY scanner.py .

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "scanner.py"]
