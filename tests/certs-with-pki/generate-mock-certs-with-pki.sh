#!/bin/bash


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


# Loop the certificate types for clients - only two types for 'Niet op naam'
CERTTYPES=("authenticiteitcertificaat" "vertrouwelijkheidcertificaat")
for CERTTYPE in ${CERTTYPES[*]}; do
    echo "##### CERTTYPE: ${CERTTYPE}"
    export CERTTYPE

    ./test_script_UZI-register_Medewerker_niet_op_naam_CA_G21_GENERIC_USER.sh || exit 1
    ./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3_GENERIC_USER.sh || exit 1
done

# Loop the certificate types for clients - all three types for 'Medewerker op naam' en Zorgverlener
CERTTYPES=("authenticiteitcertificaat" "vertrouwelijkheidcertificaat" "handtekeningcertificaat")
for CERTTYPE in ${CERTTYPES[*]}; do
    echo "##### CERTTYPE: ${CERTTYPE}"
    export CERTTYPE

    ./test_script_UZI-register_Medewerker_op_naam_CA_G21_GENERIC_USER.sh || exit 1
    ./test_script_UZI-register_Medewerker_op_naam_CA_G3_GENERIC_USER.sh || exit 1


    # Aanspreektitle, source for /title= field in Subject DN
    # key:      the code (according to the CPS per aanspreektitle)
    # value:    the aanspreektitle as literal copy from the CPS.

    # Note: on MacOS natively a version of bash is present which does not yet
    # support hashmaps. Hence this hack to MacGuyver key/value hashmaps for bash 3.x
    declare -a AANSPREEKTITLES

    # Artikel 3 Wet BIG
    AANSPREEKTITLES+=("KEY_01__VALUE_Arts")
    AANSPREEKTITLES+=("KEY_02__VALUE_Tandarts")
    AANSPREEKTITLES+=("KEY_03__VALUE_Verloskundige")
    AANSPREEKTITLES+=("KEY_04__VALUE_Fysiotherapeut")
    AANSPREEKTITLES+=("KEY_16__VALUE_Psychotherapeut")
    AANSPREEKTITLES+=("KEY_17__VALUE_Apotheker")
    AANSPREEKTITLES+=("KEY_25__VALUE_Gezondheidszorgpsycholoog")
    AANSPREEKTITLES+=("KEY_30__VALUE_Verpleegkundige")
    AANSPREEKTITLES+=("KEY_31__VALUE_Orthopedagoog –generalist")
    AANSPREEKTITLES+=("KEY_81__VALUE_Physician assistant")


    # Specialismen bij art. 3 beroepen
    # Apotheker
    AANSPREEKTITLES+=("KEY_060__VALUE_Ziekenhuisapotheker")
    AANSPREEKTITLES+=("KEY_075__VALUE_Openbaar apotheker (Openbare Farmacie)")

    # Arts
    AANSPREEKTITLES+=("KEY_002__VALUE_Allergoloog (gesloten register)")
    AANSPREEKTITLES+=("KEY_003__VALUE_Anesthesioloog")
    AANSPREEKTITLES+=("KEY_004__VALUE_Apotheekhoudend huisarts")
    AANSPREEKTITLES+=("KEY_020__VALUE_Arts klinische chemie (gesloten register)")
    AANSPREEKTITLES+=("KEY_055__VALUE_Arts maatschappij en gezondheid")
    AANSPREEKTITLES+=("KEY_013__VALUE_Arts v. maag-darm-leverziekten")
    AANSPREEKTITLES+=("KEY_056__VALUE_Arts voor verstandelijk gehandicapten")
    AANSPREEKTITLES+=("KEY_024__VALUE_Arts-microbioloog")
    AANSPREEKTITLES+=("KEY_008__VALUE_Bedrijfsarts")
    AANSPREEKTITLES+=("KEY_010__VALUE_Cardioloog")
    AANSPREEKTITLES+=("KEY_011__VALUE_Cardiothoracaal chirurg")
    AANSPREEKTITLES+=("KEY_014__VALUE_Chirurg")
    AANSPREEKTITLES+=("KEY_012__VALUE_Dermatoloog")
    AANSPREEKTITLES+=("KEY_046__VALUE_Gynaecoloog")
    AANSPREEKTITLES+=("KEY_015__VALUE_Huisarts")
    AANSPREEKTITLES+=("KEY_016__VALUE_Internist")
    AANSPREEKTITLES+=("KEY_062__VALUE_Internist-allergoloog (gesloten register)")
    AANSPREEKTITLES+=("KEY_070__VALUE_Jeugdarts")
    AANSPREEKTITLES+=("KEY_018__VALUE_Keel- neus- oorarts")
    AANSPREEKTITLES+=("KEY_019__VALUE_Kinderarts")
    AANSPREEKTITLES+=("KEY_021__VALUE_Klinisch geneticus")
    AANSPREEKTITLES+=("KEY_022__VALUE_Klinisch geriater")
    AANSPREEKTITLES+=("KEY_023__VALUE_Longarts")
    AANSPREEKTITLES+=("KEY_025__VALUE_Neurochirurg")
    AANSPREEKTITLES+=("KEY_026__VALUE_Neuroloog")
    AANSPREEKTITLES+=("KEY_030__VALUE_Nucleair geneeskundige")
    AANSPREEKTITLES+=("KEY_031__VALUE_Oogarts")
    AANSPREEKTITLES+=("KEY_032__VALUE_Orthopedisch chirurg")
    AANSPREEKTITLES+=("KEY_033__VALUE_Patholoog")
    AANSPREEKTITLES+=("KEY_034__VALUE_Plastisch chirurg")
    AANSPREEKTITLES+=("KEY_035__VALUE_Psychiater")
    AANSPREEKTITLES+=("KEY_039__VALUE_Radioloog")
    AANSPREEKTITLES+=("KEY_040__VALUE_Radiotherapeut")
    AANSPREEKTITLES+=("KEY_041__VALUE_Reumatoloog")
    AANSPREEKTITLES+=("KEY_042__VALUE_Revalidatiearts")
    AANSPREEKTITLES+=("KEY_047__VALUE_Specialist ouderengeneeskunde")
    AANSPREEKTITLES+=("KEY_071__VALUE_Spoedeisende hulp arts")
    AANSPREEKTITLES+=("KEY_074__VALUE_Sportarts")
    AANSPREEKTITLES+=("KEY_045__VALUE_Uroloog")
    AANSPREEKTITLES+=("KEY_048__VALUE_Verzekeringsarts")
    AANSPREEKTITLES+=("KEY_050__VALUE_Zenuwarts (gesloten register)")

    # Gezondheidszorgpsycholoog
    AANSPREEKTITLES+=("KEY_063__VALUE_Klinisch neuropsycholoog")
    AANSPREEKTITLES+=("KEY_061__VALUE_Klinisch psycholoog")

    # Tandarts
    AANSPREEKTITLES+=("KEY_053__VALUE_Orthodontist")
    AANSPREEKTITLES+=("KEY_054__VALUE_Kaakchirurg")

    # Verpleegkundige
    AANSPREEKTITLES+=("KEY_066__VALUE_Verpl. spec. acute zorg bij som. aandoeningen")
    AANSPREEKTITLES+=("KEY_068__VALUE_Verpl. spec. chronische zorg bij som. aandoeningen")
    AANSPREEKTITLES+=("KEY_069__VALUE_Verpl. spec. geestelijke gezondheidszorg")
    AANSPREEKTITLES+=("KEY_067__VALUE_Verpl. spec. intensieve zorg bij som. aandoeningen")
    AANSPREEKTITLES+=("KEY_065__VALUE_Verpl. spec. prev. zorg bij som. aandoeningen")

    # Artikel 34 Wet BIG: opleidingstitels
    AANSPREEKTITLES+=("KEY_83__VALUE_Apothekersassistent")
    AANSPREEKTITLES+=("KEY_89__VALUE_Diëtist")
    AANSPREEKTITLES+=("KEY_90__VALUE_Ergotherapeut")
    AANSPREEKTITLES+=("KEY_88__VALUE_Huidtherapeut")
    AANSPREEKTITLES+=("KEY_84__VALUE_Klinisch fysicus")
    AANSPREEKTITLES+=("KEY_91__VALUE_Logopedist")
    AANSPREEKTITLES+=("KEY_92__VALUE_Mondhygiënist")
    AANSPREEKTITLES+=("KEY_94__VALUE_Oefentherapeut Cesar")
    AANSPREEKTITLES+=("KEY_93__VALUE_Oefentherapeut Mensendieck")
    AANSPREEKTITLES+=("KEY_87__VALUE_Optometrist")
    AANSPREEKTITLES+=("KEY_95__VALUE_Orthoptist")
    AANSPREEKTITLES+=("KEY_96__VALUE_Podotherapeut")
    AANSPREEKTITLES+=("KEY_97__VALUE_Radiodiagnostisch laborant")
    AANSPREEKTITLES+=("KEY_98__VALUE_Radiotherapeutisch laborant")
    AANSPREEKTITLES+=("KEY_85__VALUE_Tandprotheticus")
    AANSPREEKTITLES+=("KEY_86__VALUE_VIG-er")

    # Artikel 36a Wet BIG
    AANSPREEKTITLES+=("KEY_82__VALUE_Klinisch technoloog")
    AANSPREEKTITLES+=("KEY_80__VALUE_Bachelor medisch hulpverlener")
    AANSPREEKTITLES+=("KEY_79__VALUE_Geregistreerd-mondhygiënist")

    # Andere Zorg
    AANSPREEKTITLES+=("KEY_99__VALUE_Zorgverlener andere zorg")


    for KEY_VALUE in "${AANSPREEKTITLES[@]}"; do
        # Cut the Key Value
        KEY=$(echo "$KEY_VALUE" | cut -d"_" -f 2)
        VALUE=$(echo "$KEY_VALUE" | cut -d"_" -f 5-)

        TITLE_CODE="$KEY"
        TITLE="$VALUE"

        echo "##### TITLE: ${TITLE} (${TITLE_CODE})"
        export TITLE
        export TITLE_CODE

        ./test_script_UZI-register_Zorgverlener_CA_G21_GENERIC_USER.sh || exit 1
        ./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh || exit 1
    done
done

exit 0
