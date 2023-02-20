<?php

namespace MinVWS\PUZI;

use MinVWS\PUZI\Exceptions\UziAllowedRoleException;
use MinVWS\PUZI\Exceptions\UziAllowedTypeException;
use MinVWS\PUZI\Exceptions\UziCaException;
use MinVWS\PUZI\Exceptions\UziCardExpired;
use MinVWS\PUZI\Exceptions\UziCertificateException;
use MinVWS\PUZI\Exceptions\UziException;
use MinVWS\PUZI\Exceptions\UziVersionException;
use phpseclib3\File\X509;
use Symfony\Component\HttpFoundation\Request;

/**
 * Class UziValidator
 * @package MinVWS\Laravel\Puzi
 */
class UziValidator
{
    protected UziReader $reader;
    protected bool $strictCAcheck;
    protected array $allowedTypes;
    protected array $allowedRoles;
    protected array $caCerts = [];

    /** @var callable */
    protected $validatorCallback = null;

    public function __construct(
        UziReader $reader,
        bool $strictCaCheck,
        array $allowedTypes,
        array $allowedRoles,
        array $caCerts = [],
        callable $validatorCallback = null
    ) {
        $this->reader = $reader;
        $this->strictCAcheck = $strictCaCheck;
        $this->allowedTypes = $allowedTypes;
        $this->allowedRoles = $allowedRoles;
        $this->caCerts = $caCerts;
        $this->validatorCallback = $validatorCallback;
    }

    public function isValid(Request $request): bool
    {
        try {
            $this->validate($request);
        } catch (UziException $e) {
            return false;
        }

        return true;
    }

    public function validate(Request $request): void
    {
        if (!$request->server->has('SSL_CLIENT_VERIFY') || $request->server->get('SSL_CLIENT_VERIFY') !== 'SUCCESS') {
            throw new UziCertificateException('Webserver client cert check not passed');
        }
        if (!$request->server->has('SSL_CLIENT_CERT')) {
            throw new UziCertificateException('No client certificate presented');
        }

        $x509 = new X509();
        $x509->loadX509($request->server->get('SSL_CLIENT_CERT'));
        foreach ($this->caCerts as $caCert) {
            $x509->loadCA($caCert);
        }

        if ($this->strictCAcheck === false) {
            $x509->disableURLFetch();
        }

        $uziInfo = $this->reader->getDataFromRequest($request);
        if (!$uziInfo) {
            throw new UziCertificateException('No UZI data found in certificate');
        }

        if (
            $this->strictCAcheck === true &&
            $uziInfo->getOidCa() !== UziConstants::OID_CA_CARE_PROVIDER &&
            $uziInfo->getOidCa() !== UziConstants::OID_CA_NAMED_EMPLOYEE
        ) {
            throw new UziCaException('CA OID not UZI register Care Provider or named employee');
        }

        if (! $x509->validateSignature(count($this->caCerts) > 0)) {
            throw new UziCertificateException('Uzi certificate path not valid');
        }
        if (! $x509->validateDate()) {
            throw new UziCardExpired('Uzi card expired');
        }

        if ($uziInfo->getUziVersion() !== '1') {
            throw new UziVersionException('UZI version not 1');
        }
        if (!in_array($uziInfo->getCardType(), $this->allowedTypes)) {
            throw new UziAllowedTypeException('UZI card type not allowed');
        }

        // Check roles for care provider
        if ($uziInfo->getCardType() === UziConstants::UZI_TYPE_CARE_PROVIDER &&
            !in_array(substr($uziInfo->getRole(), 0, 3), $this->allowedRoles)) {
            throw new UziAllowedRoleException("UZI card role not allowed");
        }

        // If a specific callback is set, call it
        if ($this->validatorCallback && call_user_func($this->validatorCallback, $uziInfo) === false) {
            throw new UziException('Uzi certificate validation failed (callback returned false)');
        }
    }
}
