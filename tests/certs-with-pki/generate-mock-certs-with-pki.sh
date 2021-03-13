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
    SPECIALISMS+=("KEY_060__VALUE_Ziekenhuisapotheker")
    SPECIALISMS+=("KEY_075__VALUE_Openbaar apotheker (Openbare Farmacie)")

    # Arts
    SPECIALISMS+=("KEY_002__VALUE_Allergoloog (gesloten register)")
    SPECIALISMS+=("KEY_003__VALUE_Anesthesioloog")
    SPECIALISMS+=("KEY_004__VALUE_Apotheekhoudend huisarts")
    SPECIALISMS+=("KEY_020__VALUE_Arts klinische chemie (gesloten register)")
    SPECIALISMS+=("KEY_055__VALUE_Arts maatschappij en gezondheid")
    SPECIALISMS+=("KEY_013__VALUE_Arts v. maag-darm-leverziekten")
    SPECIALISMS+=("KEY_056__VALUE_Arts voor verstandelijk gehandicapten")
    SPECIALISMS+=("KEY_024__VALUE_Arts-microbioloog")
    SPECIALISMS+=("KEY_008__VALUE_Bedrijfsarts")
    SPECIALISMS+=("KEY_010__VALUE_Cardioloog")
    SPECIALISMS+=("KEY_011__VALUE_Cardiothoracaal chirurg")
    SPECIALISMS+=("KEY_014__VALUE_Chirurg")
    SPECIALISMS+=("KEY_012__VALUE_Dermatoloog")
    SPECIALISMS+=("KEY_046__VALUE_Gynaecoloog")
    SPECIALISMS+=("KEY_015__VALUE_Huisarts")
    SPECIALISMS+=("KEY_016__VALUE_Internist")
    SPECIALISMS+=("KEY_062__VALUE_Internist-allergoloog (gesloten register)")
    SPECIALISMS+=("KEY_070__VALUE_Jeugdarts")
    SPECIALISMS+=("KEY_018__VALUE_Keel- neus- oorarts")
    SPECIALISMS+=("KEY_019__VALUE_Kinderarts")
    SPECIALISMS+=("KEY_021__VALUE_Klinisch geneticus")
    SPECIALISMS+=("KEY_022__VALUE_Klinisch geriater")
    SPECIALISMS+=("KEY_023__VALUE_Longarts")
    SPECIALISMS+=("KEY_025__VALUE_Neurochirurg")
    SPECIALISMS+=("KEY_026__VALUE_Neuroloog")
    SPECIALISMS+=("KEY_030__VALUE_Nucleair geneeskundige")
    SPECIALISMS+=("KEY_031__VALUE_Oogarts")
    SPECIALISMS+=("KEY_032__VALUE_Orthopedisch chirurg")
    SPECIALISMS+=("KEY_033__VALUE_Patholoog")
    SPECIALISMS+=("KEY_034__VALUE_Plastisch chirurg")
    SPECIALISMS+=("KEY_035__VALUE_Psychiater")
    SPECIALISMS+=("KEY_039__VALUE_Radioloog")
    SPECIALISMS+=("KEY_040__VALUE_Radiotherapeut")
    SPECIALISMS+=("KEY_041__VALUE_Reumatoloog")
    SPECIALISMS+=("KEY_042__VALUE_Revalidatiearts")
    SPECIALISMS+=("KEY_047__VALUE_Specialist ouderengeneeskunde")
    SPECIALISMS+=("KEY_071__VALUE_Spoedeisende hulp arts")
    SPECIALISMS+=("KEY_074__VALUE_Sportarts")
    SPECIALISMS+=("KEY_045__VALUE_Uroloog")
    SPECIALISMS+=("KEY_048__VALUE_Verzekeringsarts")
    SPECIALISMS+=("KEY_050__VALUE_Zenuwarts (gesloten register)")

    # Gezondheidszorgpsycholoog
    SPECIALISMS+=("KEY_063__VALUE_Klinisch neuropsycholoog")
    SPECIALISMS+=("KEY_061__VALUE_Klinisch psycholoog")

    # Tandarts
    SPECIALISMS+=("KEY_053__VALUE_Orthodontist")
    SPECIALISMS+=("KEY_054__VALUE_Kaakchirurg")

    # Verpleegkundige
    SPECIALISMS+=("KEY_066__VALUE_Verpl. spec. acute zorg bij som. aandoeningen")
    SPECIALISMS+=("KEY_068__VALUE_Verpl. spec. chronische zorg bij som. aandoeningen")
    SPECIALISMS+=("KEY_069__VALUE_Verpl. spec. geestelijke gezondheidszorg")
    SPECIALISMS+=("KEY_067__VALUE_Verpl. spec. intensieve zorg bij som. aandoeningen")
    SPECIALISMS+=("KEY_065__VALUE_Verpl. spec. prev. zorg bij som. aandoeningen")

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


    for AT_KEY_VALUE in "${AANSPREEKTITLES[@]}"; do
        # Cut the Key Value
        KEY=$(echo "$AT_KEY_VALUE" | cut -d"_" -f 2)
        VALUE=$(echo "$AT_KEY_VALUE" | cut -d"_" -f 5-)

        TITLE_CODE="$KEY"
        TITLE="$VALUE"

        for SP_KEY_VALUE in "${SPECIALISMS[@]}"; do
            # Cut the Key Value
            KEY=$(echo "$SP_KEY_VALUE" | cut -d"_" -f 2)
            VALUE=$(echo "$SP_KEY_VALUE" | cut -d"_" -f 5-)

            SPECI_CODE="$KEY"
            SPECIALISM="$VALUE"


            echo "##### TITLE: ${TITLE} (${TITLE_CODE}), Specialism: ${SPECIALISM} (${SPECI_CODE})"
            export TITLE
            export TITLE_CODE
            export SPECI_CODE
            export SPECIALISM

            ./test_script_UZI-register_Zorgverlener_CA_G21_GENERIC_USER.sh || exit 1
            ./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh || exit 1
        done
    done
done

exit 0
