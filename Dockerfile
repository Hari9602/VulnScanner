FROM kalilinux/kali-rolling:latest

# Install core dependencies
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
    python3 \
    pipx \
    nmap \
    python3-nmap \
    exploitdb \
    ca-certificates \
    apt-transport-https \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure pipx and python-nmap
RUN pipx ensurepath && \
    pipx install python-nmap

# Initialize exploit database
RUN mkdir -p /usr/share/exploitdb && \
    searchsploit --update || [ $? -eq 6 ]

# Set working directory and copy code
WORKDIR /app
COPY scanner.py /app/

# Entrypoint configuration
ENTRYPOINT ["python3", "-u", "scanner.py"]
