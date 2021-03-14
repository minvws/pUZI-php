

### Avoid adding the hash-bang, as this file will be sourced

# Using a cut-down version of displaying a certificate, with sufficient info
# still in it.
display_certificate() {
    CERT_FILE="$1"

    echo "---- Display: ${CERT_FILE}"
    openssl x509 -noout -text \
        -certopt no_header,ext_dump,no_pubkey,no_sigdump \
        -in "${CERT_FILE}"
    echo "----"
}

# Sign a certificate
# Assuming all variables are available.
sign_certificate() {
    openssl x509 -req \
        -in "${NAMESPACE}.csr" \
        -CA "${I_NAMESPACE}.pem" \
        -CAkey "${I_NAMESPACE}.key" \
        -CAcreateserial \
        -days ${CERT_DAYS:-888} \
        -set_serial 0x$(openssl rand -hex 16) \
        -extensions "${EXTENSION_MAIN:-uzi_main}" \
        -extfile "${NAMESPACE}.config" \
        -out "${NAMESPACE}.pem" || exit 1
}
