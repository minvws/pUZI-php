#!/bin/sh

openssl req -x509 \
    -nodes \
    -keyout dummy.key \
    -out mock-001-no-valid-uzi-data.cert \
    -days 3650 \
    -subj "/C=NL/O=MockTest Cert/title=physician/SN=doe-12345678/GN=john/CN=john doe-12345678"

openssl req -x509 \
    -nodes \
    -keyout dummy.key \
    -out mock-002-invalid-san.cert \
    -days 3650 \
    -subj "/C=NL/O=MockTest Cert/title=physician/SN=doe-12345678/GN=john/CN=john doe-12345678" \
    -addext "subjectAltName = DNS:foo.bar"

openssl req -x509 \
    -nodes \
    -keyout dummy.key \
    -out mock-003-invalid-othername.cert \
    -days 3650 \
    -subj "/C=NL/O=MockTest Cert/title=physician/SN=doe-12345678/GN=john/CN=john doe-12345678" \
    -addext "subjectAltName = otherName:msUPN;UTF8:12345678@90000111"

openssl req -x509 \
    -nodes \
    -keyout dummy.key \
    -out mock-004-othername-without-ia5string.cert \
    -days 3650 \
    -subj "/C=NL/O=MockTest Cert/title=physician/SN=doe-12345678/GN=john/CN=john doe-12345678" \
    -addext "subjectAltName = otherName:2.5.5.5;UTF8:12345678@90000111"

openssl req -x509 \
    -nodes \
    -keyout dummy.key \
    -out mock-005-incorrect-san-data.cert \
    -days 3650 \
    -subj "/C=NL/O=MockTest Cert/title=physician/SN=doe-12345678/GN=john/CN=john doe-12345678" \
    -addext "subjectAltName = otherName:2.5.5.5;IA5STRING:12345678@90000111"

openssl req -x509 \
    -nodes \
    -keyout dummy.key \
    -out mock-006-incorrect-san-data.cert \
    -days 3650 \
    -subj "/C=NL/O=MockTest Cert/title=physician/SN=doe-12345678/GN=john/CN=john doe-12345678" \
    -addext "subjectAltName = otherName:2.5.5.5;IA5STRING:14-41-44"

openssl req -x509 \
    -nodes \
    -keyout dummy.key \
    -out mock-007-strict-ca-check.cert \
    -days 3650 \
    -subj "/C=NL/O=MockTest Cert/title=physician/SN=doe-12345678/GN=john/CN=john doe-12345678" \
    -addext "subjectAltName = otherName:2.5.5.5;IA5STRING:2.16.528.1.1003.1.3.5.5.1-1-12345678-Z-90000111-01.015-00000000"

openssl req -x509 \
    -nodes \
    -keyout dummy.key \
    -out mock-008-invalid-version.cert \
    -days 3650 \
    -subj "/C=NL/O=MockTest Cert/title=physician/SN=doe-12345678/GN=john/CN=john doe-12345678" \
    -addext "subjectAltName = otherName:2.5.5.5;IA5STRING:2.16.528.1.1003.1.3.5.5.2-2-12345678-Z-90000111-01.015-00000000"

openssl req -x509 \
    -nodes \
    -keyout dummy.key \
    -out mock-009-invalid-types.cert \
    -days 3650 \
    -subj "/C=NL/O=MockTest Cert/title=physician/SN=doe-12345678/GN=john/CN=john doe-12345678" \
    -addext "subjectAltName = otherName:2.5.5.5;IA5STRING:2.16.528.1.1003.1.3.5.5.2-1-12345678-K-90000111-01.015-00000000"

openssl req -x509 \
    -nodes \
    -keyout dummy.key \
    -out mock-010-invalid-roles.cert \
    -days 3650 \
    -subj "/C=NL/O=MockTest Cert/title=physician/SN=doe-12345678/GN=john/CN=john doe-12345678" \
    -addext "subjectAltName = otherName:2.5.5.5;IA5STRING:2.16.528.1.1003.1.3.5.5.2-1-12345678-N-90000111-00.015-00000000"

openssl req -x509 \
    -nodes \
    -keyout dummy.key \
    -out mock-011-correct.cert \
    -days 3650 \
    -subj "/C=NL/O=MockTest Cert/title=physician/SN=doe-12345678/GN=john/CN=john doe-12345678" \
    -addext "subjectAltName = otherName:2.5.5.5;IA5STRING:2.16.528.1.1003.1.3.5.5.2-1-12345678-N-90000111-30.015-00000000"

openssl req -x509 \
    -nodes \
    -keyout dummy.key \
    -out mock-012-correct-admin.cert \
    -days 3650 \
    -subj "/C=NL/O=MockTest Cert/title=physician/SN=doe-11111111/GN=john/CN=john doe-11111111" \
    -addext "subjectAltName = otherName:2.5.5.5;IA5STRING:2.16.528.1.1003.1.3.5.5.2-1-11111111-N-90000111-01.015-00000000"
