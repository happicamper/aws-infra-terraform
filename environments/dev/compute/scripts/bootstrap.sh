#!/bin/bash

set -euxo pipefail

# ============================================================
# Configuration
# ============================================================

MAGNOLIA_VERSION="6.2.76"
MAGNOLIA_DIR="/opt/magnolia"

# Replace this with the actual Magnolia ZIP download URL.
MAGNOLIA_ZIP_URL="https://nexus.magnolia-cms.com/repository/public/info/magnolia/bundle/magnolia-community-demo-webapp/${MAGNOLIA_VERSION}/magnolia-community-demo-webapp-${MAGNOLIA_VERSION}-tomcat-bundle.zip"

# ============================================================
# System update
# ============================================================

dnf update -y

# ============================================================
# Install required packages
# ============================================================

dnf install -y \
  java-11-amazon-corretto \
  nginx \
  wget \
  unzip

# ============================================================
# Verify Java
# ============================================================

java -version

# ============================================================
# Download Magnolia
# ============================================================

mkdir -p /opt

wget -O /tmp/magnolia.zip "${MAGNOLIA_ZIP_URL}"

# ============================================================
# Extract Magnolia
# ============================================================

rm -rf "${MAGNOLIA_DIR}"

mkdir -p "${MAGNOLIA_DIR}"

unzip -q /tmp/magnolia.zip -d /opt/magnolia-temp

# Magnolia ZIP contains a directory such as:
#
# magnolia-x.y/
# ├── add-ons/
# └── apache-tomcat-x.y/
#
# Move the extracted contents into /opt/magnolia

MAGNOLIA_ROOT=$(find /opt/magnolia-temp -mindepth 1 -maxdepth 1 -type d | head -n 1)

mv "${MAGNOLIA_ROOT}"/* "${MAGNOLIA_DIR}/"

rm -rf /opt/magnolia-temp
rm -f /tmp/magnolia.zip

# ============================================================
# Find bundled Tomcat
# ============================================================

TOMCAT_DIR=$(find "${MAGNOLIA_DIR}" -maxdepth 1 -type d -name "apache-tomcat-*" | head -n 1)

if [ -z "${TOMCAT_DIR}" ]; then
  echo "ERROR: Bundled Tomcat was not found."
  exit 1
fi

echo "Magnolia directory: ${MAGNOLIA_DIR}"
echo "Tomcat directory: ${TOMCAT_DIR}"

# ============================================================
# Configure permissions
# ============================================================

useradd \
  --system \
  --home "${MAGNOLIA_DIR}" \
  --shell /sbin/nologin \
  magnolia || true

chown -R magnolia:magnolia "${MAGNOLIA_DIR}"

# ============================================================
# Create Magnolia systemd service
# ============================================================

cat > /etc/systemd/system/magnolia.service <<EOF
[Unit]
Description=Magnolia CMS
After=network.target

[Service]
Type=forking

User=magnolia
Group=magnolia

WorkingDirectory=${TOMCAT_DIR}

Environment="JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto"

ExecStart=${TOMCAT_DIR}/bin/magnolia_control.sh start --ignore-open-files-limit
ExecStop=${TOMCAT_DIR}/bin/magnolia_control.sh stop

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# ============================================================
# Start Magnolia
# ============================================================

chmod +x "${TOMCAT_DIR}/bin/magnolia_control.sh"

systemctl daemon-reload
systemctl enable magnolia
systemctl start magnolia

# ============================================================
# Configure Nginx
# ============================================================

cat > /etc/nginx/conf.d/magnolia.conf <<'EOF'
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:8080;

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 443 ssl;
    server_name _;

    ssl_certificate     /etc/nginx/ssl/magnolia.crt;
    ssl_certificate_key /etc/nginx/ssl/magnolia.key;

    location / {
        proxy_pass http://127.0.0.1:8080;

        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Remove default Nginx configuration if present
rm -f /etc/nginx/conf.d/default.conf

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/magnolia.key \
  -out /etc/nginx/ssl/magnolia.crt \
  -subj "/C=PH/ST=Pampanga/L=Magalang/O=Magnolia/CN=localhost"
  
nginx -t

systemctl enable nginx
systemctl restart nginx

# ============================================================
# Cleanup
# ============================================================

echo "Magnolia installation completed."
echo "Tomcat directory: ${TOMCAT_DIR}"
echo "Magnolia is listening on port 8080."
echo "Nginx is listening on port 80."