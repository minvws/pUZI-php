#!/bin/bash

source supporting_functions.sh

export I_NAMESPACE="UZI-register_Medewerker_niet_op_naam_CA_G3_intermediate"
export NAMESPACE="UZI-register_Medewerker_niet_op_naam_CA_G3_GENERIC_USER_${CERTTYPE}"

openssl genrsa -out ${NAMESPACE}.key ${CERTKEYSIZE:-2048}
openssl req -new \
    -key ${NAMESPACE}.key \
    -subj "/C=NL/O=GBIC/OU=Random Department/serialNumber=1337/CN=${FUNCTION_NAME:-Zorg Medewerker}" \
    -nodes \
    -set_serial 0x$(openssl rand -hex 16) \
    -out ${NAMESPACE}.csr || exit 1

echo -n "CSR Generated: "
openssl req -noout -subject -in "${NAMESPACE}.csr"



export CERTTYPE=${CERTTYPE:-vertrouwelijkheidcertificaat}

# Run support script to create OpenSSL config
#./test_script_support_create_config.sh
create_openssl_config_UZI_EEC


# Assuming all variables are available
EXTENSION_MAIN="uzi_main"
CERT_DAYS=888
sign_certificate


display_certificate "${NAMESPACE}.pem"
