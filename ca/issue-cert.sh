#!/usr/bin/env bash
# Signs a CSR (e.g. exported from the signing service) into a code-signing
# certificate. Produces the leaf cert plus chain bundles for import.
set -euo pipefail
cd "$(dirname "$0")"

if [ $# -lt 1 ]; then
    echo "usage: $0 <csr-file> [output-basename]" >&2
    exit 1
fi
CSR=$1
NAME=${2:-signing-cert}

if [ ! -f state/ca.key ]; then
    echo "No CA yet — run ./setup-ca.sh first." >&2
    exit 1
fi
if [ ! -f "$CSR" ]; then
    echo "CSR not found: $CSR" >&2
    exit 1
fi

openssl x509 -req -in "$CSR" -CA state/ca.crt -CAkey state/ca.key \
    -CAcreateserial -sha256 -days 365 \
    -out "state/$NAME.crt" -extfile leaf.cnf -extensions v3_codesign

# Chain bundles: PEM (leaf + root) and PKCS#7 (what Windows tooling likes)
cat "state/$NAME.crt" state/ca.crt > "state/$NAME-chain.pem"
openssl crl2pkcs7 -nocrl -certfile "state/$NAME-chain.pem" \
    -out "state/$NAME-chain.p7b"

echo "Issued:"
openssl x509 -in "state/$NAME.crt" -noout -subject -issuer -dates
openssl x509 -in "state/$NAME.crt" -noout -text | grep -A1 "Extended Key Usage"
echo
echo "Import into the signing service:"
echo "  leaf only:   ca/state/$NAME.crt"
echo "  full chain:  ca/state/$NAME-chain.pem  (or $NAME-chain.p7b)"
