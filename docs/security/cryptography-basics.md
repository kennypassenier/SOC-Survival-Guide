# Cryptography Basics

Cryptografie beschermt vertrouwelijkheid, integriteit en authenticiteit van data. Als SOC-analist ben je geen cryptograaf, maar je moet wel herkennen wat versleuteld, gehasht of alleen gecodeerd is.

## Concepts

### Begrippen

- **Plaintext en ciphertext:** leesbare data tegenover versleutelde, onleesbare data.
- **Cipher en sleutel:** het algoritme en het geheim dat het aanstuurt.
- **Kerckhoffs' principe:** de veiligheid moet berusten op de geheimhouding van de **sleutel**, nooit op het algoritme.

### Doelen (CIA)

| Doel | Betekenis | Middel |
| :--- | :--- | :--- |
| **Confidentiality** | Alleen bevoegden kunnen lezen | Encryptie |
| **Integrity** | Data is niet gewijzigd | Hashfuncties, handtekeningen |
| **Authenticity** | De afzender is wie hij zegt te zijn | Digitale handtekeningen, certificaten |

### Encoding, encryptie en hashing

| Methode | Omkeerbaar | Sleutel | Doel |
| :--- | :--- | :--- | :--- |
| **Encoding** (Base64) | Ja | Nee | Data transporteerbaar maken |
| **Encryptie** (AES, RSA) | Ja, met sleutel | Ja | Vertrouwelijkheid |
| **Hashing** (SHA-256) | Nee | Nee | Integriteit, vingerafdruk |

::: warning Base64 is geen beveiliging
Iedereen kan Base64 zonder sleutel decoderen. Aanvallers gebruiken het veel om payloads te verbergen in scripts en logs.
:::

### Symmetrisch versus asymmetrisch

| Eigenschap | [Symmetrisch](/security/symmetric-cryptography) | [Asymmetrisch](/security/asymmetric-cryptography) |
| :--- | :--- | :--- |
| Sleutels | Eén gedeelde sleutel | Publiek en privaat key pair |
| Snelheid | Snel | Langzaam |
| Probleem | Key exchange | Rekenkracht en key management |
| Voorbeeld | AES | RSA, Ed25519 |

In de praktijk gebruikt TLS beide: asymmetrisch om een sleutel af te spreken en symmetrisch voor de data. Zie ook [Hashfuncties](/security/cryptographic-hash-functions).

## Commands

Parameters staan bij [base64 & tr](/scripting/bash#sh-base64) en [openssl](/scripting/bash#sh-openssl).

<<< @/snippets/bash/processing.sh#encoding{bash}
