#!/bin/bash

# Set your MaxMind license key
LICENSE_KEY=${LICENSE_KEY:-'XXXXXXXXXXXXXX'}
# Directory to store downloaded files
DOWNLOAD_DIR=${DOWNLOAD_DIR:-''}
# Get the current date
CURRENT_DATE=$(date +"%d-%m-%Y")

# URLs for MaxMind GeoLite2 databases
CITY_URL="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City&license_key=$LICENSE_KEY&suffix=tar.gz"
ASN_URL="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-ASN&license_key=$LICENSE_KEY&suffix=tar.gz"
COUNTRY_URL="https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&license_key=$LICENSE_KEY&suffix=tar.gz"

# Filenames for downloaded files
CITY_FILE="GeoLite2-City.tar.gz"
ASN_FILE="GeoLite2-ASN.tar.gz"
COUNTRY_FILE="GeoLite2-Country.tar.gz"

# Function to download files
download() {
    local url="$1"
    local file="$2"

    # Download the file
    curl -o "$file" -L "$url"
}

# Download GeoLite2 City database if update available
echo "Downloading GeoLite2 City database..."
download "$CITY_URL" "$DOWNLOAD_DIR/$CITY_FILE"

# Download GeoLite2 ASN database if update available
echo "Downloading GeoLite2 ASN database..."
download "$ASN_URL" "$DOWNLOAD_DIR/$ASN_FILE"

# Download GeoLite2 Country database if update available
echo "Downloading GeoLite2 Country database..."
download "$COUNTRY_URL" "$DOWNLOAD_DIR/$COUNTRY_FILE"

echo "MaxMind data update complete."

git add .
git commit -m "GeoIP Update $CURRENT_DATE"
git push
