

### Avoid adding the hash-bang, as this file will be sourced

### Using a cut-down version of displaying a certificate, with sufficient info
### still in it.
display_certificate() {

CERT_FILE="$1"

echo "---- Display: ${CERT_FILE}"
openssl x509 -noout -text \
    -certopt no_header,ext_dump,no_pubkey,no_sigdump \
    -in "${CERT_FILE}"
echo "----"
}


### Generate Private Key file
generate_private_key_file() {
openssl genrsa -out "${NAMESPACE}.key" ${CERT_KEY_BITS:-4096}
}


### Generate CSR file
generate_csr_file() {
openssl req -new \
    -key "${NAMESPACE}.key" \
    -subj "${SUBJECT}" \
    -nodes \
    -set_serial 0x$(openssl rand -hex 16) \
    -out "${NAMESPACE}.csr" || exit 1
}


### Sign a certificate
### Assuming all variables are available.
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


### Create OpenSSL configuration file. Especially the creation of the otherName
### value is covered
create_openssl_config_UZI_EEC() {

# Set a default to: authenticiteitcertificaat
CERTTYPE=${CERTTYPE:-vertrouwelijkheidcertificaat}

# Creating of the SubjectAltName:otherName
UZINUMBER="${UZINUMBER:-133731337}"
ABONNEENUMMER="${ABONNEENUMBER:-42424242}"

# Format for otherName Subject ID: "<versie-nr>-<UZI-nr>-<pastype>-<Abonnee-nr>-<rol>-<AGB-code>"
# IA5STRING is expected

OTHERNAME_SUBJECT_ID_VERSION="${SUBJECT_ID_VERSION:-1}"
OTHERNAME_SUBJECT_ID_UZINUMBER="${UZINUMBER:-133731337}"
# De volgende codering wordt toegepast:
#   ‘Z’ : Zorgverlenerpas
#   ‘N’ : Medewerkerpas op naam
#   ‘M’ : Medewerkerpas niet op naam
#   ‘S’ : Servercertificaten
OTHERNAME_SUBJECT_ID_PASSTYPE="${PASSTYPE:-Z}"
OTHERNAME_SUBJECT_ID_ABONNEENUMBER="${ABONNEENUMBER:-42424242}"

# ROL
# Afhankelijk van pastypen
# Voor zorgverlenerpassen
# <code beroepstitel>.<code specialisme> De <code beroepstitel>=2NUM
# De <code specialisme>=3NUM
# OF
# ‘00.000’
# Voor Medewerkerpas op naam, Medewerkerpas niet op naam en Servercertificaten
OTHERNAME_SUBJECT_ID_ROL_BEROEPSTITEL="${TITLE_CODE:-00}"
OTHERNAME_SUBJECT_ID_ROL_SPECIALISME="${SPECI_CODE:-000}"

# AGB-code of 00000000 als geen AGB-code is opgegeven.
OTHERNAME_SUBJECT_ID_AGB="00000000"

# UZI-register Zorgverlener CA: 2.16.528.1.1003.1.3.5.5.2
# UZI-register Medewerker op naam CA: 2.16.528.1.1003.1.3.5.5.3
# UZI-register Medewerker niet op naam CA: 2.16.528.1.1003.1.3.5.5.4
# UZI-register Server CA: 2.16.528.1.1003.1.3.5.5.5

case "${OTHERNAME_SUBJECT_ID_PASSTYPE}" in
    "Z")
        OTHERNAME_SUBJECT_ID_OID_CA="2.16.528.1.1003.1.3.5.5.2"
        ;;
    "N")
        OTHERNAME_SUBJECT_ID_OID_CA="2.16.528.1.1003.1.3.5.5.3"
        ;;
    "M")
        OTHERNAME_SUBJECT_ID_OID_CA="2.16.528.1.1003.1.3.5.5.4"
        ;;
    "S")
        OTHERNAME_SUBJECT_ID_OID_CA="2.16.528.1.1003.1.3.5.5.5"
        ;;
esac

# Assemble - Format for otherName Subject ID: "<versie-nr>-<UZI-nr>-<pastype>-<Abonnee-nr>-<rol>-<AGB-code>"
OTHERNAME_SUBJECT_ID="${OTHERNAME_SUBJECT_ID_VERSION}"

OTHERNAME_SUBJECT_ID+="-${OTHERNAME_SUBJECT_ID_UZINUMBER}"
OTHERNAME_SUBJECT_ID+="-${OTHERNAME_SUBJECT_ID_PASSTYPE}"
OTHERNAME_SUBJECT_ID+="-${OTHERNAME_SUBJECT_ID_ABONNEENUMBER}"

