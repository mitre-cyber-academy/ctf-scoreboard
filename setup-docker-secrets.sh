#!/bin/bash
if [ -f .env ]; then
	echo ".env already exists, if you would like to regenerate your secrets, please delete this file and re-run the script."
else
	echo ".env does not exist, creating..."
	(umask 066; touch .env)
	cat >.env - << EOF
POSTGRES_PASSWORD=$(openssl rand -hex 33)
EOF
fi

if [ -f .env-prod ]; then
	echo ".env-prod already exists, if you would like to regenerate your secrets, please delete this file and re-run the script."
else
	echo ".env-prod does not exist, creating..."
	cat >.env-prod - << EOF
SECRET_KEY_BASE=$(openssl rand -hex 64)
EOF
fi

if [ -f ./nginx/certs/ssl_certificate.crt ]; then
	echo "SSL Certificate already exists. if you would like to regenerate your secrets, please delete this file and re-run the script."
else
	echo "SSL Certificate does not exist, creating self-signed certificate..."
	echo "Do not use a self-signed certificate in a production environment."
	echo
	echo "Generating certificate (Expires in 7 days)..."
	openssl req -newkey rsa:4096 \
							-x509 \
							-sha256 \
							-days 7 \
							-nodes \
							-out nginx/certs/ssl_certificate.crt \
							-keyout nginx/certs/ssl_certificate_key.key
fi

echo "Done"
