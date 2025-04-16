import nmap
import logging
import subprocess
import re

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Function to perform aggressive scan and display open ports with version
def aggressive_scan(target):
    scanner = nmap.PortScanner()
    logging.info(f"Performing aggressive scan on {target}...")
    scanner.scan(target, arguments="-T4 -A -sV --version-intensity 9 --script=version -Pn")  # Improved detection
    
    results = {}
    for host in scanner.all_hosts():
        logging.info(f"Results for {host}:")
        for proto in scanner[host].all_protocols():
            ports = scanner[host][proto].keys()
            for port in ports:
                state = scanner[host][proto][port]['state']
                service = scanner[host][proto][port].get('name', 'unknown')
                version = scanner[host][proto][port].get('version', 'unknown')
                logging.info(f"Port {port} ({service}) - Version: {version} - State: {state}")
                if state == 'open':
                    results[port] = {"service": service, "version": version}
    
    return results

# Function to search for exploits using searchsploit
def search_exploits(service, version):
    try:
        search_query = f"{service} {version}" if version != 'unknown' else service
        result = subprocess.run(["searchsploit", search_query], capture_output=True, text=True)
        
        if result.stdout:
            logging.info(f"Exploits found for {service} {version}:\n{result.stdout}")
            return result.stdout
        else:
            logging.info(f"No known exploits found for {service} {version}")
            return "No known exploits found."
    except Exception as e:
        logging.error(f"Error using searchsploit for {service} {version}: {e}")
        return "Error retrieving exploits."

# Main function
def main():
    target = input("Enter target IP or domain: ")
    scan_results = aggressive_scan(target)
    
    if not scan_results:
        logging.info("No open ports found.")
        return
    
    selected_port = int(input(f"Select an open port from {list(scan_results.keys())} to list vulnerabilities: "))
    if selected_port not in scan_results:
        logging.error("Invalid port selection.")
        return
    
    service = scan_results[selected_port]['service']
    version = scan_results[selected_port]['version']
    exploits = search_exploits(service, version)
    
    report_content = f"Target: {target}\nPort: {selected_port}\nService: {service}\nVersion: {version}\n\nExploits:\n{exploits}"
    
    with open("scan_report.txt", "w") as f:
        f.write(report_content)
    logging.info("Scan completed! Report saved as scan_report.txt")

if __name__ == "__main__":
    main()
