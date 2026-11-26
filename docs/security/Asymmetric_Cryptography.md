# Asymmetric Cryptography

## 1. Overzicht van Relevante Commando's

### A. Cryptografie & Sleutelbeheer (`openssl`)

#### `openssl genpkey`
* **Doel:** Genereert een nieuwe private cryptografische sleutel voor een opgegeven algoritme (zoals RSA).
* **Parameters & Opties:**
  * `genpkey`: Subcommando voor *Generate Private Key* (de modernere standaard voor sleutelgeneratie in OpenSSL).
  * `-algorithm <naam>`: Specificeert het cryptografische algoritme (bijv. `rsa`).
  * `-out <bestand>`: Slaat de gegenereerde private sleutel op in het opgegeven bestand (bijv. `cybraryprivate.key`).
* **Praktijkgebruik:**
  ```bash
  # Genereer een nieuwe RSA private key
  openssl genpkey -algorithm rsa -out cybraryprivate.key
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * Deel een private sleutel (`*.key`) **nooit** met anderen. Zodra een private sleutel uitlekt, zijn zowel de vertrouwelijkheid als de authenticiteit/non-repudiation van al je berichten gecompromitteerd.
  * **[Aanvullend] Sleutellengte & Modernere Algoritmen:** Standaard genereert `openssl genpkey -algorithm rsa` een 2048-bit RSA-sleutel. Voor langdurige beveiliging kun je expliciet 4096 bits opgeven (`-pkeyopt rsa_keygen_bits:4096`) of kiezen voor modernere, snellere Elliptic Curve-cryptografie (**ECC**), zoals Ed25519 of P-256:
```bash
# Modern ECC-alternatief (kleinere sleutels, snellere berekening, hoge veiligheid)
openssl genpkey -algorithm ED25519 -out private_ed25519.key
```

#### `openssl rsa`
* **Doel:** Leidt vanuit een bestaande RSA private sleutel de bijbehorende wiskundig gekoppelde **publieke sleutel** af (of inspecteert/converteert RSA-sleutels).
* **Parameters & Opties:**
  * `rsa`: Subcommando voor het verwerken van RSA-sleutels.
  * `-pubout`: Geeft aan dat de uitvoer een **publieke sleutel** moet zijn in plaats van een private sleutel.
  * `-in <private_key>`: Het bronbestand met de private sleutel.
  * `-out <public_key>`: Het doelbestand waarin de afgeleide publieke sleutel wordt opgeslagen.
* **Praktijkgebruik:**
  ```bash
  # Leid de publieke sleutel af uit je private sleutel
  openssl rsa -pubout -in cybraryprivate.key -out cybrarypublic.key
  ```
* **[Aanvullend] Modernere Mogelijkheden:**
  * Het algemene, algoritme-onafhankelijke subcommando in nieuwere OpenSSL-versies is `openssl pkey -pubout -in cybraryprivate.key -out cybrarypublic.key` (werkt zowel voor RSA als voor ECC-sleutels).

#### `openssl pkeyutl`
* **Doel:** *Public Key Utility*: versleutelt data met de publieke sleutel van een ontvanger (`-encrypt` met `-pubin`) en ontsleutelt binaire ciphertext met je eigen private sleutel (`-decrypt`).
* **Parameters & Opties:**
  * `-encrypt`: Versleutelt de invoer naar binaire ciphertext.
  * `-decrypt`: Ontsleutelt binaire ciphertext terug naar leesbare plaintext.
  * `-inkey <sleutelbestand>`: Specificeert het te gebruiken sleutelbestand (publieke sleutel bij versleutelen, private sleutel bij ontsleutelen).
  * `-pubin`: Geeft expliciet aan dat het bestand achter `-inkey` een **publieke sleutel** is (verplicht bij versleutelen met een publieke sleutel).
  * `-in <invoerbestand>`: Het bronbestand dat versleuteld of ontsleuteld moet worden.
  * `-out <uitvoerbestand>`: Het doelbestand voor het resultaat (als `-out` bij `-decrypt` wordt weggelaten, wordt de ontsleutelde tekst direct naar standaarduitvoer in de terminal geprint).
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Versleutel een bericht met de publieke sleutel van de ontvanger (Sally)
  openssl pkeyutl -encrypt -inkey Downloads/sallypublic.key -pubin -in message.txt -out message.enc

  # Ontsleutel het ontvangen bericht met je eigen private sleutel naar een bestand
  openssl pkeyutl -decrypt -inkey sallyprivate.key -in message.enc -out message.txt

  # Ontsleutel en toon de inhoud direct op het scherm zonder uitvoerbestand
  openssl pkeyutl -decrypt -inkey sallyprivate.key -in message.enc
  ```
* **[Aanvullend] Digitale Handtekeningen & Windows-equivalenten:**
  * **Digitale handtekening maken & verifiëren (OpenSSL):**
