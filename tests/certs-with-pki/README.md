# Fake UZI PKI
Start generation with ./generate-mock-certs-with-pki.sh


## Main generator script for the PKI.
`./generate-mock-certs-with-pki.sh`  

## Level 0 - Root CA - Fake Staat der Nederlanden CA
`./test_script_root_ca.sh`  

## Level 1 - Intermediate CA - Fake Staat der Nederlanden Private Services CA - G42
`./test_script_intermediate_services_ca.sh`  


## Level 2 - Intermediate CA - UZI-register Private Server CA G1
`./test_script_UZI-register_Private_Server_CA_G1.sh`  


## Level 2 - Intermediate CA - UZI-register Medewerker niet op naam CA G21
`./test_script_UZI-register_Medewerker_niet_op_naam_CA_G21.sh`  

## Level 2 - Intermediate CA - UZI-register Medewerker niet op naam CA G3
`./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3.sh`  

## Level 2 - Intermediate CA - UZI-register Medewerker op naam CA G21
`./test_script_UZI-register_Medewerker_op_naam_CA_G21.sh`  

## Level 2 - Intermediate CA - UZI-register Medewerker op naam CA G3
`./test_script_UZI-register_Medewerker_op_naam_CA_G3.sh`  

## Level 2 - Intermediate CA - UZI-register Zorgverlener CA G21
`./test_script_UZI-register_Zorgverlener_CA_G21.sh`  

## Level 2 - Intermediate CA - UZI-register Zorgverlener CA G3
`./test_script_UZI-register_Zorgverlener_CA_G3.sh`  


## Level 3 - End Entity Certificate - Medewerker niet op naam G21
CERTTYPE Options: authenticiteitcertificaat, vertrouwelijkheidcertificaat, handtekeningcertificaat  
`FUNCTION_NAME="Zorg Medewerker"`  
`CERTTYPE="vertrouwelijkheidcertificaat"`  
`./test_script_UZI-register_Medewerker_niet_op_naam_CA_G21_GENERIC_USER.sh`  

## Level 3 - End Entity Certificate - Medewerker niet op naam G3
CERTTYPE Options: authenticiteitcertificaat, vertrouwelijkheidcertificaat, handtekeningcertificaat  
`FUNCTION_NAME="Zorg Medewerker"`  
`CERTTYPE="vertrouwelijkheidcertificaat"`  
`./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3_GENERIC_USER.sh`  

## Level 3 - End Entity Certificate - Medewerker op naam G21
CERTTYPE Options: authenticiteitcertificaat, vertrouwelijkheidcertificaat, handtekeningcertificaat  
`SURNAME="Zorg"`  
`GIVENNAME="Jan"`  
`CERTTYPE="vertrouwelijkheidcertificaat"`  
`./test_script_UZI-register_Medewerker_op_naam_CA_G21_GENERIC_USER.sh`  

## Level 3 - End Entity Certificate - Medewerker op naam G3
CERTTYPE Options: authenticiteitcertificaat, vertrouwelijkheidcertificaat, handtekeningcertificaat  
`SURNAME="Zorg"`  
`GIVENNAME="Jan"`  
`CERTTYPE="vertrouwelijkheidcertificaat"`  
`./test_script_UZI-register_Medewerker_op_naam_CA_G3_GENERIC_USER.sh`  

## Level 3 - End Entity Certificate - Zorgverlener G21
CERTTYPE Options: authenticiteitcertificaat, vertrouwelijkheidcertificaat, handtekeningcertificaat  
`TITLE="physician"`  
`SURNAME="Zorg"`  
`GIVENNAME="Jan"`  
`CERTTYPE="vertrouwelijkheidcertificaat"`  
`./test_script_UZI-register_Zorgverlener_CA_G21_GENERIC_USER.sh`  

## Level 3 - End Entity Certificate - Zorgverlener G3
CERTTYPE Options: authenticiteitcertificaat, vertrouwelijkheidcertificaat, handtekeningcertificaat  
`TITLE="physician"`  
`SURNAME="Zorg"`  
`GIVENNAME="Jan"`  
`CERTTYPE="vertrouwelijkheidcertificaat"`  
`./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh`  

## Level 3 - End Entity Certificate - Private Server
`SUBJECT_ALT_NAME="host.example.org"`  
`CERTTYPE="servercertificaat"`  
`./test_script_UZI-register_Private_Server_CA_G1_GENERIC_HOST.sh`  


## Support script to create various OpenSSL config files
CERTTYPE Options: authenticiteitcertificaat, vertrouwelijkheidcertificaat, handtekeningcertificaat, servercertificaat  
`CERTTYPE="servercertificaat"`  
`./test_script_support_create_config.sh`  

