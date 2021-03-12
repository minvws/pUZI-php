#!/bin/sh

# ROOT CA
./test_script_root_ca.sh || exit 1

# First level Intermediate CA
./test_script_intermediate_services_ca.sh || exit 1

# Second level Intermediate CA - UZI SERVERS
./test_script_UZI-register_Private_Server_CA_G1.sh || exit 1

# Second level Intermediate CA - UZI Zorgverlener_CA
./test_script_UZI-register_Zorgverlener_CA_G21.sh || exit 1
./test_script_UZI-register_Zorgverlener_CA_G3.sh || exit 1

# Second level Intermediate CA - UZI Medewerker_niet_op_naam_CA
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G21.sh || exit 1
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3.sh || exit 1

# Second level Intermediate CA - UZI Medewerker_op_naam_CA
./test_script_UZI-register_Medewerker_op_naam_CA_G21.sh || exit 1
./test_script_UZI-register_Medewerker_op_naam_CA_G3.sh || exit 1


# Server certificate
export SUBJECT_ALT_NAME="host-generated.example.org"
export CERTTYPE="servercertificaat"
./test_script_UZI-register_Private_Server_CA_G1_GENERIC_HOST.sh || exit 1


# Loop the certificate types for clients
CERTTYPES=("authenticiteitcertificaat" "vertrouwelijkheidcertificaat" "handtekeningcertificaat")
for CERTTYPE in ${CERTTYPES[*]}; do
     echo "CERTTYPE: ${CERTTYPE}"
     export CERTTYPE

    ./test_script_UZI-register_Medewerker_op_naam_CA_G21_GENERIC_USER.sh || exit 1
    ./test_script_UZI-register_Medewerker_op_naam_CA_G3_GENERIC_USER.sh || exit 1
    ./test_script_UZI-register_Medewerker_niet_op_naam_CA_G21_GENERIC_USER.sh || exit 1
    ./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3_GENERIC_USER.sh || exit 1

    # Title
    export TITLE="Arts"
 
    AANSPREEKTITLES=("Apotheker" "Arts" "Fysiotherapeut" 
                     "Gezondheidszorgpsycholoog" "Psychotherapeut" 
                     "Tandarts" "Verloskundige" "Verpleegkundige" 
                     "Physician assistant" "Orthopedagoog -generalist")
    for TITLE in ${AANSPREEKTITLES[*]}; do
        echo "TITLE: ${TITLE}"
        export TITLE

        ./test_script_UZI-register_Zorgverlener_CA_G21_GENERIC_USER.sh || exit 1
        ./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh || exit 1
    done
done

exit 0
