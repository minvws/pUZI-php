# pUZI php

Proficient UZI pass reader in php.

## Requirements

* PHP >= 7.3

## Usage

```php
$uzi = new \MinVWS\PUZI\UziReader;
$data = $uzi->getData();
var_dump($data);
```

```text

```

## Uses

[PHP Secure Communications Library](https://phpseclib.com/)

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