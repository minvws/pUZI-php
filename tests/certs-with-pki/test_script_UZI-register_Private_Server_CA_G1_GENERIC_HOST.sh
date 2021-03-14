#!/bin/bash

source supporting_functions.sh

export I_NAMESPACE="UZI-register_Private_Server_CA_G1_intermediate"
export NAMESPACE="UZI-register_Private_Server_CA_G1_GENERIC_HOST_${CERTTYPE}"

export SUBJECT_ALT_NAME=${SUBJECT_ALT_NAME:-host.example.org}


CERT_KEY_BITS="2048"
echo "Generate Private key with ${CERT_KEY_BITS}"
generate_private_key_file


SUBJECT="/C=NL/O=GBIC/ST=Zuid Holland/L=Voorburg/CN=${SUBJECT_ALT_NAME}"
echo "CSR Generating..."
generate_csr_file


echo -n "CSR Generated: "
openssl req -noout -subject -in "${NAMESPACE}.csr"


export CERTTYPE=${CERTTYPE:-servercertificaat}

# Run support script to create OpenSSL config
#./test_script_support_create_config.sh
create_openssl_config_UZI_EEC


# Assuming all variables are available
EXTENSION_MAIN="uzi_main"
CERT_DAYS=888
sign_certificate


display_certificate "${NAMESPACE}.pem"
