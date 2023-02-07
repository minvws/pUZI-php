<?php

namespace MinVWS\PUZI;

use phpseclib3\File\X509;
use Symfony\Component\HttpFoundation\Request;

/**
 * Class UziReader
 * SPDX-License-Identifier: EUPL-1.2
 * For reference please read
 * https://www.zorgcsp.nl/documents/RK1%20CPS%20UZI-register%20V10.2%20ENG.pdf
 * @package MinVWS\PUZI
 */
class UziReader
{
    /**
     * @param Request $request
     * @return UziUser|null
     */
    public function getDataFromRequest(Request $request): ?UziUser
    {
        $x509 = new X509();
        $cert = $x509->loadX509($request->server->get('SSL_CLIENT_CERT'));
        if (!$cert) {
            return null;
        }

        if (!isset($cert['tbsCertificate']['subject']['rdnSequence'])) {
            return null;
        }

        // Check if the certificate is a UZI certificate
        $surName = null;
        $givenName = null;
        foreach ($cert['tbsCertificate']['subject']['rdnSequence'] as $sequence) {
            $data = reset($sequence);
            if ($data['type'] === 'id-at-surname') {
                $surName = $data['value']['utf8String'];
            }
            if ($data['type'] === 'id-at-givenName') {
                $givenName = $data['value']['utf8String'];
            }
            if ($givenName && $surName) {
                break;
            }
        }

        foreach ($cert['tbsCertificate']['extensions'] ?? [] as $extension) {
            if ($extension['extnId'] !== "id-ce-subjectAltName") {
                continue;
            }

            foreach ($extension['extnValue'] as $value) {
                if (!isset($value['otherName']) || $value['otherName']['type-id'] !== UziConstants::OID_IA5STRING) {
                    continue;
                }

                if (!isset($value['otherName']['value']['ia5String'])) {
                    return null;
                }

                /**
                 * @var array $data
                 * Reference page 60
                 *
                 * [0] OID CA
                 * [1] UZI Version
                 * [2] UZI number
                 * [3] Card type
                 * [4] Subscriber number
                 * [5] Role (reference page 89)
                 * [6] AGB code
                 */
                $subjectAltName = $value['otherName']['value']['ia5String'];
                /** @var string[]|false $data */
                $data = explode('-', $subjectAltName);
                if (!is_array($data) || count($data) < 6) {
                    return null;
                }

                $user = new UziUser();
                $user->setGivenName($givenName ?? "");
                $user->setSurName($surName ?? "");
                $user->setOidCa($data[0]);
                $user->setUziVersion($data[1]);
                $user->setUziNumber($data[2]);
                $user->setCardType($data[3]);
                $user->setSubscriberNumber($data[4]);
                $user->setRole($data[5]);
                $user->setAgbCode($data[6]);

                return $user;
            }
        }

        return null;
    }
}
