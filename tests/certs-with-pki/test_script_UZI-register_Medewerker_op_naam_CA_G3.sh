#!/bin/bash

source supporting_functions.sh

I_NAMESPACE="Fake_Staat_der_Nederlanden_Organisatie_Persoon_CA"
NAMESPACE="UZI-register_Medewerker_op_naam_CA_G3"


CERT_KEY_BITS="4096"
echo "Generate Private key with ${CERT_KEY_BITS}"
generate_private_key_file


SUBJECT="/C=NL/O=CIBG/organizationIdentifier=NTRNL-50000535/CN=UZI-register Medewerker op naam CA G3"
echo "CSR Generating..."
generate_csr_file


echo -n "CSR Generated: "
openssl req -noout -subject -in "${NAMESPACE}.csr"


echo "Generate config file ${NAMESPACE}.config"
create_openssl_config_L3_medewerker_op_naam_CA


# Assuming all variables are available
CERT_DAYS=888
sign_certificate

display_certificate "${NAMESPACE}.pem"


# Adding to bundle file
add_to_bundle_file "${GLOBAL_BUNDLE_FILENAME_FAKE_ROOT}" "${NAMESPACE}.pem"
