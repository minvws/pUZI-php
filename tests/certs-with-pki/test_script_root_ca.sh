
export I_NAMESPACE="Fake_Staat_der_Nederlanden_CA"
export NAMESPACE="Fake_Staat_der_Nederlanden_CA"

openssl genrsa -out ${NAMESPACE}.key 4096
openssl req -new \
    -key ${NAMESPACE}.key \
    -subj "/C=NL/O=Fake Staat der Nederlanden/CN=Fake Staat der Nederlanden Private Root CA - G42" \
    -nodes \
    -set_serial 0x$(openssl rand -hex 16) \
    -addext basicConstraints=critical,CA:TRUE \
    -addext keyUsage=critical,keyCertSign,cRLSign \
    -addext certificatePolicies=1.3.3.7 \
    -addext subjectKeyIdentifier=hash \
    -out ${NAMESPACE}.csr || exit 1

openssl req -noout -text -in ${NAMESPACE}.csr

openssl x509 \
    -signkey ${NAMESPACE}.key \
    -days 900 \
    -req \
    -in  ${NAMESPACE}.csr \
    -out ${NAMESPACE}.pem

openssl x509 -noout -text -in ${NAMESPACE}.pem
