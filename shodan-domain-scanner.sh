#!/bin/bash
echo "This tool for Linux Only :)"
cls 

# Default values
DOMAIN_INPUT=""
OUTPUT_FILE="result.html"
DOMAINS=()

# Function to display help
function show_help() {
    echo "Usage: $0 [options] <domain>"
    echo "Options:"
    echo "  -h                Show this help message"
    echo "  -f <domains>      Scan multiple domains (comma-separated)"
    echo "  -o <output_file>  Specify the output file name"
    echo "  --developer       Show information about the developer"
    echo "  -d <domain>       Domain to scan"
}

# Function to display developer information
function show_developer_info() {
    echo "Developer: Muhammad Sudai Usmani"
    echo "Contact: msusuport@gmail.com"
    echo "GitHub: https://github.com/Dit-Developer"
    echo "Portfolio : https://msu-portfolio.vercel.app"
}

# Function to escape special characters for HTML
function escape_html() {
    echo "$1" | sed 's/[&]/\\&/g; s/[<]/\\</g; s/[>]/\\>/g'
}

# Parse command-line arguments
while [[ "$1" =~ ^- ]]; do
    case "$1" in
        -h)
            show_help
            exit 0
            ;;
        -f)
            shift
            DOMAIN_INPUT=$1
            IFS=',' read -r -a DOMAINS <<< "$DOMAIN_INPUT"
            shift
            ;;
        -o)
            shift
            OUTPUT_FILE=$1
            shift
            ;;
        --developer)
            show_developer_info
            exit 0
            ;;
        -d)
            shift
            DOMAIN_INPUT=$1
            DOMAINS=("$DOMAIN_INPUT")  # Set single domain to the array
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Check if a domain is provided
if [ ${#DOMAINS[@]} -eq 0 ]; then
    echo "Usage: $0 <option> <domain> or -h for help"
    exit 1
fi

# Check if the output file is writable
if [ ! -w "$OUTPUT_FILE" ] && [ -e "$OUTPUT_FILE" ]; then
    echo "Error: Cannot write to $OUTPUT_FILE."
    exit 1
fi

# Debugging: Check what domains and output file are being used
echo "Scanning domains: ${DOMAINS[*]}"
echo "Output file will be: $OUTPUT_FILE"

# Loop through the domains if multiple domains are provided
for DOMAIN in "${DOMAINS[@]}"; do
    DOMAIN_ESCAPED=$(escape_html "$DOMAIN")
    URL="https://www.shodan.io/search/facet?query=${DOMAIN_ESCAPED}&facet=ip"

    # Use curl to scrape the data
    echo "Fetching data from Shodan for $DOMAIN..."
    curl -f -s "$URL" -o shodan_page.html

    # Check if the page was successfully fetched
    if [ $? -ne 0 ]; then
        echo "Error: Failed to fetch the Shodan page for $DOMAIN."
        continue
    fi

    # Check if the page is empty
    if [ ! -s "shodan_page.html" ]; then
        echo "Error: The fetched Shodan page is empty for $DOMAIN."
        continue
    fi

    echo "Fetched page for $DOMAIN successfully."

    # Extract IP addresses (just an example, you may need to adjust it based on the actual HTML structure)
    IP_ADDRESSES=$(grep -oP '([0-9]{1,3}\.){3}[0-9]{1,3}' shodan_page.html)

    # Check if IPs are extracted
    if [ -z "$IP_ADDRESSES" ]; then
        echo "No IP addresses found for $DOMAIN."
        continue
    fi

    echo "Writing results to $OUTPUT_FILE"

    # Create or append to the HTML file
    if [ ! -f "$OUTPUT_FILE" ]; then
        cat <<EOF > $OUTPUT_FILE
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shodan Search Results for ${DOMAIN}</title>
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Arial', sans-serif;
        }
        .table {
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .table thead {
            background-color: #007bff;
            color: white;
        }
        .table td, .table th {
            vertical-align: middle;
            padding: 15px;
        }
        .table-striped tbody tr:nth-of-type(odd) {
            background-color: #f2f2f2;
        }
        .container {
            max-width: 1200px;
        }
        h1 {
            color: #007bff;
            font-size: 2rem;
            font-weight: bold;
        }
        .table-responsive {
            overflow-x: auto;
        }
    </style>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KyZXEJ9vMRYUryD1Lsd+6K2w75EOKzZn6yo3RFWrFzx6p1y9aaIlkXKM5bZr9syP" crossorigin="anonymous">
</head>
<body>
    <div class="container my-5">
        <h1 class="text-center mb-4">Shodan Search Results for "${DOMAIN}"</h1>
        <div class="table-responsive">
            <table class="table table-striped">
                <thead class="thead-dark">
                    <tr>
                        <th scope="col">IP Address</th>
                    </tr>
                </thead>
                <tbody>
EOF
    fi

    # Loop through the extracted IP addresses and add them to the table
    for ip in $IP_ADDRESSES; do
        echo "                <tr><td scope="row">${ip}</td></tr>" >> $OUTPUT_FILE
    done

    cat <<EOF >> $OUTPUT_FILE
                </tbody>
            </table>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-pzjw8f+ua7Kw1TIq0mTPT8p9yUGFb4M2nKn6Q0w5Fz2xUmtZ02fRRz7qKnHR1s5a" crossorigin="anonymous"></script>
</body>
</html>
EOF

    # Notify the user that the HTML file has been created
    echo "HTML file with Shodan data saved as $OUTPUT_FILE."
done
