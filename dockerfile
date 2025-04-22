FROM kalilinux/kali-rolling

# Install system dependencies
RUN apt-get update && apt-get -y upgrade && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    nmap \
    exploitdb \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create and activate virtual environment
ENV VIRTUAL_ENV=/app/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install Python dependencies
WORKDIR /app
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Configure exploitdb
RUN ln -s /usr/share/exploitdb/searchsploit /usr/local/bin/searchsploit && \
    searchsploit -u

# Copy application files
COPY scanner.py .

# Entry point configuration
ENTRYPOINT ["python3", "scanner.py"]
