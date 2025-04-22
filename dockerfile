FROM kalilinux/kali-rolling

# Install system dependencies
RUN apt-get update && apt-get -y full-upgrade && apt-get install -y \
    python3 \
    python3-pip \
    nmap \
    exploitdb \
    git \
    wget \
    tar \
    python3-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Download and install python-nmap from source
RUN wget https://xael.org/norman/python/python-nmap/python-nmap-0.7.1.tar.gz && \
    tar xzf python-nmap-0.7.1.tar.gz && \
    cd python-nmap-0.7.1 && \
    python3 setup.py install

# Install remaining Python requirements
RUN pip3 install --no-cache-dir requests==2.31.0

# Configure exploitdb
RUN ln -s /usr/share/exploitdb/searchsploit /usr/local/bin/searchsploit && \
    searchsploit -u

# Copy application files
WORKDIR /app
COPY scanner.py .

ENTRYPOINT ["python3", "scanner.py"]
