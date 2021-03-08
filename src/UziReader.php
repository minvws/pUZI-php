<?php

namespace MinVWS\PUZI;

use phpseclib3\File\X509;
use MinVWS\PUZI\Exceptions\UziException;
use Symfony\Component\HttpFoundation\Request;

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
     * @return UziUser
     * @throws UziException
     * @deprecated Use getDataFromRequest instead
     */
    public function getData(): UziUser
    {
        $request = Request::createFromGlobals();
        return $this->getDataFromRequest($request);
    }

    /**
     * @param Request $request
     * @return UziUser
     * @throws UziException
     */
    public function getDataFromRequest(Request $request): UziUser
    {
        if (!$request->server->has('SSL_CLIENT_VERIFY') || $request->server->get('SSL_CLIENT_VERIFY') !== 'SUCCESS') {
            throw new UziException('Webserver client cert check not passed');
        }
        if (!$request->server->has('SSL_CLIENT_CERT')) {
            throw new UziException('No client certificate presented');
        }

        $x509 = new X509();
        $cert = $x509->loadX509($request->server->get('SSL_CLIENT_CERT'));
        if (!isset($cert['tbsCertificate']['subject']['rdnSequence'])) {
            throw new UziException('No subject rdnSequence');
        }

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
        throw new UziException('No valid UZI data found');
    }
}
