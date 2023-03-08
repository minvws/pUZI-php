![pUZI logo](pUZI.svg "pUZI logo" )
# pUZI php

[![PHP](https://github.com/minvws/pUZI-php/actions/workflows/test.yml/badge.svg)](https://github.com/minvws/pUZI-php/actions/workflows/test.yml)

Proficient UZI pass reader in php.

The UZI card is part of an authentication mechanism for medical staff and doctors working in the Netherlands. The cards are distributed by the CIBG. More information and the relevant client software can be found at www.uziregister.nl (in Dutch).

pUZI is a simple and functional module which allows you to use the UZI cards as authentication mechanism. It consists of:

1. a reader that interprets the PKCS11 data the card middleware provides to the webserver and returns an UziUser object in return (this repository).
2. middleware (currently only for the Laravel framework) that allows authentication and user creation based on UZI cards.

For documentation, software and to apply for an UZI card, please check out [www.uziregister.nl](https://www.uziregister.nl).

pUZI is available under the EU PL licence. It was created early 2021 during the COVID19 campaign as part of the vaccination registration project BRBA for the ‘Ministerie van Volksgezondheid, Welzijn & Sport, programma Realisatie Digitale Ondersteuning.’

Questions and contributions are welcome via [GitHub](https://github.com/minvws/pUZI-php/issues).

## Requirements

* PHP >= 7.4

Apache config (or NginX equivalent):
```apacheconf
SSLEngine on
SSLProtocol -all +TLSv1.3
SSLHonorCipherOrder on
SSLCipherSuite ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384
SSLVerifyClient require
SSLVerifyDepth 3
SSLCACertificateFile /path/to/uziCA.crt
SSLOptions +StdEnvVars +ExportCertData
```

## Installation

### Composer

```sh
composer require minvws/puzi-php
```

### Manual

Add the following to your `composer.json` and then run `composer install`.

```json
{
    "require": {
        "minvws/puzi-php": "^v2.0"
    }
}
```

## Usage

```php

// Request from your framework/controller
$uzi = new \MinVWS\PUZI\UziReader();
$user = $uzi->getDataFromRequest($request);
print $user->getUziNumber();

// In case of no request (deprecated):
$uzi = new \MinVWS\PUZI\UziReader();
$user = $uzi->getData();

print $user->getUziNumber();
var_dump($user->toArray());
```

```text
array(9) {
  'agb_code' =>
  string(8) "00000000"
  'card_type' =>
  string(1) "N"
  'given_name' =>
  string(4) "john"
  'oid_ca' =>
  string(25) "2.16.528.1.1003.1.3.5.5.2"
  'role' =>
  string(6) "01.015"
  'subscriber_number' =>
  string(6) "90000111"
  'sur_name' =>
  string(12) "doe-11111111"
  'uzi_number' =>
  string(8) "11111111"
  'uzi_version' =>
  string(1) "1"
  'serial_number' =>
  string(8) "11111111"
}
```

This package also allows validation of the request:

```php
$allowedTypes = [
    UziConstants::UZI_TYPE_CARE_PROVIDER,
    UziConstants::UZI_TYPE_NAMED_EMPLOYEE,
];
$allowedRoles = [
    UziConstants::UZI_ROLE_DOCTOR,    
    UziConstants::UZI_ROLE_PHARMACIST,    
];

$validator = new UziValidator(new UziReader(), true, $allowedTypes, $allowedRoles);
if ($validator->isValid($request)) {
    print "Validated as doctor or pharmasist";
}
```

You can use either `isValid()`, which returns a boolean, or `validate()` which throws an exception when 
not correctly validated.

## Uses

* phpseclib - [PHP Secure Communications Library](https://phpseclib.com/)

## Used by

* puzi-laravel - [Laravel wrapper for proficient UZI pass reader](https://github.com/minvws/pUZI-laravel) for Laravel 8 or later.
* puzi-auth-bundle - [UZI authentication bundle for Symfony](https://github.com/minvws/puzi-auth-bundle) for Symfony 4 or later.

## Alternatives

* Python - [pUZI-python](https://github.com/minvws/pUZI-python)
* Go - [go-uzi-middleware](https://github.com/minvws/go-uzi-middleware)
* .NET - [UZI Card Authentication Server](https://github.com/hiddehs/UZI-Card-Authentication)

## Contributing

1. Fork the Project

2. Ensure you have Composer installed (see [Composer Download Instructions](https://getcomposer.org/download/))

3. Install Development Dependencies

    ```sh
    composer install
    ```

4. Create a Feature Branch

5. (Recommended) Run the Test Suite

    ```sh
    vendor/bin/phpunit
    ```
   
6. (Recommended) Check whether your code conforms to our Coding Standards by running

    ```sh
    vendor/bin/phpstan analyse
    vendor/bin/psalm
    vendor/bin/phpcs
    ```

7. Send us a Pull Request
   
![pUZI](pUZI-hidden.svg "pUZI")
