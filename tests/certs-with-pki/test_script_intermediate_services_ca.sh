#!/bin/bash

source supporting_functions.sh

export I_NAMESPACE="Fake_Staat_der_Nederlanden_CA"
export NAMESPACE="private_services_ca_intermediate"


CERT_KEY_BITS="4096"
echo "Generate Private key with ${CERT_KEY_BITS}"
generate_private_key_file


SUBJECT="/C=NL/O=Fake Staat der Nederlanden/CN=Fake Staat der Nederlanden Private Services CA - G42"
echo "CSR Generating..."
generate_csr_file


echo -n "CSR Generated: "
openssl req -noout -subject -in "${NAMESPACE}.csr"


cat > ${NAMESPACE}.config <<End-of-message
[uzi_main]
basicConstraints = CA:TRUE
keyUsage = critical,keyCertSign,cRLSign
certificatePolicies=1.3.3.7,2.16.528.1.1003.1.2.8.4, 2.16.528.1.1003.1.2.8.5, @polselect

subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer

[polselect]
policyIdentifier = 2.16.528.1.1003.1.2.8.6
CPS.1=https://example.org
End-of-message



# Assuming all variables are available
EXTENSION_MAIN="uzi_main"
CERT_DAYS=898
sign_certificate


display_certificate "${NAMESPACE}.pem"
