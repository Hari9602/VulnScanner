FROM kalilinux/kali-rolling

# Install essential system packages
RUN apt-get update && apt-get -y upgrade && apt-get install -y \
    python3 \
    python3-pip \
    pipx \
    nmap \
    exploitdb \
    git \
    python3-dev \
    build-essential \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Configure pipx environment
ENV PATH="/root/.local/bin:${PATH}"
RUN pipx ensurepath && \
    pipx upgrade-all  # Critical update step

# Install Python dependencies using pipx
WORKDIR /app
COPY requirements.txt .
RUN pipx install --system-site-packages -r requirements.txt

# Configure exploitdb
RUN ln -s /usr/share/exploitdb/searchsploit /usr/local/bin/searchsploit && \
    searchsploit -u

# Copy application files
COPY scanner.py .

# Entry point configuration
ENTRYPOINT ["python3", "scanner.py"]
