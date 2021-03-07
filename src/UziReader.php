<?php

namespace MinVWS\PUZI;

use phpseclib3\File\X509;
use MinVWS\PUZI\Exceptions\UziException;

/**
 * Class UziReader
 *
 * For reference please read
 * https://www.zorgcsp.nl/documents/RK1%20CPS%20UZI-register%20V10.2%20ENG.pdf
 *
 * @package MinVWS\PUZI
 */
class UziReader
{
    /**
     * @return array
     * @throws UziException
     */
    public function getData(): array
    {
        if (!isset($_SERVER['SSL_CLIENT_VERIFY']) || $_SERVER['SSL_CLIENT_VERIFY'] !== 'SUCCESS') {
            throw new UziException('Webserver client cert check not passed');
        }
        if (!isset($_SERVER['SSL_CLIENT_CERT'])) {
            throw new UziException('No client certificate presented');
        }
        $x509 = new X509();
        $cert = $x509->loadX509($_SERVER['SSL_CLIENT_CERT']);
        $surName = null;
        $givenName = null;

        if (!isset($cert['tbsCertificate']['subject']['rdnSequence'])) {
            throw new UziException('No subject rdnSequence');
        }
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
        foreach ($cert['tbsCertificate']['extensions'] as $extension) {
            if ($extension['extnId'] !== "id-ce-subjectAltName") {
                continue;
            }

            foreach ($extension['extnValue'] as $value) {
                if (!isset($value['otherName']) || $value['otherName']['type-id'] !== UziConstants::OID_IA5STRING) {
                    continue;
                }

                if (!isset($value['otherName']['value']['ia5String'])) {
                    throw new UziException('No ia5String');
                }
                $subjectAltName = $value['otherName']['value']['ia5String'];
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
                $data = explode('-', $subjectAltName);
                if (!is_array($data) || count($data) < 6) {
                    throw new UziException('Incorrect SAN found');
                }
                return [
                    'givenName' => $givenName,
                    'surName' => $surName,
                    'OidCa' => $data[0],
                    'UziVersion' => $data[1],
                    'UziNumber' => $data[2],
                    'CardType' => $data[3],
                    'SubscriberNumber' => $data[4],
                    'Role' => $data[5],
                    'AgbCode' => $data[6],
                ];
            }
        }
        throw new UziException('No valid UZI data found');
    }
}
