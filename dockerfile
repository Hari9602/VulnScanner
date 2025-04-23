## Dockerfile for Python Vulnerability Scanner (Fixed COPY Command)
FROM kalilinux/kali-rolling:latest

# Install essential tools with error handling
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
    nmap \
    python3-nmap \
    exploitdb \
    ca-certificates \
    apt-transport-https \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Initialize exploit database
RUN mkdir -p /usr/share/exploitdb && \
    searchsploit --update

# Configure workspace
WORKDIR /app

# Corrected COPY command (comment moved to separate line)
COPY scanner.py /app/

# Set entrypoint
ENTRYPOINT ["python3", "-u", "scanner.py"]
