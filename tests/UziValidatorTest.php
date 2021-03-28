<?php

namespace MinVWS\PUZI\Tests;

use MinVWS\PUZI\Exceptions\UziAllowedRoleException;
use MinVWS\PUZI\Exceptions\UziAllowedTypeException;
use MinVWS\PUZI\Exceptions\UziCaException;
use MinVWS\PUZI\Exceptions\UziVersionException;
use MinVWS\PUZI\UziConstants;
use MinVWS\PUZI\UziValidator;
use MinVWS\PUZI\UziUser;
use PHPUnit\Framework\TestCase;

/**
 * Class UziValidatorTest
 * SPDX-License-Identifier: EUPL-1.2
 * @package MinVWS\PUZI\Tests
 */
final class UziValidatorTest extends TestCase
{
    public function testValidateIncorectOID(): void
    {
        $user = new UziUser();
        $user->setOidCa("1.2.3.4");

        $this->expectException(UziCaException::class);
        $this->expectExceptionMessage("CA OID not UZI register");

        $validator = new UziValidator(true, [], []);
        $validator->validate($user);
    }

    public function testIncorrectVersion(): void
    {
        $user = new UziUser();
        $user->setOidCa(UziConstants::OID_CA_CARE_PROVIDER);
        $user->setUziVersion("123");

        $this->expectException(UziVersionException::class);
        $this->expectExceptionMessage("UZI version not 1");

        $validator = new UziValidator(true, [], []);
        $validator->validate($user);
    }

    public function testNotAllowedType(): void
    {
        $user = new UziUser();
        $user->setOidCa(UziConstants::OID_CA_CARE_PROVIDER);
        $user->setUziVersion("1");
        $user->setCardType(UziConstants::UZI_TYPE_SERVER);

        $this->expectException(UziAllowedTypeException::class);
        $this->expectExceptionMessage("UZI card type not allowed");

        $validator = new UziValidator(true, [UziConstants::UZI_TYPE_CARE_PROVIDER], []);
        $validator->validate($user);
    }

    public function testNotAllowedRole(): void
    {
        $user = new UziUser();
        $user->setOidCa(UziConstants::OID_CA_CARE_PROVIDER);
        $user->setUziVersion("1");
        $user->setCardType(UziConstants::UZI_TYPE_CARE_PROVIDER);
        $user->setRole(UziConstants::UZI_ROLE_DENTIST);

        $this->expectException(UziAllowedRoleException::class);
        $this->expectExceptionMessage("UZI card role not allowed");

        $validator = new UziValidator(true, [UziConstants::UZI_TYPE_CARE_PROVIDER], [UziConstants::UZI_ROLE_NURSE]);
        $validator->validate($user);
    }

    public function testIsValid(): void
    {
        $user = new UziUser();
        $user->setOidCa(UziConstants::OID_CA_CARE_PROVIDER);
        $user->setUziVersion("1");
        $user->setCardType(UziConstants::UZI_TYPE_CARE_PROVIDER);
        $user->setRole(UziConstants::UZI_ROLE_DENTIST);

        $validator = new UziValidator(true, [UziConstants::UZI_TYPE_CARE_PROVIDER], [UziConstants::UZI_ROLE_DENTIST]);
        $this->assertTrue($validator->isValid($user));

        $user->setRole(UziConstants::UZI_ROLE_PHARMACIST);
        $this->assertFalse($validator->isValid($user));
    }
}