```bash
# Onderteken een document met je private sleutel (via SHA-256 hash)
openssl dgst -sha256 -sign cybraryprivate.key -out message.sig message.txt

# Verifieer de handtekening met de publieke sleutel van de afzender
openssl dgst -sha256 -verify cybrarypublic.key -signature message.sig message.txt
```
  * **Windows (PowerShell & CMD):**
    * PowerShell: `Protect-CmsMessage -To "certificaat.cer" -Path .\message.txt -OutFile .\message.enc` en `Unprotect-CmsMessage -Path .\message.enc`.
    * Voor SSH-sleutelparen (ook asymmetrisch) bieden zowel moderne Windows-versies (CMD/PowerShell) als Linux (Debian/Arch) standaard `ssh-keygen -t ed25519`.

---

### B. Bestandsdistributie, Encoding & Gebruikerscontext

#### `sudo cp`
* **Doel:** Kopieert een bestand (zoals een publieke sleutel) naar een beveiligde systeemmap (zoals `/var/www/html` van de lokale webserver) waar standaardgebruikers geen schrijfrechten hebben.
* **Praktijkgebruik:**
  ```bash
  # Publiceer je publieke sleutel op de lokale webserver (/var/www/html)
  sudo cp cybrarypublic.key /var/www/html
  ```
* **Tips & Valkuilen:**
  * Kopieer **uitsluitend** je `.pub` / `public.key`-bestand naar `/var/www/html`, nooit je private sleutel (`private.key`).
  * **[Aanvullend] OS-verschillen (Debian vs. Arch):** `/var/www/html` is de standaard webroot voor Apache en Nginx op Debian/Ubuntu. Op Arch Linux is de standaard webroot voor Apache doorgaans `/srv/http` en voor Nginx `/usr/share/nginx/html`.

#### `base64`, `mail` & `su`
* **Doel:**
  * `base64`: Zet binaire ciphertext (`.enc`) om in veilige ASCII-tekst voor e-mailtransport en decodeert ontvangen Base64-strings terug (`base64 -d`).
  * `mail`: Verstuurt en leest lokale systeemberichten (`mail -s "Onderwerp" ontvanger`).
  * `su - <gebruiker>`: Wisselt naar een andere gebruikersaccount met een volledige login-shell (afsluiten met `exit`).
* **Praktijkgebruik:**
  ```bash
  # Codeer binaire ciphertext en verstuur per lokale mail
  base64 message.enc > message.base64
  cat message.base64 | mail -s "For Sally" sally

  # Wissel van gebruiker en decodeer ontvangen bericht
  su - sally
  base64 -d message.base64 > message.enc
  ```

---

## 2. Algemene Uitleg & Theorie

### Werking van Asymmetrische Cryptografie (Public Key Cryptography)
* **Twee wiskundig gekoppelde sleutels:** Asymmetrische cryptografie gebruikt een sleutelpaar bestaande uit een **publieke sleutel** (*public key*) en een **private sleutel** (*private key*):
  * **Public Key:** Mag vrij en publiekelijk worden verspreid. Iedereen kan deze sleutel gebruiken om een bericht voor de eigenaar te versleutelen.
  * **Private Key:** Blijft strikt geheim bij de eigenaar en wordt nooit gedeeld. Alleen deze private sleutel kan berichten ontsleutelen die met de bijbehorende publieke sleutel zijn versleuteld.
* **Voordelen & Beperkingen ten opzichte van Symmetrische Cryptografie:**
  * **Lost Key Distribution op:** De geheime private sleutel wordt nooit over het netwerk verstuurd.
  * **Lost Key Management op:** Eén enkel sleutelpaar volstaat om veilig met talloze verschillende partijen te communiceren (geen kwadratische explosie van sleutels zoals bij symmetrische encryptie).
  * **Nadeel (Snelheid):** Asymmetrische cryptografie is rekenkundig zwaarder, trager en minder efficiënt dan symmetrische cryptografie, waardoor het niet geschikt is voor langdurige bulk-communicatiesessies (daarom gebruikt TLS/HTTPS het alleen voor de initiële handshake en sleuteluitwisseling).

### Beveiligingseigenschappen: Confidentiality, Authenticity & Non-Repudiation
Afhankelijk van welke sleutel wordt gebruikt voor de bewerking, biedt asymmetrische cryptografie verschillende beveiligingsgaranties:

| Bewerking | Gebruikte sleutel door verzender | Gebruikte sleutel door ontvanger | Beveiligingsgarantie |
| :--- | :--- | :--- | :--- |
| **Versleutelen (Encryption)** | **Publieke sleutel** van ontvanger | **Private sleutel** van ontvanger | **Confidentiality (Vertrouwelijkheid):** Alleen de bezitter van de private sleutel kan het bericht lezen. |
| **Ondertekenen (Signing)** | **Private sleutel** van verzender | **Publieke sleutel** van verzender | **Authenticity & Non-Repudiation:** Niet vertrouwelijk (iedereen met de public key kan verifiëren), maar bewijst wie de afzender is. |

