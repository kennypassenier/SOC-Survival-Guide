# Cryptography Basics

## 1. Overzicht van Relevante Commando's & Tools

### A. Python Script-uitvoering (`caesar.py`)

#### `python3`
* **Doel:** Start de Python 3-interpreter of voert een Python-script uit (zoals het interactieve `caesar.py`-programma voor Caesar Cipher encryptie, decryptie en cryptanalyse).
* **Praktijkgebruik:**
  ```bash
  # Start het interactieve Caesar Cipher-script in de terminal
  python3 caesar.py
  ```
* **Tips, Best Practices & Valkuilen:**
  * In het `caesar.py`-programma activeert alleen exact het woord `encrypt` de versleutelmodus; elke andere invoer schakelt het script direct over naar de `decrypt`-modus.
  * Alleen de 26 alfabetische letters (`A-Z`) worden verschoven; cijfers, spaties en leestekens (zoals `!`) blijven ongewijzigd en hoofdletters worden standaard omgezet naar hoofdletters in de uitvoer.
  * **[Aanvullend] OS-verschillen & Modernere Mogelijkheden (Linux & Windows):**
    * **Debian / Ubuntu vs. Arch Linux:** Op Arch Linux verwijst `python` standaard al naar Python 3 (al werkt `python3` ook). Op Debian/Ubuntu is `python3` het standaardcommando (voor `python` zonder `3` is het pakket `python-is-python3` nodig).
    * **Windows (CMD & PowerShell):** Gebruik `python caesar.py` of de Windows Python Launcher `py caesar.py`.

### B. [Aanvullend] Relevante CLI-tools voor Cryptografie, Hashing & Encoding

Voor System Admins en SOC-analisten volstaat een simpele shift-cipher niet in de praktijk. Onderstaande standaard CLI-tools worden dagelijks gebruikt voor symmetrische/asymmetrische encryptie, certificaatinspectie en bestandshashing:

* **Linux (Debian/Ubuntu & Arch):**
  * `openssl`: De Zwitserse zakmes-tool voor moderne cryptografie op de CLI:
    * Symmetrisch versleutelen met AES-256: `openssl enc -aes-256-cbc -salt -pbkdf2 -in geheim.txt -out geheim.enc` (`-e` = encrypt, `-d` = decrypt, `-pbkdf2` = moderne key-derivation).
    * RSA-sleutelpaar genereren (4096-bit): `openssl genpkey -algorithm RSA -out private.pem -pkeyopt rsa_keygen_bits:4096`.
    * TLS-certificaat inspecteren: `openssl x509 -in cert.pem -text -noout`.
  * `sha256sum`: Berekent en controleert cryptografische SHA-256-hashes voor bestandsintegriteit (`sha256sum bestand.bin`).
  * `tr` (snelle Caesar/ROT13-transformatie op de CLI): `echo "Bring Caesar a Salad!" | tr 'A-Za-z' 'F-ZA-Ef-za-e'` (shift 5).
* **Windows (PowerShell & CMD):**
  * **PowerShell:** `Get-FileHash -Path .\bestand.bin -Algorithm SHA256` (modern equivalent van `sha256sum`) en `New-SelfSignedCertificate` / `Get-PfxCertificate` voor certificaatbeheer.
  * **CMD:** `certutil -hashfile bestand.bin SHA256` (ingebouwde Windows-tool voor hashing en Base64-encoding/decoding via `certutil -encode` en `certutil -decode`).

---

## 2. Algemene Uitleg & Theorie

### Basisconcepten van Cryptografie
* **Cryptografie:** De wiskundige wetenschap die leesbare gegevens (**plaintext**) omzet in onleesbare, versleutelde gegevens (**ciphertext**).
* **Encryption & Decryption:**
  * **Encryption (Versleutelen):** Het proces waarbij *plaintext* wordt omgezet in *ciphertext* zodat onbevoegden de inhoud niet kunnen lezen of begrijpen.
  * **Decryption (Ontsleutelen):** Het omgekeerde proces waarbij *ciphertext* weer wordt teruggezet naar de oorspronkelijke leesbare *plaintext*.
* **Cipher & Cryptographic Key:**
  * **Cipher:** Het gespecialiseerde wiskundige algoritme dat de versleuteling en ontsleuteling uitvoert.
  * **Cryptographic Key (Sleutel):** Een stuk informatie dat als invoer dient voor de cipher om *plaintext* te coderen naar *ciphertext* of omgekeerd te decoderen.
* **Doel van Cryptografie:** Het waarborgen van **vertrouwelijkheid (confidentiality / privacy)** tussen twee communicerende partijen, zelfs wanneer een derde partij het dataverkeer onderschept (tenzij die derde partij zowel de cipher als de sleutel bezit).

### Historische Voorbeelden: Caesar Cipher & Enigma
* **Caesar Cipher (Shift Cipher):** Een eenvoudige substitutie-cipher waarbij elke letter uit het alfabet wordt vervangen door de letter die $n$ posities verder naar rechts staat (met een sleutel $n$ tussen `0` en `25`).
  * *Voorbeeld (sleutel = 3):* `A` wordt `D`, `B` wordt `E`. De versleutelde tekst `"frph phhw ph!"` wordt met sleutel `3` ontsleuteld naar `"Come see me!"` (of `"come meet me!"`).
* **Enigma-machine (WO II):** Duitse strijdkrachten gebruikten tijdens de Tweede Wereldoorlog een complexe elektromechanische cipher-machine (de *Enigma*) om berichten te coderen. Ontsleutelen was alleen mogelijk met de exacte rotor- en stekkerinstellingen. De Enigma-code werd uiteindelijk gekraakt, eerst door de Poolse wiskundige **Marian Rejewski** en later door **Alan Turing**, wat de geallieerden een doorslaggevend strategisch voordeel gaf tegen Duitse U-boten.

