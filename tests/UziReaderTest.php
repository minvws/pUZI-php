<?php

namespace MinVWS\PUZI\Tests;

use MinVWS\PUZI\Exceptions\UziCertificateException;
use MinVWS\PUZI\Exceptions\UziCertificateNotUziException;
use MinVWS\PUZI\UziReader;
use PHPUnit\Framework\TestCase;
use Symfony\Component\HttpFoundation\Request;

/**
 * Class UziReaderTest
 * SPDX-License-Identifier: EUPL-1.2
 * @package MinVWS\PUZI\Tests
 */
final class UziReaderTest extends TestCase
{
    public function testCheckRequestHasNoCert(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziCertificateException::class);
        $this->expectExceptionMessage("Webserver client cert check not passed");

        $request = new Request();
        $uzi->getDataFromRequest($request);
    }

    public function testCheckSSLClientFailed(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziCertificateException::class);
        $this->expectExceptionMessage("Webserver client cert check not passed");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "failed");

        $uzi->getDataFromRequest($request);
    }

    public function testCheckNoClientCert(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziCertificateException::class);
        $this->expectExceptionMessage("No client certificate presented");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");

        $uzi->getDataFromRequest($request);
    }

    public function testCheckCertWithoutValidData(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziCertificateNotUziException::class);
        $this->expectExceptionMessage("No valid UZI card found");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-001-no-valid-uzi-data.cert'));

        $uzi->getDataFromRequest($request);
    }

    public function testCheckCertWithInvalidSAN(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziCertificateNotUziException::class);
        $this->expectExceptionMessage("No valid UZI card found");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-002-invalid-san.cert'));

        $uzi->getDataFromRequest($request);
    }

    public function testCheckCertWithInvalidOtherName(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziCertificateNotUziException::class);
        $this->expectExceptionMessage("No valid UZI card found");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-003-invalid-othername.cert'));

        $uzi->getDataFromRequest($request);
    }

    public function testCheckCertWithoutIa5string(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziCertificateException::class);
        $this->expectExceptionMessage("No ia5String");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $cert = file_get_contents(__DIR__ . '/certs/mock-004-othername-without-ia5string.cert');
        $request->server->set('SSL_CLIENT_CERT', $cert);

        $uzi->getDataFromRequest($request);
    }

    public function testCheckCertIncorrectSanData(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziCertificateException::class);
        $this->expectExceptionMessage("Incorrect SAN found");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $cert = file_get_contents(__DIR__ . '/certs/mock-005-incorrect-san-data.cert');
        $request->server->set('SSL_CLIENT_CERT', $cert);

        $uzi->getDataFromRequest($request);
    }

    public function testCheckCertIncorrectSanData2(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziCertificateException::class);
        $this->expectExceptionMessage("Incorrect SAN found");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $cert = file_get_contents(__DIR__ . '/certs/mock-006-incorrect-san-data.cert');
        $request->server->set('SSL_CLIENT_CERT', $cert);

        $uzi->getDataFromRequest($request);
    }

    public function testCheckValidCert(): void
    {
        $uzi = new UziReader();

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-011-correct.cert'));

        $user = $uzi->getDataFromRequest($request);

        $this->assertEquals('00000000', $user->getAgbCode());
        $this->assertEquals('N', $user->getCardType());
        $this->assertEquals('john', $user->getGivenName());
        $this->assertEquals('2.16.528.1.1003.1.3.5.5.2', $user->getOidCa());
        $this->assertEquals('30.015', $user->getRole());
        $this->assertEquals('90000111', $user->getSubscriberNumber());
        $this->assertEquals('doe-12345678', $user->getSurName());
        $this->assertEquals('12345678', $user->getUziNumber());
        $this->assertEquals('1', $user->getUziVersion());
    }

    public function testCheckValidAdminCert(): void
    {
        $uzi = new UziReader();

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-012-correct-admin.cert'));

        $user = $uzi->getDataFromRequest($request);

        $this->assertEquals('00000000', $user->getAgbCode());
        $this->assertEquals('N', $user->getCardType());
        $this->assertEquals('john', $user->getGivenName());
        $this->assertEquals('2.16.528.1.1003.1.3.5.5.2', $user->getOidCa());
        $this->assertEquals('01.015', $user->getRole());
        $this->assertEquals('90000111', $user->getSubscriberNumber());
        $this->assertEquals('doe-11111111', $user->getSurName());
        $this->assertEquals('11111111', $user->getUziNumber());
        $this->assertEquals('1', $user->getUziVersion());
    }
}
