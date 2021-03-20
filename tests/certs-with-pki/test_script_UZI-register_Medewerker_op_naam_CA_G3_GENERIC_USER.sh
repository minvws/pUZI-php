#!/bin/bash

source supporting_functions.sh

export I_NAMESPACE="UZI-register_Medewerker_op_naam_CA_G3"
export NAMESPACE="UZI-register_Medewerker_op_naam_CA_G3_GENERIC_USER_${CERTTYPE}"


CERT_KEY_BITS="2048"
echo "Generate Private key with ${CERT_KEY_BITS}"
generate_private_key_file


SUBJECT="/C=NL/O=${ORG:-CIBG}/serialNumber=${SERIAL:-1337}/SN=${SURNAME:-Zorg}/GN=${GIVENNAME:-Jan}/CN=${GIVENNAME:-Jan} ${SURNAME:-Zorg}"
echo "CSR Generating..."
generate_csr_file


echo -n "CSR Generated: "
openssl req -noout -subject -in "${NAMESPACE}.csr"



export CERTTYPE=${CERTTYPE:-vertrouwelijkheidcertificaat}

# Run support script to create OpenSSL config
#./test_script_support_create_config.sh
create_openssl_config_UZI_EEC



# Assuming all variables are available
CERT_DAYS=888
EXT_NAME="uzi_main"
sign_certificate


display_certificate "${NAMESPACE}.pem"
