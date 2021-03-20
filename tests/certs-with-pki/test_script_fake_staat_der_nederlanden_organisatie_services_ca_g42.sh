#!/bin/bash

source supporting_functions.sh

export I_NAMESPACE="Fake_Staat_der_Nederlanden_Root_CA_G42"
export NAMESPACE="Fake_Staat_der_Nederlanden_Organisatie_Services_CA_G42"


CERT_KEY_BITS="4096"
echo "Generate Private key with ${CERT_KEY_BITS}"
generate_private_key_file


SUBJECT="/C=NL/O=Fake Staat der Nederlanden/CN=Fake Staat der Nederlanden Organisatie Services CA - G42"
echo "CSR Generating..."
generate_csr_file


echo -n "CSR Generated: "
openssl req -noout -subject -in "${NAMESPACE}.csr"



echo "Create config file for L2 CA - ${NAMESPACE}"
create_openssl_config_L2_CA


# Assuming all variables are available
CERT_DAYS=898
sign_certificate


display_certificate "${NAMESPACE}.pem"
