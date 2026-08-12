#!/usr/bin/env bash
# Creates the PoC CA: one EC P-256 key and a self-signed CA certificate.
# Everything lands in ca/state/ (gitignored — never commit the key).
set -euo pipefail
cd "$(dirname "$0")"

if [ -f state/ca.key ]; then
    echo "CA already exists (state/ca.key). Delete ca/state/ to start over." >&2
    exit 1
fi
mkdir -p state

openssl ecparam -name prime256v1 -genkey -noout -out state/ca.key
chmod 600 state/ca.key
openssl req -x509 -new -key state/ca.key -sha256 -days 730 \
    -out state/ca.crt -config ca.cnf -extensions v3_ca

echo "CA created:"
openssl x509 -in state/ca.crt -noout -subject -dates
echo
echo "Root certificate to distribute to verifying machines: ca/state/ca.crt"
