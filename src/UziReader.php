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
    protected const OID_IA5STRING = '2.5.5.5';  // https://oidref.com/2.5.5.5

    /**
     * @return array
     * @throws UziException
     */
    public function getData(): array
    {
        if (!isset($_SERVER['SSL_CLIENT_VERIFY']) || $_SERVER['SSL_CLIENT_VERIFY'] !== 'SUCCESS') {
            throw new UziException('Apache client cert check not passed');
        }

        /** @var string|null $pem */
        $pem = null;
        if (isset($_SERVER['SSL_CLIENT_CERT'])) {
            $pem = $_SERVER['SSL_CLIENT_CERT'];
        }
        if (!$pem) {
            throw new UziException('No client certificate presented');
        }
        $x509 = new X509();
        $cert = $x509->loadX509($pem);
        $surName = null;
        $givenName = null;
        $user = null;

        if (!isset($cert['tbsCertificate']['subject']['rdnSequence'])) {
            throw new UziException('No subject rdnSequence');
        }
        foreach ($cert['tbsCertificate']['subject']['rdnSequence'] as $sequence) {
            if ($givenName && $surName) {
                continue;
            }
            $data = reset($sequence);
            if ($data['type'] === 'id-at-surname') {
                $surName = $data['value']['utf8String'];
            }
            if ($data['type'] === 'id-at-givenName') {
                $givenName = $data['value']['utf8String'];
            }
        }
        foreach ($cert['tbsCertificate']['extensions'] as $extension) {
            if ($extension['extnId'] !== "id-ce-subjectAltName") {
                continue;
            }

            foreach ($extension['extnValue'] as $value) {
                if (!isset($value['otherName']) || $value['otherName']['type-id'] !== self::OID_IA5STRING) {
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
                $user = [
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
        if ($user === null) {
            throw new UziException('No valid UZI data found');
        }
        return $user;
    }
}
