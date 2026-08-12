# PoC internal CA

A deliberately minimal one-tier CA for the centralized-signing PoC: one
self-signed CA certificate that signs code-signing CSRs. No intermediate, no
CRL — production PKI hygiene is out of scope here.

All generated material (keys, certs, CSRs) lives in `ca/state/`, which is
gitignored. **Never commit anything from `state/`.**

## Flow

```bash
./setup-ca.sh                        # 1. create the CA (once)
# 2. in the signing service: generate a keypair, export a CSR
./issue-cert.sh <service.csr> poc    # 3. issue the code-signing cert
# 4. import ca/state/poc-chain.pem (or .p7b) back into the service
```

The issued cert carries `extendedKeyUsage = codeSigning` and
`keyUsage = digitalSignature` — both required for Windows to accept it as a
code-signing certificate.

To dry-run without the service, `./demo-csr.sh` generates a local keypair and
CSR that stand in for it.

## Making verification pass

Signatures chain up to `ca/state/ca.crt`. Verifiers only report "Valid" once
that root is trusted on the verifying machine:

- **Windows** (admin shell):
  `certutil -addstore -f Root ca.crt`
- **macOS**:
  `sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ca.crt`

Remove it after the PoC (`certutil -delstore Root "Codific PoC Signing CA"`).

## Timestamping

The CA does not give you a timestamp authority. When signing, point the tool
at a public RFC 3161 TSA (e.g. `signtool sign ... /tr http://timestamp.digicert.com /td sha256`);
that works fine together with a private signing cert.
