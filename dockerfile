FROM kalilinux/kali-rolling

# Manual configuration required
RUN echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" > /etc/apt/sources.list

# Install essential tools
RUN apt-get update && apt-get -y upgrade && apt-get install -y \
    python3 \
    python3-pip \
    nmap \
    exploitdb \
    git \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /app


COPY requirements.txt .
COPY scanner.py .

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Fix searchsploit path
RUN ln -s /usr/share/exploitdb/searchsploit /usr/local/bin/searchsploit && \
    searchsploit -u

    
ENTRYPOINT ["python3", "scanner.py"]
