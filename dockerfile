## Dockerfile for Python Vulnerability Scanner (Updated Filename)
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
COPY scanner.py /app/  # Updated filename reference

# Set entrypoint
ENTRYPOINT ["python3", "-u", "scanner.py"]  # Updated filename reference
