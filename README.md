# shodan-domain-scanner
A Bash script for scanning domains using Shodan, extracting IP addresses, and saving the results in a user-friendly HTML report.

## Overview
This script automates the process of querying domains on Shodan, extracting IP addresses, and formatting the results into a visually appealing HTML report. It's useful for security researchers or administrators looking to gather IP information about specific domains.

## Features
- Query single or multiple domains.
- Fetch data from Shodan for the given domains.
- Generate a styled HTML report with extracted IP addresses.
- Supports command-line options for flexibility.
- Includes developer and usage information.

## Requirements
- Bash
- `curl`
- Internet connection

## Usage
```bash
./shodan-domain-scanner.sh [options] <domain>
```
```bash 
-h : Show the help message.
-f <domains> : Scan multiple domains (comma-separated).
-o <output_file> : Specify the output file name.
-d <domain> : Domain to scan.
--developer : Display developer information.
```

## Examples
<ul>
  <li>
    Scan a single domain and save to the default result.html:
    ```bash
    ./shodan-domain-scanner.sh -d example.com
    ```
  </li>
  <li>
    Scan multiple domains:
    ```bash
    ./shodan-domain-scanner.sh -f "example.com,test.com"
    ```
  </li>
  <li>
    Customize output file:
    ```bash
    ./shodan-domain-scanner.sh -d example.com -o output.html
    ```
  </li>
</ul>

## Download 
```bash
git clone https://github.com/Dit-Developers/shodan-domain-scanner
cd shodan-domain-scanner
sudo su
chmod +x shodan-domain-scanner.sh
bash shodan-domain-scanner.sh
```

## Developer
<ul>
  Developer Information <br>
  Name: Muhammad Sudai Usmani  <br>
  Email: msusuport@gmail.com  <br>
  LinkedIn : <a href="https://www.linkedin.com/in/muhammad-sudais-usmani-950889311/">Muhammad Sudais Usmani </a> <br>
  Youtube : <a href="https://www.youtube.com/@cyberninja78">Youtube Channel</a>
  GitHub: <a href="https://github.com/Dit-Developers">Dit-Developer</a>  <br>
  Portfolio: <a href="https://msu-portfolio.vercel.app">MSU Portfolio</a> <br>
</ul>

