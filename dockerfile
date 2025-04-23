FROM kalilinux/kali-rolling

# Update system and install Python dependencies
RUN apt update && apt full-upgrade -y \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Set up exploitdb for searchsploit
RUN ln -s /usr/share/exploitdb/ /opt/exploit-database \
    && ln -sf /usr/bin/searchsploit /usr/local/bin/searchsploit

WORKDIR /app
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY scanner.py .

ENTRYPOINT ["python3", "scanner.py"]
