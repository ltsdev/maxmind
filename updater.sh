#!/bin/bash
# Generate an error if any variable doesn't exist
set -o nounset

# Set your MaxMind license key
LICENSE_KEY=${LICENSE_KEY:-'XXXXXXXXXXXXXX'}
# Directory to store downloaded files
DOWNLOAD_DIR=${DOWNLOAD_DIR:-'.'}
# Get the current date
CURRENT_DATE=$(date +"%d-%m-%Y")

# Declare the databases name
DATABASES=('City' 'ASN' 'Country')

# Function to download files
download() {
    local url="$1"
    local file="$2"

    # Download the file
   	if curl -o "$file" -L --fail "$url"; then
        echo "Downloaded $file successfully."
    else
        echo "Failed to download $file from $url. Exiting..."
        exit 1
    fi
}

# Loop through databases and download files
for db in "${DATABASES[@]}"; do
    url="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-$db&license_key=$LICENSE_KEY&suffix=tar.gz"
    filename="GeoLite2-$db.tar.gz"
    
    echo "Downloading GeoLite2 $db database..."
    echo db
    download "$url" "$DOWNLOAD_DIR/$filename"
done

echo "MaxMind data update complete."

git add .
git commit -m "GeoIP Update $CURRENT_DATE"
git push
