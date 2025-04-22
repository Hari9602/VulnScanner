FROM kalilinux/kali-rolling

# Install core components
RUN apt update && apt full-upgrade -y && \
    apt install -y \
    nmap \
    exploitdb \
    git \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set up ExploitDB
RUN git clone https://gitlab.com/exploit-database/exploitdb.git /opt/exploit-database && \
    ln -sf /opt/exploit-database/searchsploit /usr/local/bin/searchsploit

WORKDIR /app

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY scanner.py .

# Update exploit database on container start
RUN chmod +x scanner.py
ENTRYPOINT ["/bin/sh", "-c", "searchsploit -u && python3 scanner.py"]