### Moderne Cryptografie: Symmetrisch vs. Asymmetrisch
* **Sleutellengtes & Wiskunde:** Moderne cryptografische sleutels zijn pseudo-willekeurige reeksen bits, doorgaans met een lengte van **128 bits tot 4096 bits**. Deze sleutel wordt gecombineerd met een algoritme (meestal gebaseerd op modulaire rekenkunde en **XOR**-operaties) om *plaintext* om te zetten in *ciphertext*.
* **Het kernverschil:** Moderne cryptografische algoritmen worden verdeeld in twee hoofdcategorieën op basis van het **aantal gebruikte sleutels**:

| Eigenschap | Symmetrische Cryptografie | Asymmetrische Cryptografie (Public Key) |
| :--- | :--- | :--- |
| **Aantal sleutels** | **1 gedeelde sleutel** (dezelfde geheime sleutel voor zowel encryptie als decryptie). | **2 wiskundig gekoppelde sleutels** (een publieke sleutel voor encryptie en een privésleutel voor decryptie). |
| **Snelheid & Gebruik** | Zeer snel; ideaal voor grote hoeveelheden data (schijfencryptie, VPN-tunnels, TLS-sessiedata). | Trager door complexe wiskunde; gebruikt voor sleuteluitwisseling, digitale handtekeningen en authenticatie. |
| **Voorbeelden** | AES, ChaCha20, 3DES, RC4 | RSA, ECC (Elliptic Curve), Diffie-Hellman |

* **[Aanvullend] Kerckhoffs' Principe & Security Best Practice:** Moderne cryptografie vertrouwt nooit op het geheimhouden van het algoritme zelf (*Security through Obscurity*), maar uitsluitend op het geheimhouden van de **sleutel**. Gebruik in productie nooit zelfgeschreven ciphers of verouderde algoritmen zoals DES, 3DES of RC4; gebruik gevestigde standaarden zoals **AES-256** (symmetrisch) en **RSA-2048/4096** of **ECC** (asymmetrisch).

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Bericht Versleutelen & Ontsleutelen met Sleutel (`caesar.py`)
Het uitvoeren van een gecontroleerde encryptie- en decryptiecyclus met een vooraf gedeelde geheime sleutel:

1. **Start het Python-script vanuit de terminal:**
   ```bash
   python3 caesar.py
   ```
2. **Versleutel het bericht (Encryption):**
   * Kies de modus: typ `encrypt` en druk op Enter.
   * Voer de *plaintext* in: `Bring Caesar a Salad!`
   * Voer de sleutel in: `5`
   * Kopieer de gegenereerde *ciphertext* uit de terminal.
   * *Aandachtspunt:* Let op dat leestekens zoals `!` en spaties onveranderd blijven en dat alle letters in hoofdletters worden weergegeven.
3. **Ontsleutel het bericht met de bekende sleutel (Decryption):**
   * Start opnieuw met `python3 caesar.py` en kies `decrypt`.
   * Plak de gekopieerde *ciphertext*.
   * Beantwoord de vraag *"Do you have the key?"* met `y` en voer sleutel `5` in.
   * De oorspronkelijke boodschap (`BRING CAESAR A SALAD!`) verschijnt weer.

### Scenario 2: Cryptanalyse via Brute-Force Zonder Sleutel (`caesar.py`)
Wanneer je als analist een versleuteld bericht onderschept zonder over de sleutel te beschikken, pas je **cryptanalyse** toe (het breken van versleutelde berichten):

1. **Start de decryptie-modus zonder sleutel:**
   ```bash
   python3 caesar.py
   ```
   * Kies `decrypt` en voer de onderschepte *ciphertext* in: `SLAAJ AFAAJ`.
   * Beantwoord de vraag *"Do you have the key?"* met `n` (nee).
2. **Analyseer de uitvoer van alle mogelijke sleutels:**
   * Omdat het alfabet slechts 26 letters telt (sleutels `0` t/m `25`), is de *keyspace* extreem klein. Het script probeert automatisch alle 26 mogelijke verschuivingen (*brute-force*).
   * Zoek in de lijst naar de enige leesbare Engelse tekstregel (`HELLO THERE` bij de juiste verschuiving).
   * *Valkuil:* Dit toont direct waarom een kleine sleutelruimte (*keyspace*) onveilig is: moderne ciphers gebruiken sleutels van minimaal 128 tot 4096 bits zodat een dergelijke brute-force-aanval rekenkundig onmogelijk wordt.

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `BASH.md`, `CMD.md` en `PowerShell.md` voor Python-uitvoering en aanvullende cryptografische/hashing-commando's (`openssl`, `sha256sum`, `Get-FileHash`, `certutil`).
* **[Aanvullend] Officiële Documentatie & Hulpmiddelen:**
  * [OpenSSL Documentation](https://docs.openssl.org/) — Officiële documentatie voor symmetrische/asymmetrische encryptie, sleutelbeheer en certificaten.
  * [NIST Cryptographic Standards and Guidelines](https://csrc.nist.gov/projects/cryptographic-standards-and-guidelines) — Officiële standaarden voor AES, SHA-2/SHA-3, RSA en post-quantum cryptografie.
  * [CyberChef (GCHQ)](https://gchq.github.io/CyberChef/) — Onmisbare webtool voor SOC-analisten om snel encodings, XOR-operaties, Caesar/ROT-ciphers en encryptie te analyseren.