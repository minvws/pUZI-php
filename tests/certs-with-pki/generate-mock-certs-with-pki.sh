#!/bin/bash


## Level 1: Fake Private Root CA - Used for servers
./test_script_root_fake_staat_der_nederlanden_private_root_ca_g42.sh || exit 1

## Level 1: Fake Root CA - Used for people
./test_script_root_fake_staat_der_nederlanden_root_ca_g42.sh || exit 1

## Level 2: Fake Intermediate CA - Used for servers
./test_script_fake_staat_der_nederlanden_private_services_ca_g42.sh || exit 1

## Level 2: Fake Intermediate CA - Used for people, but NOT by name
./test_script_fake_staat_der_nederlanden_organisatie_services_ca_g42.sh || exit 1

## Level 2: Fake Intermediate CA - Used for people, by name
./test_script_fake_staat_der_nederlanden_organisatie_persoon_ca_g42.sh || exit 1

## Level 3: UZI-register Private Server CA - Used for servers
./test_script_UZI-register_Private_Server_CA_G1.sh || exit 1

## Level 3: UZI-register Medewerker niet op naam CA - Used for employees, but NOT by name
./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3.sh || exit 1

## Level 3: UZI-register Zorgverlener CA - Used for people, by name
./test_script_UZI-register_Zorgverlener_CA_G3.sh || exit 1

## Level 3: UZI Medewerker op naam CA - Used for employees, by name
./test_script_UZI-register_Medewerker_op_naam_CA_G3.sh || exit 1


# De volgende codering wordt toegepast:
#   ‘Z’ : Zorgverlenerpas
#   ‘N’ : Medewerkerpas op naam
#   ‘M’ : Medewerkerpas niet op naam
#   ‘S’ : Servercertificaten
# These are the values for the PASSTYPE variable

## Server certificate
export SUBJECT_ALT_NAME="host-generated.example.org"
export CERTTYPE="servercertificaat"
export PASSTYPE="S"
./test_script_UZI-register_Private_Server_CA_G1_GENERIC_HOST.sh || exit 1

# Loop the certificate types for "Medewerker niet op naam"
CERTTYPES=("authenticiteitcertificaat" "vertrouwelijkheidcertificaat")
for CERTTYPE in ${CERTTYPES[*]}; do
    echo "##### CERTTYPE: ${CERTTYPE}"
    export CERTTYPE
    export PASSTYPE="M"

    ./test_script_UZI-register_Medewerker_niet_op_naam_CA_G3_GENERIC_USER.sh || exit 1
done

# Loop the certificate types for "Medewerker op naam"
CERTTYPES=("authenticiteitcertificaat" "vertrouwelijkheidcertificaat" "handtekeningcertificaat")
for CERTTYPE in ${CERTTYPES[*]}; do
    echo "##### CERTTYPE: ${CERTTYPE}"
    export CERTTYPE
    export CERT_I_CA="MEDEWERKER_OP_NAAM"
    export PASSTYPE="N"

    ./test_script_UZI-register_Medewerker_op_naam_CA_G3_GENERIC_USER.sh || exit 1
done

