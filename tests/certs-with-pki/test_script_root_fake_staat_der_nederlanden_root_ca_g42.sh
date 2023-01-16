#!/bin/bash

source supporting_functions.sh

export I_NAMESPACE="Fake_Staat_der_Nederlanden_Root_CA_G42"
export NAMESPACE="Fake_Staat_der_Nederlanden_Root_CA_G42"


CERT_KEY_BITS="4096"
echo "Generate Private key with ${CERT_KEY_BITS}"
generate_private_key_file


SUBJECT="/C=NL/O=Fake Staat der Nederlanden/CN=Fake Staat der Nederlanden Root CA - G42"
echo "CSR Generating..."
generate_csr_file


echo -n "CSR Generated: "
openssl req -noout -subject -in "${NAMESPACE}.csr"


echo "Create config file for root CA - ${NAMESPACE}"
create_openssl_config_Root_CA


echo "Sign root CA - ${NAMESPACE}"
sign_root_certificate

display_certificate "${NAMESPACE}.pem"

# Adding to bundle file
add_to_bundle_file "${GLOBAL_BUNDLE_FILENAME_FAKE_ROOT}" "${NAMESPACE}.pem"
