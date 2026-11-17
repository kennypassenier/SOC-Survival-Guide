# Symmetric Cryptography

## 1. Overzicht van Relevante Commando's

### A. Cryptografie & Sleutelbeheer (`openssl`)

#### `openssl genpkey`
* **Doel:** Genereert een private cryptografische sleutel voor een gekozen algoritme (zoals RSA).
* **Parameters & Opties:**
  * `genpkey`: Subcommando voor *Generate Private Key* (de modernere vervanger van verouderde tools zoals `openssl genrsa`).
  * `-algorithm <naam>`: Specificeert het cryptografische algoritme (bijv. `rsa`).
  * `-out <bestand>`: Slaat de gegenereerde sleutel op in het opgegeven uitvoerbestand (bijv. `keyforjohn.key`).
* **Praktijkgebruik:**
  ```bash
  # Genereer een private sleutel om als gedeeld geheim te gebruiken
  openssl genpkey -algorithm rsa -out keyforjohn.key
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * Hoewel RSA van oorsprong een asymmetrisch algoritme is, gedraagt het zich functioneel als een gedeelde sleutel wanneer één enkele private key wordt aangemaakt en zonder publieke tegenhanger tussen twee gebruikers wordt gedeeld.
  * **[Aanvullend] Echte symmetrische encryptie & sleutelgeneratie met OpenSSL:** In de praktijk wordt voor symmetrische bulk-encryptie geen RSA-sleutel gedeeld, maar een willekeurige bytesleutel of wachtwoordzin met **AES-256**:
    * Willekeurige 256-bit (32-byte) hex-sleutel genereren: `openssl rand -hex 32`
    * Bestand versleutelen met AES-256-CBC: `openssl enc -aes-256-cbc -salt -pbkdf2 -in message.txt -out message.enc` (`-salt` = voegt willekeurige salt toe, `-pbkdf2` = moderne sleutelafleiding).
    * Bestand ontsleutelen: `openssl enc -d -aes-256-cbc -pbkdf2 -in message.enc -out message.txt` (`-d` = **d**ecrypt).

#### `openssl pkeyutl`
* **Doel:** *Public Key Utility*: voert cryptografische bewerkingen uit zoals versleutelen (`-encrypt`) en ontsleutelen (`-decrypt`) met behulp van een sleutelbestand.
* **Parameters & Opties:**
  * `-encrypt`: Versleutelt de invoerdata naar onleesbare binaire *ciphertext*.
  * `-decrypt`: Ontsleutelt de versleutelde *ciphertext* terug naar leesbare *plaintext*.
  * `-inkey <sleutelbestand>`: Specificeert het sleutelbestand dat voor de bewerking wordt gebruikt.
  * `-in <invoerbestand>`: Het bronbestand dat versleuteld of ontsleuteld moet worden.
  * `-out <uitvoerbestand>`: Het doelbestand waarin het resultaat wordt opgeslagen.
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Versleutel plaintext (message.txt) naar binaire ciphertext (message.enc)
  openssl pkeyutl -encrypt -inkey keyfromcybrary.key -in message.txt -out message.enc

  # Ontsleutel binaire ciphertext (message.enc) terug naar plaintext (message.txt)
  openssl pkeyutl -decrypt -inkey keyforjohn.key -in message.enc -out message.txt
  ```
* **[Aanvullend] Windows-equivalenten (PowerShell & CMD):**
  * Windows bevat geen standaard ingebouwde `openssl`-binary (tenzij Git for Windows of OpenSSL apart is geïnstalleerd).
  * **PowerShell:** Voor symmetrische versleuteling of beveiligde opslag van geheimen gebruiken beheerders `Protect-CmsMessage` / `Unprotect-CmsMessage` (certificaatgebaseerd) of .NET `[System.Security.Cryptography.Aes]` binnen scripts.

---

### B. Encoding, Gebruikerscontext & Lokale Mail

