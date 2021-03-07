<?php

use MinVWS\PUZI\Exceptions\UziException;
use MinVWS\PUZI\UziReader;
use PHPUnit\Framework\TestCase;

/**
 * Class UziReaderTest.
 */
final class UziReaderTest extends TestCase
{
    public function testCheckRequestHasNoCert(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("Apache client cert check not passed");

        $uzi->getData();
    }

    public function testCheckSSLClientFailed(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("Apache client cert check not passed");

        $_SERVER['SSL_CLIENT_VERIFY'] = "failed";
        $uzi->getData();
    }

    public function testCheckNoClientCert(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("No client certificate presented");

        $_SERVER['SSL_CLIENT_VERIFY'] = "SUCCESS";

        $uzi->getData();
    }

    public function testCheckCertWithoutValidData(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("No valid UZI data found");

        $_SERVER['SSL_CLIENT_VERIFY'] = "SUCCESS";
        $_SERVER['SSL_CLIENT_CERT'] = file_get_contents(__DIR__ . '/certs/mock-001-no-valid-uzi-data.cert');

        $uzi->getData();
    }

    public function testCheckCertWithInvalidSAN(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("No valid UZI data found");

        $_SERVER['SSL_CLIENT_VERIFY'] = "SUCCESS";
        $_SERVER['SSL_CLIENT_CERT'] = file_get_contents(__DIR__ . '/certs/mock-002-invalid-san.cert');

        $uzi->getData();
    }

    public function testCheckCertWithInvalidOtherName(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("No valid UZI data found");

        $_SERVER['SSL_CLIENT_VERIFY'] = "SUCCESS";
        $_SERVER['SSL_CLIENT_CERT'] = file_get_contents(__DIR__ . '/certs/mock-003-invalid-othername.cert');

        $uzi->getData();
    }

    public function testCheckCertWithoutIa5string(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("No ia5String");

        $_SERVER['SSL_CLIENT_VERIFY'] = "SUCCESS";
        $_SERVER['SSL_CLIENT_CERT'] = file_get_contents(__DIR__ . '/certs/mock-004-othername-without-ia5string.cert');

        $uzi->getData();
    }

    public function testCheckCertIncorrectSanData(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("Incorrect SAN found");

        $_SERVER['SSL_CLIENT_VERIFY'] = "SUCCESS";
        $_SERVER['SSL_CLIENT_CERT'] = file_get_contents(__DIR__ . '/certs/mock-005-incorrect-san-data.cert');

        $uzi->getData();
    }

    public function testCheckCertIncorrectSanData2(): void
    {
        $uzi = new UziReader();

        $this->expectException(UziException::class);
        $this->expectExceptionMessage("Incorrect SAN found");

        $_SERVER['SSL_CLIENT_VERIFY'] = "SUCCESS";
        $_SERVER['SSL_CLIENT_CERT'] = file_get_contents(__DIR__ . '/certs/mock-006-incorrect-san-data.cert');

        $uzi->getData();
    }

    public function testCheckValidCert(): void
    {
        $uzi = new UziReader();

        $_SERVER['SSL_CLIENT_VERIFY'] = "SUCCESS";
        $_SERVER['SSL_CLIENT_CERT'] = file_get_contents(__DIR__ . '/certs/mock-011-correct.cert');

        $data = $uzi->getData();
        $this->assertEquals([
            'givenName' => 'john',
            'surName' => 'doe-12345678',
            'OidCa' => '2.16.528.1.1003.1.3.5.5.2',
            'UziVersion' => '1',
            'UziNumber' => '12345678',
            'CardType' => 'N',
            'SubscriberNumber' => '90000111',
            'Role' => '30.015',
            'AgbCode' => '00000000',
        ], $data);
    }

    public function testCheckValidAdminCert(): void
    {
        $uzi = new UziReader();

        $_SERVER['SSL_CLIENT_VERIFY'] = "SUCCESS";
        $_SERVER['SSL_CLIENT_CERT'] = file_get_contents(__DIR__ . '/certs/mock-012-correct-admin.cert');

        $data = $uzi->getData();
        $this->assertEquals([
            'givenName' => 'john',
            'surName' => 'doe-11111111',
            'OidCa' => '2.16.528.1.1003.1.3.5.5.2',
            'UziVersion' => '1',
            'UziNumber' => '11111111',
            'CardType' => 'N',
            'SubscriberNumber' => '90000111',
            'Role' => '01.015',
            'AgbCode' => '00000000',
        ], $data);
    }
}
