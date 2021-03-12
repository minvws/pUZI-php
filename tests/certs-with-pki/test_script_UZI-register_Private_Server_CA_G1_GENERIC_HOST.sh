
export I_NAMESPACE="UZI-register_Private_Server_CA_G1_intermediate"
export NAMESPACE="UZI-register_Private_Server_CA_G1_GENERIC_HOST"

openssl genrsa -out ${NAMESPACE}.key 4096
openssl req -new \
    -key ${NAMESPACE}.key \
    -subj "/C=NL/O=GBIC/ST=Zuid Holland/L=Voorburg/CN=host.example.org" \
    -nodes \
    -set_serial 0x$(openssl rand -hex 16) \
    -out ${NAMESPACE}.csr  || exit 1

openssl req -noout -text -in ${NAMESPACE}.csr

export SUBJECT_ALT_NAME="host.example.org"
export CERTTYPE=${CERTTYPE:-servercertificaat}

# Run support script to create OpenSSL config
./test_script_support_create_config.sh


openssl x509 -req \
    -in ${NAMESPACE}.csr \
    -CA ${I_NAMESPACE}.pem \
    -CAkey ${I_NAMESPACE}.key \
    -CAcreateserial \
    -days 888 \
    -set_serial 0x$(openssl rand -hex 16) \
    -extensions uzi_main \
    -extfile ${NAMESPACE}.config \
    -out ${NAMESPACE}.pem || exit 1


openssl x509 -noout -text -in ${NAMESPACE}.pem