# Loop the certificate types for "Zorgverlener"
CERTTYPES=("authenticiteitcertificaat" "vertrouwelijkheidcertificaat" "handtekeningcertificaat")
for CERTTYPE in ${CERTTYPES[*]}; do
    echo "##### CERTTYPE: ${CERTTYPE}"
    export CERTTYPE
    export PASSTYPE="Z"

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
    APOTHEKER_SPECIALISMS+=("KEY_060__VALUE_Ziekenhuisapotheker")
    APOTHEKER_SPECIALISMS+=("KEY_075__VALUE_Openbaar apotheker (Openbare Farmacie)")

    # Arts
    ARTS_SPECIALISMS+=("KEY_002__VALUE_Allergoloog (gesloten register)")
    ARTS_SPECIALISMS+=("KEY_003__VALUE_Anesthesioloog")
    ARTS_SPECIALISMS+=("KEY_004__VALUE_Apotheekhoudend huisarts")
    ARTS_SPECIALISMS+=("KEY_020__VALUE_Arts klinische chemie (gesloten register)")
    ARTS_SPECIALISMS+=("KEY_055__VALUE_Arts maatschappij en gezondheid")
    ARTS_SPECIALISMS+=("KEY_013__VALUE_Arts v. maag-darm-leverziekten")
    ARTS_SPECIALISMS+=("KEY_056__VALUE_Arts voor verstandelijk gehandicapten")
    ARTS_SPECIALISMS+=("KEY_024__VALUE_Arts-microbioloog")
    ARTS_SPECIALISMS+=("KEY_008__VALUE_Bedrijfsarts")
    ARTS_SPECIALISMS+=("KEY_010__VALUE_Cardioloog")
    ARTS_SPECIALISMS+=("KEY_011__VALUE_Cardiothoracaal chirurg")
    ARTS_SPECIALISMS+=("KEY_014__VALUE_Chirurg")
    ARTS_SPECIALISMS+=("KEY_012__VALUE_Dermatoloog")
    ARTS_SPECIALISMS+=("KEY_046__VALUE_Gynaecoloog")
    ARTS_SPECIALISMS+=("KEY_015__VALUE_Huisarts")
    ARTS_SPECIALISMS+=("KEY_016__VALUE_Internist")
    ARTS_SPECIALISMS+=("KEY_062__VALUE_Internist-allergoloog (gesloten register)")
    ARTS_SPECIALISMS+=("KEY_070__VALUE_Jeugdarts")
    ARTS_SPECIALISMS+=("KEY_018__VALUE_Keel- neus- oorarts")
    ARTS_SPECIALISMS+=("KEY_019__VALUE_Kinderarts")
    ARTS_SPECIALISMS+=("KEY_021__VALUE_Klinisch geneticus")
    ARTS_SPECIALISMS+=("KEY_022__VALUE_Klinisch geriater")
    ARTS_SPECIALISMS+=("KEY_023__VALUE_Longarts")
    ARTS_SPECIALISMS+=("KEY_025__VALUE_Neurochirurg")
    ARTS_SPECIALISMS+=("KEY_026__VALUE_Neuroloog")
    ARTS_SPECIALISMS+=("KEY_030__VALUE_Nucleair geneeskundige")
    ARTS_SPECIALISMS+=("KEY_031__VALUE_Oogarts")
    ARTS_SPECIALISMS+=("KEY_032__VALUE_Orthopedisch chirurg")
    ARTS_SPECIALISMS+=("KEY_033__VALUE_Patholoog")
    ARTS_SPECIALISMS+=("KEY_034__VALUE_Plastisch chirurg")
    ARTS_SPECIALISMS+=("KEY_035__VALUE_Psychiater")
    ARTS_SPECIALISMS+=("KEY_039__VALUE_Radioloog")
    ARTS_SPECIALISMS+=("KEY_040__VALUE_Radiotherapeut")
    ARTS_SPECIALISMS+=("KEY_041__VALUE_Reumatoloog")
    ARTS_SPECIALISMS+=("KEY_042__VALUE_Revalidatiearts")
    ARTS_SPECIALISMS+=("KEY_047__VALUE_Specialist ouderengeneeskunde")
    ARTS_SPECIALISMS+=("KEY_071__VALUE_Spoedeisende hulp arts")
    ARTS_SPECIALISMS+=("KEY_074__VALUE_Sportarts")
    ARTS_SPECIALISMS+=("KEY_045__VALUE_Uroloog")
    ARTS_SPECIALISMS+=("KEY_048__VALUE_Verzekeringsarts")
    ARTS_SPECIALISMS+=("KEY_050__VALUE_Zenuwarts (gesloten register)")

    # Gezondheidszorgpsycholoog
    GEZONDHEIDSZORGPSYCHOLOOG_SPECIALISMS+=("KEY_063__VALUE_Klinisch neuropsycholoog")
    GEZONDHEIDSZORGPSYCHOLOOG_SPECIALISMS+=("KEY_061__VALUE_Klinisch psycholoog")

    # Tandarts
    TANDARTS_SPECIALISMS+=("KEY_053__VALUE_Orthodontist")
    TANDARTS_SPECIALISMS+=("KEY_054__VALUE_Kaakchirurg")

    # Verpleegkundige
    VERPLEEGKUNDIGE_SPECIALISMS+=("KEY_066__VALUE_Verpl. spec. acute zorg bij som. aandoeningen")
    VERPLEEGKUNDIGE_SPECIALISMS+=("KEY_068__VALUE_Verpl. spec. chronische zorg bij som. aandoeningen")
    VERPLEEGKUNDIGE_SPECIALISMS+=("KEY_069__VALUE_Verpl. spec. geestelijke gezondheidszorg")
    VERPLEEGKUNDIGE_SPECIALISMS+=("KEY_067__VALUE_Verpl. spec. intensieve zorg bij som. aandoeningen")
    VERPLEEGKUNDIGE_SPECIALISMS+=("KEY_065__VALUE_Verpl. spec. prev. zorg bij som. aandoeningen")

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

        export TITLE_CODE="$KEY"
        export TITLE="$VALUE"


        # Generic title, without specialisms. Also needed for title without any
        # specialism.

        # Clean specialisms
        unset SPECI_CODE
        unset SPECIALISM

        echo "##### TITLE: ${TITLE} (${TITLE_CODE}), Specialism: None"
        ./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh || exit 1


        # Apotheker
        if [ "${TITLE}" = "Apotheker" ]; then
            for SP_KEY_VALUE in "${APOTHEKER_SPECIALISMS[@]}"; do
                # Cut the Key Value
                KEY=$(echo "$SP_KEY_VALUE" | cut -d"_" -f 2)
                VALUE=$(echo "$SP_KEY_VALUE" | cut -d"_" -f 5-)

                export SPECI_CODE="$KEY"
                export SPECIALISM="$VALUE"

                echo "##### TITLE: ${TITLE} (${TITLE_CODE}), Specialism: ${SPECIALISM} (${SPECI_CODE})"
                ./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh || exit 1
            done

        # Arts
        elif [ "${TITLE}" = "Arts" ]; then
            for SP_KEY_VALUE in "${ARTS_SPECIALISMS[@]}"; do
                # Cut the Key Value
                KEY=$(echo "$SP_KEY_VALUE" | cut -d"_" -f 2)
                VALUE=$(echo "$SP_KEY_VALUE" | cut -d"_" -f 5-)

                export SPECI_CODE="$KEY"
                export SPECIALISM="$VALUE"

                echo "##### TITLE: ${TITLE} (${TITLE_CODE}), Specialism: ${SPECIALISM} (${SPECI_CODE})"
                ./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh || exit 1
            done

        # Gezondheidszorgpsycholoog
        elif [ "${TITLE}" = "Gezondheidszorgpsycholoog" ]; then
            for SP_KEY_VALUE in "${GEZONDHEIDSZORGPSYCHOLOOG_SPECIALISMS[@]}"; do
                # Cut the Key Value
                KEY=$(echo "$SP_KEY_VALUE" | cut -d"_" -f 2)
                VALUE=$(echo "$SP_KEY_VALUE" | cut -d"_" -f 5-)

                export SPECI_CODE="$KEY"
                export SPECIALISM="$VALUE"

                echo "##### TITLE: ${TITLE} (${TITLE_CODE}), Specialism: ${SPECIALISM} (${SPECI_CODE})"
                ./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh || exit 1
            done

        # Tandarts
        elif [ "${TITLE}" = "Tandarts" ]; then
            for SP_KEY_VALUE in "${TANDARTS_SPECIALISMS[@]}"; do
                # Cut the Key Value
                KEY=$(echo "$SP_KEY_VALUE" | cut -d"_" -f 2)
                VALUE=$(echo "$SP_KEY_VALUE" | cut -d"_" -f 5-)

                export SPECI_CODE="$KEY"
                export SPECIALISM="$VALUE"

                echo "##### TITLE: ${TITLE} (${TITLE_CODE}), Specialism: ${SPECIALISM} (${SPECI_CODE})"
                ./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh || exit 1
            done

        # Verpleegkundige
        elif [ "${TITLE}" = "Verpleegkundige" ]; then
            for SP_KEY_VALUE in "${VERPLEEGKUNDIGE_SPECIALISMS[@]}"; do
                # Cut the Key Value
                KEY=$(echo "$SP_KEY_VALUE" | cut -d"_" -f 2)
                VALUE=$(echo "$SP_KEY_VALUE" | cut -d"_" -f 5-)

                export SPECI_CODE="$KEY"
                export SPECIALISM="$VALUE"

                echo "##### TITLE: ${TITLE} (${TITLE_CODE}), Specialism: ${SPECIALISM} (${SPECI_CODE})"
                ./test_script_UZI-register_Zorgverlener_CA_G3_GENERIC_USER.sh || exit 1
            done
        fi
    done
done

exit 0
