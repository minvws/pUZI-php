

### Avoid adding a header, as this file will be sourced

display_certificate() {
    CERT_FILE="$1"

    echo "---- Display: ${CERT_FILE}"
    openssl x509 -noout -text \
        -certopt no_header,ext_dump,no_pubkey,no_sigdump \
        -in "${CERT_FILE}"
    echo "----"
}


