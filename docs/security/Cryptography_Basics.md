# Cryptography Basics

Fundamentele cryptografische concepten, ciphers en symmetrische versus asymmetrische versleuteling.

## 1. Commando's & Scripts

### Python & OpenSSL Cryptografie
* **`python3 caesar.py`**: Start een interactief Caesar Cipher-script.
* **`openssl enc`**: Symmetrische encryptie en decryptie.

<<< @/snippets/bash/cryptographyKeeperScript.sh#caesar{bash}

## 2. Kernconcepten
- **Plaintext vs. Ciphertext**: Leesbare data versus versleutelde onleesbare data.
- **Cipher & Sleutel**: Het algoritme en de geheime sleutel die versleuteling aansturen.
- **Kerckhoffs' Principe**: Beveiliging moet uitsluitend berusten op de geheimhouding van de **sleutel**, nooit op het algoritme.

## 3. Symmetrisch versus Asymmetrisch
- **Symmetrisch**: Eén gedeelde sleutel voor encryptie en decryptie (snel, bijv. AES).
- **Asymmetrisch**: Twee gekoppelde sleutels (publiek en privaat), bijv. RSA.
