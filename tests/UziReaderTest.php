<?php

namespace MinVWS\PUZI\Tests;

use MinVWS\PUZI\Exceptions\UziException;
use MinVWS\PUZI\UziReader;
use PHPUnit\Framework\TestCase;
use Symfony\Component\HttpFoundation\Request;

/**
 * Class UziReaderTest.
 */
final class UziReaderTest extends TestCase
{
    public function testCheckRequestHasNoCert(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("Webserver client cert check not passed");

        $request = new Request();
        $uzi->getDataFromRequest($request);
    }

    public function testCheckSSLClientFailed(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("Webserver client cert check not passed");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "failed");

        $uzi->getDataFromRequest($request);
    }

    public function testCheckNoClientCert(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("No client certificate presented");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");

        $uzi->getDataFromRequest($request);
    }

    public function testCheckCertWithoutValidData(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("No valid UZI data found");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-001-no-valid-uzi-data.cert'));

        $uzi->getDataFromRequest($request);
    }

    public function testCheckCertWithInvalidSAN(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("No valid UZI data found");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-002-invalid-san.cert'));

        $uzi->getDataFromRequest($request);
    }

    public function testCheckCertWithInvalidOtherName(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("No valid UZI data found");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-003-invalid-othername.cert'));

        $uzi->getDataFromRequest($request);
    }

    public function testCheckCertWithoutIa5string(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("No ia5String");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-004-othername-without-ia5string.cert'));

        $uzi->getDataFromRequest($request);
    }

    public function testCheckCertIncorrectSanData(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("Incorrect SAN found");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-005-incorrect-san-data.cert'));

        $uzi->getDataFromRequest($request);
    }

    public function testCheckCertIncorrectSanData2(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("Incorrect SAN found");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-006-incorrect-san-data.cert'));

        $uzi->getDataFromRequest($request);
    }

    public function testCheckValidCert(): void
    {
        $uzi = new UziReader();

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-011-correct.cert'));

        $user = $uzi->getDataFromRequest($request);
        $this->assertEquals('{"agb_code":"00000000","card_type":"N","given_name":"john","oid_ca":"2.16.528.1.1003.1.3.5.5.2","role":"30.015","subscriber_number":"90000111","sur_name":"doe-12345678","uzi_number":"12345678","uzi_version":"1"}', json_encode($user));
    }

    public function testCheckValidAdminCert(): void
    {
        $uzi = new UziReader();

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-012-correct-admin.cert'));

        $user = $uzi->getDataFromRequest($request);
        $this->assertEquals('{"agb_code":"00000000","card_type":"N","given_name":"john","oid_ca":"2.16.528.1.1003.1.3.5.5.2","role":"01.015","subscriber_number":"90000111","sur_name":"doe-11111111","uzi_number":"11111111","uzi_version":"1"}', json_encode($user));
    }
}