* **Authenticity (Authenticiteit):** De garantie dat een entiteit aantoonbaar de identiteit bezit die zij claimt.
* **Non-Repudiation (Onweerlegbaarheid):** De garantie dat de verzender achteraf niet kan ontkennen dat hij of zij het bericht heeft verstuurd (mits de private sleutel goed beveiligd is gebleven).

### Digitale Handtekeningen, Digitale Certificaten & PKI
* **Digitale Handtekening (Digital Signature):** Wordt aangemaakt met de **private sleutel** van de verzender (gebruikt door e-signing-diensten zoals DocuSign). De ontvanger verifieert de handtekening met de **publieke sleutel** van de verzender om de echtheid te bevestigen.
* **Digitaal Certificaat (Digital Certificate):** Een elektronisch document dat een publieke sleutel koppelt aan identiteitsgegevens van de eigenaar, gewaarmerkt met een digitale handtekening.
* **Public Key Infrastructure (PKI):** Het wereldwijde stelsel van digitale certificaten en vertrouwde **Certificate Authorities (CA's)**. Personen, organisaties en webservers registreren hun publieke sleutel bij een vertrouwde CA om een digitaal certificaat te verkrijgen, wat veilige communicatie op het internet (zoals HTTPS) mogelijk maakt.

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Asymmetrisch Sleutelpaar Genereren & Publieke Sleutel Publiceren
Het opzetten van je eigen sleutelpaar en het veilig beschikbaar stellen van je publieke sleutel op een keyserver:

1. **Genereer je eigen private sleutel:**
   ```bash
   openssl genpkey -algorithm rsa -out cybraryprivate.key
   ```
   * *Valkuil:* Controleer met `ls -la` dat de rechten op je private key beperkt zijn (`-rw-------`), en kopieer dit bestand nooit naar publieke mappen.
2. **Leid de bijbehorende publieke sleutel af:**
   ```bash
   openssl rsa -pubout -in cybraryprivate.key -out cybrarypublic.key
   ```
3. **Publiceer uitsluitend de publieke sleutel op de webserver:**
   ```bash
   sudo cp cybrarypublic.key /var/www/html
   ```
   * Controleer in de webbrowser op de keyserver-pagina of `cybrarypublic.key` beschikbaar is voor andere gebruikers.

### Scenario 2: Een Versleuteld Bericht Versturen & Ontsleutelen met Public/Private Keys
Hoe `cybrary` een vertrouwelijk bericht stuurt naar `sally` met Sally's publieke sleutel, zodat alleen `sally` dit kan lezen:

1. **Download de publieke sleutel van de ontvanger (`sallypublic.key`) en stel het bericht op:**
   ```bash
   echo "Sally, I have an ice cream cake at home for John's surprise birthday party!" > message.txt
   ```
2. **Versleutel het bericht met Sally's publieke sleutel (`-pubin`):**
   ```bash
   openssl pkeyutl -encrypt -inkey Downloads/sallypublic.key -pubin -in message.txt -out message.enc
   ```
   * *Valkuil:* Vergeet de vlag `-pubin` niet wanneer je versleutelt met een publieke sleutel; zonder `-pubin` verwacht `openssl pkeyutl` een private sleutel en geeft het een foutmelding.
3. **Codeer naar Base64 en verstuur via lokale mail:**
   ```bash
   base64 message.enc > message.base64
   cat message.base64 | mail -s "For Sally" sally
   ```
4. **Wissel naar het account van de ontvanger (`sally`), decodeer en ontsleutel:**
   ```bash
   su - sally
   mail
   ```
   * Open het bericht (`1`), kopieer uitsluitend de Base64-tekst uit de berichttekst en sluit `mail` af met `exit`.
   * Decodeer van Base64 naar binair en ontsleutel met Sally's **private sleutel**:
```bash
echo "<GEPLAKTE_BASE64_TEKST>" > message.base64
base64 -d message.base64 > message.enc
openssl pkeyutl -decrypt -inkey sallyprivate.key -in message.enc -out message.txt
cat message.txt
```

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `BASH.md` (Sectie 10: *Scripting, Python & Cryptografie*) voor het overzicht van alle OpenSSL-commando's (`genpkey`, `rsa`, `pkeyutl`, `dgst`).
  * Zie `CMD.md` en `PowerShell.md` voor Windows-equivalenten (`Protect-CmsMessage`, `Unprotect-CmsMessage`, `ssh-keygen`).
* **[Aanvullend] Officiële Documentatie & Hulpmiddelen:**
  * [OpenSSL `rsa` Manual](https://docs.openssl.org/master/man1/openssl-rsa/) & [OpenSSL `pkeyutl` Manual](https://docs.openssl.org/master/man1/openssl-pkeyutl/) — Officiële documentatie voor sleutelbeheer en asymmetrische bewerkingen.
  * [RFC 5280: Internet X.509 Public Key Infrastructure Certificate and CRL Profile](https://datatracker.ietf.org/doc/html/rfc5280) — De standaard achter digitale certificaten, CA's en PKI.
  * [Let's Encrypt: How It Works](https://letsencrypt.org/how-it-works/) — Prakt