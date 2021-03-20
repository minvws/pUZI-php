# Fake UZI PKI
Start generation with ./generate-mock-certs-with-pki.sh

The output will be:
* A root CA for all certificates associated with people.
  * An intermediate CA for certificates assigned to organisations and not personally by name.
    * An issuing CA for certificates assigned to organisations and not personally by name.
      * A certificate assigned to an employee (medewerker), but not assigned per name.
  * An intermediate CA for certificates assigned to a person by name.
    * An issuing CA for certificates assigned to a healthcare worker (zorgverlener), like a physician.
      * A set of all variants of healthcare professions, addressed per formal title, and (when exists) a specialism and per name.
    * An issuing CA for certificates assigned to a employee (medewerker) by name.
      * A certificate assigned to an employee (medewerker) by name.
* A root CA associate with servers.
  * An intermediate CA for certificates assigned to a server/services in an organisation.
    * An issuing CA for certificates assigned to a server/service by domain name in an organisation.
      * A server certificate, with client and server properties.
* CA bundle files for:
  * All CAs in the 'A root CA for all certificates associated with people'.
  * All CAs in the 'A root CA associate with servers'


## Main generator script for the PKI.
```bash
./generate-mock-certs-with-pki.sh
```

## Level 1: Fake Private Root CA - Used for servers
```bash
./test_script_root_fake_staat_der_nederlanden_private_root_ca_g42.sh
```

## Level 1: Fake Root CA - Used for people
```bash
./test_script_root_fake_staat_der_nederlanden_root_ca_g42.sh
```

## Level 2: Fake Intermediate CA - Used for servers
```bash
./test_script_fake_staat_der_nederlanden_private_services_ca_g42.sh
```

## Level 2: Fake Intermediate CA - Used for people, but NOT by name
```bash
./test_script_fake_staat_der_nederlanden_organisatie_services_ca_g42.sh
```

## Level 2: Fake Intermediate CA - Used for people, by name
```bash
./test_script_fake_staat_der_nederlanden_organisatie_persoon_ca_g42.sh
```

## Level 3: UZI-register Private Server CA - Used for servers
```bash
./test_script_UZI-register_Private_Server_CA_G1.sh
```

## Level 3: UZI-register Medewerker niet op naam CA - Used for employees, but NOT by name
```bash
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3.sh
```

## Level 3: UZI-register Zorgverlener CA - Used for people, by name
```bash
./test_script_UZI-register_Zorgverlener_CA_G3.sh
```

## Level 3: UZI Medewerker op naam CA - Used for employees, by name
```bash
./test_script_UZI-register_Medewerker_op_naam_CA_G3.sh
```



### Level 4 - End Entity Certificate - Medewerker niet op naam G3
Options CERTTYPE:
- authenticiteitcertificaat
- vertrouwelijkheidcertificaat
```bash
FUNCTION_NAME="Zorg Medewerker"  
CERTTYPE="vertrouwelijkheidcertificaat"  
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3_GENERIC_USER.sh  
```

### Level 4 - End Entity Certificate - Medewerker op naam G3
Options CERTTYPE:
- authenticiteitcertificaat
- vertrouwelijkheidcertificaat
- handtekeningcertificaat  
```bash
SURNAME="Zorg"  
GIVENNAME="Jan"  
CERTTYPE="vertrouwelijkheidcertificaat"  
./test_script_UZI-register_Medewerker_op_naam_CA_G3_GENERIC_USER.sh  
```

### Level 4 - End Entity Certificate - Zorgverlener G3
Options CERTTYPE:
- authenticiteitcertificaat
- vertrouwelijkheidcertificaat
- handtekeningcertificaat  
```bash
TITLE="physician"  
SURNAME="Zorg"  
GIVENNAME="Jan"  
CERTTYPE="vertrouwelijkheidcertificaat"  
./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh  
```

### Level 4 - End Entity Certificate - Private Server
```bash
SUBJECT_ALT_NAME="host.example.org"  
CERTTYPE="servercertificaat"  
./test_script_UZI-register_Private_Server_CA_G1_GENERIC_HOST.sh  
```

### Aanspreektitel (var: TITLE)
- Apotheker (17)
- Arts (01)
- Fysiotherapeut (04)
- Gezondheidszorgpsycholoog (25)
- Psychotherapeut (16)
- Tandarts (02)
- Verloskundige (03)
- Verpleegkundige (30)
- Physician assistant (81)
- Orthopedagoog –generalist (31)
- ... and all other specialisms and other forms.

### Certificate type (var: CERTTYPE)
- authenticiteitcertificaat
- vertrouwelijkheidcertificaat
- handtekeningcertificaat  
- servercertificaat 
