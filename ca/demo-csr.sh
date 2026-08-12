#!/usr/bin/env bash
# Simulates the signing service side: generates a keypair and a CSR.
# Useful for dry-running issue-cert.sh before the real service is wired up.
set -euo pipefail
cd "$(dirname "$0")"
mkdir -p state

openssl ecparam -name prime256v1 -genkey -noout -out state/demo.key
chmod 600 state/demo.key
openssl req -new -key state/demo.key -sha256 -out state/demo.csr \
    -subj "/CN=Codific PoC Code Signing/O=Codific"

echo "Demo CSR written to ca/state/demo.csr — issue a cert with:"
echo "  ./issue-cert.sh state/demo.csr demo"
