#!/bin/sh

./test_script_root_ca.sh || exit 1
./test_script_intermediate_services_ca.sh || exit 1

./test_script_UZI-register_Private_Server_CA_G1.sh || exit 1

./test_script_UZI-register_Zorgverlener_CA_G21.sh || exit 1
./test_script_UZI-register_Zorgverlener_CA_G3.sh || exit 1

./test_script_UZI-register_Medewerker_niet_op_naam_CA_G21.sh || exit 1
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3.sh || exit 1

./test_script_UZI-register_Medewerker_op_naam_CA_G21.sh || exit 1
./test_script_UZI-register_Medewerker_op_naam_CA_G3.sh || exit 1


CERTTYPE="authenticiteitcertificaat"
./test_script_UZI-register_Medewerker_op_naam_CA_G3_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Zorgverlener_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_op_naam_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh || exit 1

CERTTYPE="vertrouwelijkheidcertificaat"
./test_script_UZI-register_Medewerker_op_naam_CA_G3_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Zorgverlener_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_op_naam_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh || exit 1

CERTTYPE="handtekeningcertificaat"
./test_script_UZI-register_Medewerker_op_naam_CA_G3_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Zorgverlener_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Medewerker_op_naam_CA_G21_GENERIC_USER.sh || exit 1
./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh || exit 1


CERTTYPE="servercertificaat"
#TODO


exit 0
