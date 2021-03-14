#!/bin/bash

source supporting_functions.sh

export CERTTYPE=${CERTTYPE:-vertrouwelijkheidcertificaat}

export TITLE="${TITLE:-physician}"
export SERIALNUMBER="${SERIALNUMBER:-1337}"
export GIVENNAME="${GIVENNAME:-Jan}"
export SURNAME="${SURNAME:-Zorg}"

export I_NAMESPACE="UZI-register_Zorgverlener_CA_G3_intermediate"
export NAMESPACE="UZI-register_Zorgverlener_CA_G3_GENERIC_USER_${PASSTYPE}_${CERTTYPE}_${SERIALNUMBER}_${TITLE}_${GIVENNAME}_${SURNAME}"


CERT_KEY_BITS="2048"
echo "Generate Private key with ${CERT_KEY_BITS}"
generate_private_key_file


SUBJECT="/C=NL/O=GBIC/serialNumber=${SERIALNUMBER}/title=${TITLE}/SN=${SURNAME}/GN=${GIVENNAME}/CN=${GIVENNAME} ${SURNAME}"
echo "CSR Generating..."
generate_csr_file


echo -n "CSR Generated: "
openssl req -noout -subject -in "${NAMESPACE}.csr"


# Run support script to create OpenSSL config
#./test_script_support_create_config.sh
create_openssl_config_UZI_EEC


# Assuming all variables are available
EXTENSION_MAIN="uzi_main"
CERT_DAYS=898
sign_certificate


display_certificate "${NAMESPACE}.pem"
