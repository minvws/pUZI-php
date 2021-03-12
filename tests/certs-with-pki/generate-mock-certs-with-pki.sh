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


# Client certificates
export CERTTYPE="authenticiteitcertificaat"
./test_script_UZI-register_Medewerker_op_naam_CA_G3_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Zorgverlener_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_op_naam_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh || exit 1

export CERTTYPE="vertrouwelijkheidcertificaat"
./test_script_UZI-register_Medewerker_op_naam_CA_G3_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Zorgverlener_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_op_naam_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh || exit 1

export CERTTYPE="handtekeningcertificaat"
./test_script_UZI-register_Medewerker_op_naam_CA_G3_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Zorgverlener_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_op_naam_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh || exit 1

export CERTTYPE="servercertificaat"
./test_script_UZI-register_Private_Server_CA_G1_GENERIC_HOST.sh || exit 1


exit 0
