#!/bin/bash

source supporting_functions.sh

export I_NAMESPACE="Fake_Staat_der_Nederlanden_Private_Services_CA_G42"
export NAMESPACE="UZI-register_Private_Server_CA_G1"


CERT_KEY_BITS="4096"
echo "Generate Private key with ${CERT_KEY_BITS}"
generate_private_key_file


SUBJECT="/C=NL/O=CIBG/organizationIdentifier=NTRNL-50000535/CN=UZI-register Private Server CA G1"
echo "CSR Generating..."
generate_csr_file


echo -n "CSR Generated: "
openssl req -noout -subject -in "${NAMESPACE}.csr"


echo "Generate config file ${NAMESPACE}.config"
cat > "${NAMESPACE}.config" <<End-of-message
[${NAMESPACE}]
basicConstraints = CA:TRUE,pathlen:0
keyUsage = critical,keyCertSign,cRLSign,digitalSignature
extendedKeyUsage = clientAuth, serverAuth
certificatePolicies=1.3.3.7, 2.16.528.1.1007.99.211, 2.16.528.1.1007.99.212, @pol_${NAMESPACE}

subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer

[pol_${NAMESPACE}]
policyIdentifier = 2.16.528.1.1007.99.213
CPS.1=https://acceptatie.zorgcsp.nl/cps/uzi-register.html
End-of-message


# Assuming all variables are available
CERT_DAYS=898
sign_certificate

display_certificate "${NAMESPACE}.pem"


# Adding to bundle file
add_to_bundle_file "${GLOBAL_BUNDLE_FILENAME_FAKE_PRIVATE_ROOT}" "${NAMESPACE}.pem"
