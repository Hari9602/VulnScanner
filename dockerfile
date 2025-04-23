FROM kalilinux/kali-rolling

# Update system and create virtual environment
RUN apt update && apt full-upgrade -y \
    && python3 -m venv /opt/venv \
    && /opt/venv/bin/python -m pip install --upgrade pip \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Set up exploitdb for searchsploit
RUN ln -s /usr/share/exploitdb/ /opt/exploit-database \
    && ln -sf /usr/bin/searchsploit /usr/local/bin/searchsploit

# Set virtual environment PATH
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY scanner.py .

ENTRYPOINT ["python3", "scanner.py"]
