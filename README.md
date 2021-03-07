# pUZI php
[![PHP](https://github.com/annejan/pUZI-php/actions/workflows/test.yml/badge.svg)](https://github.com/annejan/pUZI-php/actions/workflows/test.yml)

Proficient UZI pass reader in php.

## Requirements

* PHP >= 7.3

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
        "minvws/puzi-php": "^0.1"
    }
}
```

## Usage

```php
$uzi = new \MinVWS\PUZI\UziReader;
$data = $uzi->getData();
var_dump($data);
```

```text
array(9) {
  'givenName' =>
  string(4) "john"
  'surName' =>
  string(12) "doe-11111111"
  'OidCa' =>
  string(25) "2.16.528.1.1003.1.3.5.5.2"
  'UziVersion' =>
  string(1) "1"
  'UziNumber' =>
  string(8) "11111111"
  'CardType' =>
  string(1) "N"
  'SubscriberNumber' =>
  string(8) "90000111"
  'Role' =>
  string(6) "01.015"
  'AgbCode' =>
  string(8) "00000000"
}
```

## Uses

phpseclib - [PHP Secure Communications Library](https://phpseclib.com/)

## Used by

puzi-laravel - [Laravel wrapper for proficient UZI pass reader](https://github.com/annejan/pUZI-laravel) for Laravel 6, 7 and 8.

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
    vVendor/bin/phpcs
    ```

7. Send us a Pull Request