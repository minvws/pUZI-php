#!/bin/bash

source supporting_functions.sh

export I_NAMESPACE="Fake_Staat_der_Nederlanden_Organisatie_Services_CA_G42"
export NAMESPACE="UZI-register_Medewerker_niet_op_naam_CA_G3"


CERT_KEY_BITS="4096"
echo "Generate Private key with ${CERT_KEY_BITS}"
generate_private_key_file


SUBJECT="/C=NL/O=CIBG/organizationIdentifier=NTRNL-50000535/CN=UZI-register Medewerker niet op naam CA G3"
echo "CSR Generating..."
generate_csr_file


echo -n "CSR Generated: "
openssl req -noout -subject -in "${NAMESPACE}.csr"


echo "Generate ${NAMESPACE}.config"
create_openssl_config_L3_medewerker_niet_op_naam_CA


# Assuming all variables are available
CERT_DAYS=898
sign_certificate


display_certificate "${NAMESPACE}.pem"
