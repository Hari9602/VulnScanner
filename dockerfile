## Dockerfile for Python Vulnerability Scanner
FROM kalilinux/kali-rolling:latest

# Install essential tools and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    nmap \
    python3-nmap \
    exploit-db \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Update exploit database (consider runtime update for freshness)
RUN searchsploit --update

# Set working directory and copy code
WORKDIR /app
COPY scanner.py /app/

# Execution configuration
ENTRYPOINT ["python3", "-u", "scanner.py"]
