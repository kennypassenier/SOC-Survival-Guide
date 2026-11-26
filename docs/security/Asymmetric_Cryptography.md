# Asymmetric Cryptography

Asymmetrische cryptografie, publieke en private sleutels, en digitale ondertekening.

## 1. Commando's & Sleutelbeheer

### OpenSSL Sleutelbeheer
* **`openssl genpkey`**: Genereert een private sleutel (`-algorithm rsa` of `ED25519`).
* **`openssl rsa`**: Leidt de publieke sleutel af (`-pubout`).
* **`openssl pkeyutl`**: Versleutelt (`-encrypt`) of ontsleutelt (`-decrypt`) data.

<<< @/snippets/bash/cryptographyKeeperScript.sh#asymmetric{bash}

## 2. Sleutelparen & Eigenschappen

| Bewerking | Sleutel Verzender | Sleutel Ontvanger | Doel |
| :--- | :--- | :--- | :--- |
| **Versleutelen** | Publieke Sleutel | Private Sleutel | **Vertrouwelijkheid** (Confidentiality) |
| **Ondertekenen** | Private Sleutel | Publieke Sleutel | **Authenticiteit & Non-repudiation** |

## 3. PKI en Certificaten
- **Digitaal Certificaat**: Koppelt een publieke sleutel aan een identiteit, uitgegeven door een vertrouwde *Certificate Authority* (CA).
- **Public Key Infrastructure (PKI)**: Het ecosysteem voor het beheren en distribueren van certificaten.
