## Revised Dockerfile with Searchsploit Fix
FROM kalilinux/kali-rolling:latest

# Install essential tools
RUN apt-get update --fix-missing && \
    apt-get install -y --no-install-recommends \
    nmap \
    python3-nmap \
    exploitdb \
    ca-certificates \
    apt-transport-https \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Initialize exploit database with error handling
RUN mkdir -p /usr/share/exploitdb && \
    git config --global init.defaultBranch main && \
    searchsploit --update || [ $? -eq 6 ]  # Allow exit code 6 (successful update)

# Configure workspace
WORKDIR /app
COPY scanner.py /app/

# Set entrypoint
ENTRYPOINT ["python3", "-u", "scanner.py"]
