<?php

namespace MinVWS\PUZI;

class UziUser implements \JsonSerializable
{
    /** @var string */
    protected $agb_code;
    /** @var string */
    protected $card_type;
    /** @var string */
    protected $given_name;
    /** @var string */
    protected $oid_ca;
    /** @var string */
    protected $role;
    /** @var string */
    protected $subscriber_number;
    /** @var string */
    protected $sur_name;
    /** @var string */
    protected $uzi_number;
    /** @var string */
    protected $uzi_version;

    /**
     * @return string
     */
    public function getAgbCode(): string
    {
        return $this->agb_code;
    }

    /**
     * @param string $agb_code
     */
    public function setAgbCode(string $agb_code): void
    {
        $this->agb_code = $agb_code;
    }

    /**
     * @return string
     */
    public function getCardType(): string
    {
        return $this->card_type;
    }

    /**
     * @param string $card_type
     */
    public function setCardType(string $card_type): void
    {
        $this->card_type = $card_type;
    }

    /**
     * @return string
     */
    public function getGivenName(): string
    {
        return $this->given_name;
    }

    /**
     * @param string $given_name
     */
    public function setGivenName(string $given_name): void
    {
        $this->given_name = $given_name;
    }

    /**
     * @return string
     */
    public function getOidCa(): string
    {
        return $this->oid_ca;
    }

    /**
     * @param string $oid_ca
     */
    public function setOidCa(string $oid_ca): void
    {
        $this->oid_ca = $oid_ca;
    }

    /**
     * @return string
     */
    public function getRole(): string
    {
        return $this->role;
    }

    /**
     * @param string $role
     */
    public function setRole(string $role): void
    {
        $this->role = $role;
    }

    /**
     * @return string
     */
    public function getSubscriberNumber(): string
    {
        return $this->subscriber_number;
    }

    /**
     * @param string $subscriber_number
     */
    public function setSubscriberNumber(string $subscriber_number): void
    {
        $this->subscriber_number = $subscriber_number;
    }

    /**
     * @return string
     */
    public function getSurName(): string
    {
        return $this->sur_name;
    }

    /**
     * @param string $sur_name
     */
    public function setSurName(string $sur_name): void
    {
        $this->sur_name = $sur_name;
    }

    /**
     * @return string
     */
    public function getUziNumber(): string
    {
        return $this->uzi_number;
    }

    /**
     * @param string $uzi_number
     */
    public function setUziNumber(string $uzi_number): void
    {
        $this->uzi_number = $uzi_number;
    }

    /**
     * @return string
     */
    public function getUziVersion(): string
    {
        return $this->uzi_version;
    }

    /**
     * @param string $uzi_version
     */
    public function setUziVersion(string $uzi_version): void
    {
        $this->uzi_version = $uzi_version;
    }

    /**
     * @return mixed|string[]
     */
    public function jsonSerialize()
    {
        return [
            'agb_code' => $this->getAgbCode(),
            'card_type' => $this->getCardType(),
            'given_name' => $this->getGivenName(),
            'oid_ca' => $this->getOidCa(),
            'role' => $this->getRole(),
            'subscriber_number' => $this->getSubscriberNumber(),
            'sur_name' => $this->getSurName(),
            'uzi_number' => $this->getUziNumber(),
            'uzi_version' => $this->getUziVersion()
        ];
    }
}
