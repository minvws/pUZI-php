#!/bin/bash

source supporting_functions.sh

export I_NAMESPACE="Fake_Staat_der_Nederlanden_CA"
export NAMESPACE="Fake_Staat_der_Nederlanden_CA"

openssl genrsa -out ${NAMESPACE}.key 4096
openssl req -new \
    -key ${NAMESPACE}.key \
    -subj "/C=NL/O=Fake Staat der Nederlanden/CN=Fake Staat der Nederlanden Private Root CA - G42" \
    -nodes \
    -set_serial 0x$(openssl rand -hex 16) \
    -out ${NAMESPACE}.csr || exit 1

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