OTHERNAME_SUBJECT_ID+="-${OTHERNAME_SUBJECT_ID_ROL_BEROEPSTITEL}"
OTHERNAME_SUBJECT_ID+=".${OTHERNAME_SUBJECT_ID_ROL_SPECIALISME}"
OTHERNAME_SUBJECT_ID+="-${OTHERNAME_SUBJECT_ID_AGB}"


cat > "${NAMESPACE}.config" <<End-of-message
[polselect]
policyIdentifier = ${OTHERNAME_SUBJECT_ID_OID_CA}
CPS.1=https://example.org

[uzi_main]
basicConstraints = critical,CA:FALSE
certificatePolicies=1.3.3.7, @polselect

subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer

End-of-message

# In authenticiteitcertificaten is uitsluitend het digitalSignature bit
# opgenomen.
if [ "${CERTTYPE}" = "authenticiteitcertificaat" ]; then

cat >> "${NAMESPACE}.config" <<End-of-message
keyUsage = critical,digitalSignature

# TODO: In doubt if adding msSmartcardLogin is OK. It's not listed as needed in
# the CPS, but should be there as part of the Microsoft spec.
# backup line: extendedKeyUsage = clientAuth, emailProtection, codeSigning
extendedKeyUsage = clientAuth, emailProtection, codeSigning, msSmartcardLogin
subjectAltName = @alt_names

[alt_names]
# msUPN has OID: 1.3.6.1.4.1.311.20.2.3
otherName.1 = msUPN;UTF8:${UZINUMBER}@${ABONNEENUMMER}

# subjectAltName = otherName:2.5.5.5;IA5STRING:2.16.528.1.1003.1.3.5.5.2-1-11111111-N-90000111-01.015-00000000
otherName.2 = 2.5.5.5;IA5STRING:${OTHERNAME_SUBJECT_ID_OID_CA}-${OTHERNAME_SUBJECT_ID}

End-of-message


# In vertrouwelijkheidcertificaten zijn uitsluitend de keyEncipherment en
# dataEncipherment bits opgenomen.
elif [ "${CERTTYPE}" = "vertrouwelijkheidcertificaat" ]; then

cat >> "${NAMESPACE}.config" <<End-of-message
keyUsage = critical,keyEncipherment,dataEncipherment
extendedKeyUsage = emailProtection, msEFS
subjectAltName = @alt_names

[alt_names]
# subjectAltName = otherName:2.5.5.5;IA5STRING:2.16.528.1.1003.1.3.5.5.2-1-11111111-N-90000111-01.015-00000000
otherName = 2.5.5.5;IA5STRING:${OTHERNAME_SUBJECT_ID_OID_CA}-${OTHERNAME_SUBJECT_ID}
End-of-message


# In handtekeningcertificaten is uitsluitend het non-Repudiation bit op unieke
# wijze zijn opgenomen.
elif [ "${CERTTYPE}" = "handtekeningcertificaat" ]; then

cat >> "${NAMESPACE}.config" <<End-of-message
keyUsage = critical,nonRepudiation
extendedKeyUsage = emailProtection, codeSigning
subjectAltName = @alt_names

[alt_names]
# subjectAltName = otherName:2.5.5.5;IA5STRING:2.16.528.1.1003.1.3.5.5.2-1-11111111-N-90000111-01.015-00000000
otherName = 2.5.5.5;IA5STRING:${OTHERNAME_SUBJECT_ID_OID_CA}-${OTHERNAME_SUBJECT_ID}
End-of-message

# In de servercertificaten (services) zijn uitsluitend de DigitalSignatureen
# KeyEncipherment bits opgenomen.
elif [ "${CERTTYPE}" = "servercertificaat" ]; then

cat >> "${NAMESPACE}.config" <<End-of-message
keyUsage = critical,digitalSignature,keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
subjectAltName = @alt_names

[alt_names]
DNS = ${SUBJECT_ALT_NAME}
# subjectAltName = otherName:2.5.5.5;IA5STRING:2.16.528.1.1003.1.3.5.5.2-1-11111111-N-90000111-01.015-00000000
# otherName = 2.5.5.5;IA5STRING:${OTHERNAME_SUBJECT_ID_OID_CA}-${OTHERNAME_SUBJECT_ID}
End-of-message

fi

}
