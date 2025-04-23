FROM kalilinux/kali-rolling:latest

# Update and upgrade system, install Python3 and pipx
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y python3 pipx && \
    pipx ensurepath && \
    pipx install python-nmap && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy your scanner script into the container
COPY scanner.py /app/

# Set entrypoint
ENTRYPOINT ["python3", "scanner.py"]
