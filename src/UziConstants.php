<?php

namespace MinVWS\PUZI;

/**
 * Class UziConstants
 * SPDX-License-Identifier: EUPL-1.2
 * For reference please read, Certification Practice Statement CPS NL v11.6
 * @link https://www.zorgcsp.nl/certification-practice-statement-cps
 * @package MinVWS\PUZI
 */
class UziConstants
{
    public const OID_CA_CARE_PROVIDER = '2.16.528.1.1003.1.3.5.5.2';     // Reference page 63
    public const OID_CA_NAMED_EMPLOYEE = '2.16.528.1.1003.1.3.5.5.3';    // Reference page 63
    public const OID_CA_UNNAMED_EMPLOYEE = '2.16.528.1.1003.1.3.5.5.4';  // Reference page 63
    public const OID_CA_SERVER = '2.16.528.1.1003.1.3.5.5.5';            // Reference page 63

    public const UZI_TYPE_CARE_PROVIDER = 'Z';                           // Reference page 63
    public const UZI_TYPE_NAMED_EMPLOYEE = 'N';                          // Reference page 63
    public const UZI_TYPE_UNNAMED_EMPLOYEE = 'M';                        // Reference page 63
    public const UZI_TYPE_SERVER = 'S';                                  // Reference page 63

    public const UZI_ROLE_PHARMACIST = '17.';                            // Reference page 98
    public const UZI_ROLE_DOCTOR = '01.';                                // Reference page 98
    public const UZI_ROLE_PHYSIOTHERAPIST = '04.';                       // Reference page 98
    public const UZI_ROLE_HEALTHCARE_PSYCHOLOGIST = '25.';               // Reference page 98
    public const UZI_ROLE_PSYCHOTHERAPIST = '16.';                       // Reference page 98
    public const UZI_ROLE_DENTIST = '02.';                               // Reference page 98
    public const UZI_ROLE_MIDWIFE = '03.';                               // Reference page 98
    public const UZI_ROLE_NURSE = '30.';                                 // Reference page 98
    public const UZI_ROLE_PHYS_ASSISTANT = '81.';                        // Reference page 98
    public const UZI_ROLE_ORTHOPEDAGOGUE_GENERALIST = '31.';             // Reference page 98
    public const UZI_ROLE_CLINICAL_TECHNOLOGIST = '82.';                 // Reference page 98

    public const OID_IA5STRING = '2.5.5.5';                              // https://oidref.com/2.5.5.5
}
