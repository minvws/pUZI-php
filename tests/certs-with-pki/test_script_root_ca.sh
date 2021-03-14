#!/bin/bash

source supporting_functions.sh

export I_NAMESPACE="Fake_Staat_der_Nederlanden_CA"
export NAMESPACE="Fake_Staat_der_Nederlanden_CA"


CERT_KEY_BITS="4096"
echo "Generate Private key with ${CERT_KEY_BITS}"
generate_private_key_file


SUBJECT="/C=NL/O=Fake Staat der Nederlanden/CN=Fake Staat der Nederlanden Private Root CA - G42"
echo "CSR Generating..."
generate_csr_file


echo -n "CSR Generated: "
openssl req -noout -subject -in "${NAMESPACE}.csr"


cat > ${NAMESPACE}.config <<End-of-message
[v3_root]
basicConstraints = CA:TRUE
keyUsage = critical,keyCertSign,cRLSign
certificatePolicies=1.3.3.7

subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid:always,issuer
End-of-message


openssl x509 \
    -signkey "${NAMESPACE}.key" \
    -days 900 \
    -req \
    -in  ${NAMESPACE}.csr \
    -extensions v3_root \
    -extfile "${NAMESPACE}.config" \
    -out "${NAMESPACE}.pem"


display_certificate "${NAMESPACE}.pem"
