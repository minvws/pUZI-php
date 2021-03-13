#!/bin/bash


# Set a default to: authenticiteitcertificaat
CERTTYPE=${CERTTYPE:-vertrouwelijkheidcertificaat}


cat > "${NAMESPACE}.config" <<End-of-message
[uzi_main]
basicConstraints = critical,CA:FALSE
End-of-message

# In authenticiteitcertificaten is uitsluitend het digitalSignature bit
# opgenomen.
if [ "${CERTTYPE}" = "authenticiteitcertificaat" ]; then

cat >> "${NAMESPACE}.config" <<End-of-message
keyUsage = critical,digitalSignature
extendedKeyUsage = clientAuth, emailProtection, codeSigning
subjectAltName = otherName:2.5.5.5;IA5STRING:2.16.528.1.1003.1.3.5.5.2-1-11111111-N-90000111-01.015-00000000
End-of-message


# In vertrouwelijkheidcertificaten zijn uitsluitend de keyEncipherment en
# dataEncipherment bits opgenomen.
elif [ "${CERTTYPE}" = "vertrouwelijkheidcertificaat" ]; then

cat >> "${NAMESPACE}.config" <<End-of-message
keyUsage = critical,keyEncipherment,dataEncipherment
extendedKeyUsage = emailProtection, msEFS
subjectAltName = otherName:2.5.5.5;IA5STRING:2.16.528.1.1003.1.3.5.5.2-1-11111111-N-90000111-01.015-00000000
End-of-message


# In handtekeningcertificaten is uitsluitend het non-Repudiation bit op unieke
# wijze zijn opgenomen.
elif [ "${CERTTYPE}" = "handtekeningcertificaat" ]; then

cat >> "${NAMESPACE}.config" <<End-of-message
keyUsage = critical,nonRepudiation
extendedKeyUsage = emailProtection, codeSigning
subjectAltName = otherName:2.5.5.5;IA5STRING:2.16.528.1.1003.1.3.5.5.2-1-11111111-N-90000111-01.015-00000000
End-of-message

# In de servercertificaten (services) zijn uitsluitend de DigitalSignatureen
# KeyEncipherment bits opgenomen.
elif [ "${CERTTYPE}" = "servercertificaat" ]; then

cat >> "${NAMESPACE}.config" <<End-of-message
keyUsage = critical,digitalSignature,keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
subjectAltName = DNS:${SUBJECT_ALT_NAME}
End-of-message

fi


cat >> "${NAMESPACE}.config" <<End-of-message
certificatePolicies=1.3.3.7, 2.16.528.1.1003.1.2.8.4, 2.16.528.1.1003.1.2.8.5, @polselect

subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer


[polselect]
policyIdentifier = 2.16.528.1.1003.1.2.8.6
CPS.1=https://example.org
End-of-message