#### `base64`
* **Doel:** Codeert binaire data (zoals sleutelbestanden of versleutelde `.enc`-bestanden) naar veilige, afdrukbare ASCII-tekens voor tekstgebaseerde overdracht (zoals e-mail), en decodeert Base64-strings weer terug naar hun originele binaire vorm.
* **Parameters & Opties:**
  * Geen vlag (standaard): Codeert invoer naar Base64.
  * `-d` (`d` = **d**ecode): Decodeert Base64-tekst terug naar de oorspronkelijke (binaire) data.
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Codeer een sleutelbestand of versleuteld bestand naar Base64 voor e-mailverzending
  base64 keyforjohn.key > keyforjohn.send
  base64 message.enc > message.send

  # Decodeer een ontvangen Base64-string terug naar het originele bestand
  base64 -d keyforjohn.base64 > keyfromcybrary.key
  base64 -d message.base64 > message.enc
  ```
* **Tips & Valkuilen:**
  * **Encoding is geen encryptie:** Base64 biedt geen enkele vertrouwelijkheid (iedereen kan het zonder sleutel decoderen met `base64 -d`). Het dient uitsluitend om binaire bestanden (die tekens bevatten die e-mailclients of terminals breken) veilig als platte tekst te kunnen kopiëren, plakken en mailen.
  * **[Aanvullend] Windows-equivalenten:**
    * **CMD:** `certutil -encode message.enc message.send` en `certutil -decode message.base64 message.enc`
    * **PowerShell:** `[Convert]::ToBase64String([IO.File]::ReadAllBytes("message.enc"))` en `[IO.File]::WriteAllBytes("message.enc", [Convert]::FromBase64String($b64))`

#### `su`
* **Doel:** *Switch User*: wisselt in de huidige terminalsessie van gebruikersaccount.
* **Parameters & Opties:**
  * `-` (of `-l` / `--login`): Start een volledige login-shell voor de doelgebruiker, inclusief diens omgevingsvariabelen en home-directory.
* **Praktijkgebruik:**
  ```bash
  # Wissel naar gebruiker 'john' met een volledige login-shell (afsluiten met 'exit')
  su - john
  ```
* **[Aanvullend] OS-verschillen & Security Best Practices:**
  * **Debian / Ubuntu vs. Arch Linux:** Op systemen waar het `root`-account standaard vergrendeld is (zoals Ubuntu), gebruik je `sudo -i` of `sudo su - <gebruiker>` in plaats van rechtstreeks `su -`.
  * **Windows-equivalent:** `runas /user:john cmd.exe` (CMD) of `Start-Process powershell -Credential (Get-Credential)` (PowerShell).

#### `mail`
* **Doel:** Klassieke CLI-mailclient (vaak onderdeel van `mailutils`) om lokale systeemberichten te versturen en te lezen.
* **Parameters & Opties:**
  * `-s "<onderwerp>"` (`s` = **s**ubject): Geeft het onderwerp van de e-mail op.
* **Praktijkgebruik & Interactieve Commando's:**
  ```bash
  # Stuur de inhoud van een bestand via pipe als e-mail naar lokale gebruiker 'john'
  cat keyforjohn.send | mail -s "For John" john

  # Open de lokale mailbox van de huidige gebruiker
  mail
  ```
  * *Binnen de interactieve `mail`-prompt (`?`):* Typ het berichtnummer (bijv. `1` of `2`) om het bericht te lezen, druk op `Spatiebalk` bij `--More--` om verder te scrollen, en typ `exit` (of `q`) om af te sluiten.
* **[Aanvullend] OS-verschillen & Modernere Mogelijkheden:**
  * Lokale systeemmail wordt op Linux opgeslagen onder `/var/mail/<gebruiker>` (of `/var/spool/mail/<gebruiker>`). Op moderne Debian- en Arch-systemen is `mail` (`mailutils` of `s-nail`) niet altijd standaard geïnstalleerd; voor geautomatiseerde mail vanaf de CLI wordt ook vaak `sendmail` of `msmtp` gebruikt.

---

## 2. Algemene Uitleg & Theorie

### Werking van Symmetrische Cryptografie
* **Eén gedeelde sleutel:** Symmetrische cryptografie gebruikt **één enkele cryptografische sleutel** (ook wel *secret key* of *shared secret* genoemd) om zowel *plaintext* te versleutelen als *ciphertext* te ontsleutelen.
* **Stappenplan voor veilige communicatie (User A naar User B):**
  1. User A genereert een geheime sleutel.
  2. User A deelt een kopie van deze sleutel met User B.
  3. User A versleutelt het bericht met de gedeelde sleutel en verstuurt de *ciphertext*.
  4. User B ontsleutelt de *ciphertext* met exact dezelfde gedeelde sleutel.
* **Voordelen & Toepassingen:** Symmetrische algoritmen (zoals **AES**) zijn zeer snel, rekenkundig efficiënt en uiterst veilig. Daarom vormen ze de standaard voor:
  * Bulk-data-encryptie (grote hoeveelheden bestanden of netwerkverkeer).
  * *At-rest* database- en schijfencryptie.
  * Betaaltoepassingen en financiële transacties.

### De Twee Grote Nadelen van Symmetrische Encryptie
1. **Key Management (Sleutelbeheer / Schaalbaarheid):**
   * Elk paar gebruikers dat privé wil communiceren zonder dat anderen kunnen meelezen, heeft een unieke gedeelde sleutel nodig.
   * Het totale aantal benodigde sleutels voor $N$ gebruikers groeit kwadratisch volgens de formule:
     $$\text{Aantal sleutels} = \frac{N \times (N - 1)}{2}$$
   * *Voorbeeld:* Voor **10 gebruikers** zijn er al $\frac{10 \times (10 - 1)}{2} = 45$ aparte geheime sleutels nodig. In grote organisaties wordt dit onbeheersbaar.
2. **Key Distribution (Sleuteldistributie):**
   * Voordat twee partijen versleuteld kunnen communiceren, moet de sleutel eerst veilig bij de ontvanger terechtkomen. Het versturen van de sleutel over een onveilig kanaal opent de deur voor onderschepping (*key theft*).

### Hybride Cryptografie (TLS / HTTPS)
* Om de snelheid van symmetrische cryptografie te combineren met veilig sleutelbeheer, worden symmetrische en asymmetrische cryptografie samen ingezet als een **hybride cryptografische oplossing**.
* Het bekendste voorbeeld is **TLS (Transport Layer Security)**, het protocol achter **HTTPS**: asymmetrische cryptografie wordt gebruikt om veilig een tijdelijke gedeelde sessiesleutel uit te wisselen, waarna al het daadwerkelijke webverkeer razendsnel met symmetrische encryptie wordt beveiligd.

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Een Gedeelde Sleutel Aanmaken, Uitwisselen en Gebruiken voor Versleutelde Berichten
Dit stappenplan laat zien hoe twee lokale gebruikers (`cybrary` en `john`) een sleutel uitwisselen, binaire encryptie uitvoeren en Base64 gebruiken voor transport:

1. **Genereer en codeer de geheime sleutel (als `cybrary`):**
   ```bash
   openssl genpkey -algorithm rsa -out keyforjohn.key
   base64 keyforjohn.key > keyforjohn.send
   cat keyforjohn.send | mail -s "For John" john
   ```
   * *Aandachtspunt:* Omdat het sturen van de sleutel via onversleutelde e-mail gebeurt, illustreert dit direct het **key distribution**-probleem uit de theorie.
2. **Wissel naar de ontvanger, ontvang en decodeer de sleutel (als `john`):**
   ```bash
   su - john
   mail
   ```
   * Open bericht `1`, kopieer uitsluitend de Base64-tekst uit de berichttekst en sluit af met `exit`.
   * Sla de tekst op en decodeer deze terug naar het sleutelbestand:
```bash
echo "<GEPLAKTE_BASE64_SLEUTEL>" > keyforjohn.base64
base64 -d keyforjohn.base64 > keyfromcybrary.key
```
3. **Versleutel een geheim bericht en verstuur het (als `john`):**
   ```bash
   echo "Be sure to drink your ovaltine!" > message.txt
   openssl pkeyutl -encrypt -inkey keyfromcybrary.key -in message.txt -out message.enc
   base64 message.enc > message.send
   cat message.send | mail -s "Secret Message from John" cybrary
   exit
   ```
   * *Valkuil:* `message.enc` bevat ruwe binaire data (*gibberish*). Als je dit zonder `base64` probeert te kopiëren of te mailen, raakt het bestand beschadigd en mislukt de decryptie.
4. **Ontvang, decodeer en ontsleutel het bericht (terug als `cybrary`):**
   ```bash
   mail
   ```
   * Open bericht `2`, kopieer de Base64-payload uit de berichttekst en typ `exit`.
   * Decodeer eerst van Base64 naar binair, en ontsleutel daarna met de oorspronkelijke sleutel:
```bash
echo "<GEPLAKTE_BASE64_BERICHT>" > message.base64
base64 -d message.base64 > message.enc
openssl pkeyutl -decrypt -inkey keyforjohn.key -in message.enc -out message.txt
cat message.txt
```

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `BASH.md` (Sectie 4 voor `base64` en Sectie 10 voor `openssl` en cryptografie) voor de bijgewerkte Linux-commando's.
  * Zie `CMD.md` (`certutil`, `runas`) en `PowerShell.md` (`Protect-CmsMessage`, `[Convert]::ToBase64String`) voor de Windows-equivalenten.
* **[Aanvullend] Officiële Documentatie & Hulpmiddelen:**
  * [OpenSSL `genpkey` Manual](https://docs.openssl.org/master/man1/openssl-genpkey/) & [OpenSSL `pkeyutl` Manual](https://docs.openssl.org/master/man1/openssl-pkeyutl/) — Officiële documentatie van de gebruikte OpenSSL-subcommando's.
  * [NIST FIPS 197: Advanced Encryption Standard (AES)](https://csrc.nist.gov/pubs/fips/197/final) — De officiële standaard voor moderne symmetrische encryptie.
  * [RFC 8446: The Transport Layer Security (TLS) Protocol Version 1.3](https://datatracker.ietf.org/doc/html/rfc8446) — Technische specificatie van hybride cryptografie in HTTPS.