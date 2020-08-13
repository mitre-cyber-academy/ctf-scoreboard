#!/bin/bash
if [ -f .env ]; then
	echo ".env already exists, if you would like to regenerate your secrets, please delete this file and re-run the script."
else
	echo ".env does not exist, creating..."
	(umask 066; touch .env)
	cat >.env - << EOF
POSTGRES_PASSWORD=$(openssl rand -hex 33)
SECRET_KEY_BASE=$(openssl rand -hex 64)
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
	echo "Generating certificate signing request..."
	sudo openssl req -new > temp.cert.csr
	echo "Generating signing key..."
	sudo openssl rsa -in privkey.pem -out new.cert.key
	echo "Generating certificate (Expires in 7 days)..."
	sudo openssl x509 -in temp.cert.csr -out new.cert.cert -req -signkey new.cert.key -days 7 # 7 Days so it isn't used in production
	echo "Moving files and cleaning up..."
	mv -f new.cert.cert nginx/certs/ssl_certificate.crt
	mv -f new.cert.key nginx/certs/ssl_certificate_key.key
	rm temp.cert.csr
fi

echo "Done"
