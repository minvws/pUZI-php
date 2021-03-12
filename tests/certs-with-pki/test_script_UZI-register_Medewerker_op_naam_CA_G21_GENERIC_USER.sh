
export I_NAMESPACE="UZI-register_Medewerker_op_naam_CA_G21_intermediate"
export NAMESPACE="UZI-register_Medewerker_op_naam_CA_G21_GENERIC_USER"

openssl genrsa -out ${NAMESPACE}.key 4096
openssl req -new \
    -key ${NAMESPACE}.key \
    -subj "/C=NL/O=GBIC/serialNumber=1337/SN=${SURNAME:-Zorg}/GN=${GIVENNAME:-Jan}/CN=${GIVENNAME:-Jan} ${SURNAME:-Zorg}" \
    -nodes \
    -set_serial 0x$(openssl rand -hex 16) \
    -out ${NAMESPACE}.csr || exit 1

openssl req -noout -text -in ${NAMESPACE}.csr



export CERTTYPE=${CERTTYPE:-vertrouwelijkheidcertificaat}

# Run support script to create OpenSSL config
./test_script_support_create_config.sh



openssl x509 -req \
    -in ${NAMESPACE}.csr \
    -CA ${I_NAMESPACE}.pem \
    -CAkey ${I_NAMESPACE}.key \
    -CAcreateserial \
    -days 898 \
    -set_serial 0x$(openssl rand -hex 16) \
    -extensions uzi_main \
    -extfile ${NAMESPACE}.config \
    -out ${NAMESPACE}.pem || exit 1


openssl x509 -noout -text -in ${NAMESPACE}.pem
