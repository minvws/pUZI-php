#!/bin/bash

source supporting_functions.sh

I_NAMESPACE="Fake_Staat_der_Nederlanden_Organisatie_Persoon_CA"
NAMESPACE="UZI-register_Zorgverlener_CA_G3"


CERT_KEY_BITS="4096"
echo "Generate Private key with ${CERT_KEY_BITS}"
generate_private_key_file


SUBJECT="/C=NL/O=CIBG/organizationIdentifier=NTRNL-50000535/CN=UZI-register Zorgverlener CA G3"
echo "CSR Generating..."
generate_csr_file


echo -n "CSR Generated: "
openssl req -noout -subject -in "${NAMESPACE}.csr"


echo "Generate config file: ${NAMESPACE}.config"
create_openssl_config_L3_zorgmedewerker_CA


# Assuming all variables are available
CERT_DAYS=898
sign_certificate

display_certificate "${NAMESPACE}.pem"
