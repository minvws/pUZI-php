<?php

namespace MinVWS\PUZI\Tests;

use MinVWS\PUZI\Exceptions\UziAllowedRoleException;
use MinVWS\PUZI\Exceptions\UziAllowedTypeException;
use MinVWS\PUZI\Exceptions\UziCaException;
use MinVWS\PUZI\Exceptions\UziCertificateException;
use MinVWS\PUZI\Exceptions\UziVersionException;
use MinVWS\PUZI\UziConstants;
use MinVWS\PUZI\UziReader;
use MinVWS\PUZI\UziValidator;
use MinVWS\PUZI\UziUser;
use PHPUnit\Framework\TestCase;
use Symfony\Component\HttpFoundation\Request;

/**
 * Class UziValidatorTest
 * SPDX-License-Identifier: EUPL-1.2
 * @package MinVWS\PUZI\Tests
 */
final class UziValidatorTest extends TestCase
{
    public function testSSLClientVerifyMissing(): void
    {
        $request = new Request();

        $this->expectException(UziCertificateException::class);
        $this->expectExceptionMessage("Webserver client cert check not passed");

        $reader = new UziReader();
        $validator = new UziValidator($reader, true, [], []);
        $validator->validate($request);
    }

    public function testNoClientCertPresented(): void
    {
        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");

        $this->expectException(UziCertificateException::class);
        $this->expectExceptionMessage("No client certificate presented");

        $reader = new UziReader();
        $validator = new UziValidator($reader, true, [], []);
        $validator->validate($request);
    }

    public function testInvalidCert(): void
    {
        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-001-no-valid-uzi-data.cert'));

        $this->expectException(UziCertificateException::class);
        $this->expectExceptionMessage("No UZI data found in certificate");

        $reader = new UziReader();
        $validator = new UziValidator($reader, true, [], []);
        $validator->validate($request);
    }

    public function testValidateIncorectOIDca(): void
    {
        $user = new UziUser();
        $user->setOidCa("1.2.3.4");

        $this->expectException(UziCaException::class);
        $this->expectExceptionMessage("CA OID not UZI register Care Provider or named employee");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-020-incorrect-oidca.cert'));

        $reader = new UziReader();
        $validator = new UziValidator($reader, true, [], []);
        $validator->validate($request);
    }

    public function testValidateIncorectOIDcaWithoutStrictCheck(): void
    {
        $user = new UziUser();
        $user->setOidCa("1.2.3.4");

        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-020-incorrect-oidca.cert'));

        $reader = new UziReader();
        $validator = new UziValidator(
            $reader,
            false,
            [UziConstants::UZI_TYPE_NAMED_EMPLOYEE],
            [UziConstants::UZI_ROLE_DOCTOR]
        );
        $this->assertTrue($validator->isValid($request));
    }

    public function testIncorrectVersion(): void
    {
        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set(
            'SSL_CLIENT_CERT',
            file_get_contents(__DIR__ . '/certs/mock-021-incorrect-uzi-version.cert')
        );

        $this->expectException(UziVersionException::class);
        $this->expectExceptionMessage("UZI version not 1");

        $reader = new UziReader();
        $validator = new UziValidator($reader, true, [], []);
        $validator->validate($request);
    }

    public function testNotAllowedType(): void
    {
        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-011-correct.cert'));

        $this->expectException(UziAllowedTypeException::class);
        $this->expectExceptionMessage("UZI card type not allowed");

        $reader = new UziReader();
        $validator = new UziValidator($reader, true, [UziConstants::UZI_TYPE_SERVER], []);
        $validator->validate($request);
    }

    public function testNotAllowedRole(): void
    {
        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-011-correct.cert'));

        $this->expectException(UziAllowedRoleException::class);
        $this->expectExceptionMessage("UZI card role not allowed");

        $reader = new UziReader();
        $validator = new UziValidator(
            $reader,
            true,
            [UziConstants::UZI_TYPE_CARE_PROVIDER],
            [UziConstants::UZI_ROLE_PHARMACIST]
        );
        $validator->validate($request);
    }

    public function testIsValid(): void
    {
        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-011-correct.cert'));

        $reader = new UziReader();
        $validator = new UziValidator(
            $reader,
            true,
            [UziConstants::UZI_TYPE_CARE_PROVIDER],
            [UziConstants::UZI_ROLE_NURSE]
        );
        $this->assertTrue($validator->isValid($request));
    }

    public function testCallback(): void
    {
        $request = new Request();
        $request->server->set('SSL_CLIENT_VERIFY', "SUCCESS");
        $request->server->set('SSL_CLIENT_CERT', file_get_contents(__DIR__ . '/certs/mock-011-correct.cert'));

        $reader = new UziReader();
        $validator = new UziValidator(
            $reader,
            true,
            [UziConstants::UZI_TYPE_CARE_PROVIDER],
            [UziConstants::UZI_ROLE_NURSE],
            [],
            function (UziUser $info) {
                return false;
            }
        );
        $this->assertFalse($validator->isValid($request));
    }
}
