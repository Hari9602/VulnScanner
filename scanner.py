import nmap
import logging
import subprocess
import argparse

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Argument parser
def parse_args():
    parser = argparse.ArgumentParser(description="Python-based Vulnerability Scanner with Nmap and SearchSploit")
    parser.add_argument("target", nargs="?", help="Target IP or domain to scan (optional if running interactively)")
    parser.add_argument("--port", type=int, help="Open port number to analyze for vulnerabilities (optional)")
    return parser.parse_args()

# Function to perform aggressive scan
def aggressive_scan(target):
    scanner = nmap.PortScanner()
    logging.info(f"Performing aggressive scan on {target}...")
    scanner.scan(target, arguments="-T4 -A -sV --version-intensity 9 --script=version -Pn")
    
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
    args = parse_args()

    # Fallback to interactive if args not passed
    target = args.target if args.target else input("Enter target IP or domain: ")

    scan_results = aggressive_scan(target)
    if not scan_results:
        logging.info("No open ports found.")
        return

    if args.port and args.port in scan_results:
        selected_port = args.port
    else:
        print(f"\nOpen Ports Detected: {list(scan_results.keys())}")
        while True:
            try:
                selected_port = int(input("Select a port to analyze for vulnerabilities: "))
                if selected_port not in scan_results:
                    logging.error("Selected port is not open. Try again.")
                else:
                    break
            except ValueError:
                logging.error("Invalid input. Please enter a valid port number.")

    service = scan_results[selected_port]['service']
    version = scan_results[selected_port]['version']
    exploits = search_exploits(service, version)

    report_content = (
        f"Target: {target}\n"
        f"Port: {selected_port}\n"
        f"Service: {service}\n"
        f"Version: {version}\n\n"
        f"Exploits:\n{exploits}"
    )

    with open("scan_report.txt", "w") as f:
        f.write(report_content)

    logging.info("Scan completed! Report saved as scan_report.txt")

if __name__ == "__main__":
    main()
