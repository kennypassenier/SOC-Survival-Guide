# Cryptographic Hash Functions

Cryptografische hashfuncties en bestandsintegriteit.

## 1. Commando's & Hashing

### Hashgeneratie
* **`openssl dgst`**: Berekent hashes (`-md5`, `-sha256`).
* **`sha256sum`** / **`md5sum`**: Linux native hash-tools.
* **`Get-FileHash`**: PowerShell hash-tool.

<<< @/snippets/bash/cryptographyKeeperScript.sh#hashing{bash}

## 2. Eigenschappen van Hashfuncties
- **Deterministisch**: Dezelfde invoer levert altijd dezelfde hash op.
- **Lawine-effect (*Avalanche Effect*)**: Een minimale wijziging in de invoer verandert de hash volledig.
- **Onomkeerbaar (*One-way*)**: Je kunt vanuit een hash de oorspronkelijke data niet terugrekenen.

## 3. Toepassingen
- **Bestandsintegriteit**: Controleren of gedownloade software ongewijzigd is.
- **Malware Analyse**: IOC's en bestandsvingerafdrukken opzoeken in VirusTotal.
- **Wachtwoordopslag**: Wachtwoorden worden gehasht (vaak met *salt*) opgeslagen.
