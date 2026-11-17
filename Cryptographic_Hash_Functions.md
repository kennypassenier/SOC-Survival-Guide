# Cryptographic Hash Functions

## 1. Overzicht van Relevante Commando's & Hashing-tools

### A. Cryptografische Hashes Genereren (`openssl dgst`)

#### `openssl dgst`
* **Doel:** *Message Digest*: berekent een cryptografische hashwaarde (vingerafdruk) van één of meerdere bestanden met behulp van een gekozen hash-algoritme (zoals MD5 of SHA-256).
* **Parameters & Opties:**
  * `dgst`: Subcommando voor het genereren van message digests (hashes).
  * `-md5`: Berekent een 128-bit **MD5**-hash (snel, maar gevoeliger voor collisions).
  * `-sha256`: Berekent een 256-bit **SHA-256**-hash (onderdeel van de veilige SHA-2-familie).
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Genereer een MD5-hash van een bestand
  openssl dgst -md5 hash1/file1

  # Genereer een SHA-256-hash van een uitvoerbaar bestand of document
  openssl dgst -sha256 hash1/happypuppy.exe
  openssl dgst -sha256 abigfile.txt
  ```
* **Tips, Best Practices & Modernere Mogelijkheden:**
  * Gebruik voor beveiligings- en integriteitscontroles altijd **SHA-256** (`-sha256`) in plaats van MD5 (`-md5`), omdat MD5 kwetsbaar is voor *hash collisions*.
  * **[Aanvullend] Native Linux & Windows Alternatieven:**
    * **Linux (Debian/Ubuntu & Arch):** Gebruik de standaard GNU coreutils-commando's `md5sum <bestand>` en `sha256sum <bestand>` (of `sha512sum`). Met `sha256sum -c checksums.txt` (`-c` = **c**heck) controleer je gedownloade bestanden automatisch tegen een gepubliceerd hashbestand.
    * **Windows PowerShell:** Gebruik `Get-FileHash -Path .\happypuppy.exe -Algorithm SHA256` (of `-Algorithm MD5`).
    * **Windows CMD:** Gebruik de ingebouwde tool `certutil -hashfile happypuppy.exe SHA256` (of `MD5`).

---

### B. Testbestanden Aanmaken, Hernoemen & Manipuleren

#### `mkdir`, `touch`, `echo`, `cat`, `mv` & `base64 /dev/urandom | head -c 1M`
* **Doel:** Ondersteunende bestandscommando's om geïsoleerde testmappen en bestanden te maken, te hernoemen en te wijzigen om het gedrag van hashfuncties te testen.
* **Praktijkgebruik & Permutaties:**
  ```bash
  # Maak testmappen en lege bestanden aan
  mkdir hash1 hash2 hash3
  touch hash1/file1 hash2/file2 hash3/file3

  # Schrijf identieke en afwijkende inhoud naar de bestanden
  echo "moo" > hash1/file1
  echo "moo" > hash2/file2
  echo "woof" > hash3/file3

  # Hernoem een bestand (verandert de hash NIET)
  mv hash1/file1 hash1/happypuppy.exe

  # Genereer een 1MB testbestand en voeg daarna één spatie toe (verandert de hash VOLLEDIG)
  base64 /dev/urandom | head -c 1M > abigfile.txt
  echo " " >> abigfile.txt
  ```
* **Valkuilen:**
  * Let op dat `echo "moo" > bestand` ook een onzichtbaar regeleinde (`\n`) meeschrijft. Een bestand dat met `echo -n "moo"` (`-n` = **n**o trailing newline) is aangemaakt, levert daardoor een totaal andere hash op dan een bestand met een regeleinde.

---

## 2. Algemene Uitleg & Theorie

### Wat is een Cryptografische Hashfunctie?
* **Definitie:** Een **hash** is een wiskundige weergave van een digitaal object (zoals een tekstbestand, een e-mail of een uitvoerbaar programma). Wanneer je een digitaal object door een **hashfunctie** haalt, produceert deze een unieke alfanumerieke tekenreeks van vaste lengte.
* **Deterministisch & Lawine-effect (*Avalanche Effect*):**
  * Zolang de inhoud van een digitaal object ongewijzigd blijft, levert dezelfde hashfunctie **altijd exact dezelfde hashwaarde** op, ongeacht de bestandsnaam, bestandsextensie (`.txt` vs. `.exe`) of maplocatie.
  * Zelfs de kleinst mogelijke wijziging in de inhoud (zoals het toevoegen van één enkele punt of spatie) resulteert in een **volledig nieuwe, onherkenbare hashwaarde**.

### Hashing vs. Encryptie & Wachtwoordaanvallen
* **Eenrichtingsfunctie (*One-way function*):** In tegenstelling tot encryptie is hashing een **eenrichtingsproces**. Een hash is geen *ciphertext*, maar een digitale vingerafdruk: er bestaat geen wiskundige formule om vanuit een hashwaarde de oorspronkelijke bestandsinhoud terug te rekenen.
* **Dictionary Attacks & Cracking Tools:** Dat hashing onomkeerbaar is, maakt het niet onkwetsbaar. Aanvallers kunnen gehashte wachtwoorden achterhalen via een **dictionary attack** (woordenboekaanval), waarbij een uitgebreide lijst van woorden en wachtwoorden wordt gehasht en vergeleken met de doel-hash. Populaire tools hiervoor zijn **John the Ripper** en **Hashcat**.
* **[Aanvullend] Salting:** Om dictionary- en rainbow-table-aanvallen op wachtwoorden tegen te gaan, voegen moderne systemen vóór het hashen een unieke willekeurige tekenreeks (*salt*) toe aan elk wachtwoord.

### Veelgebruikte Hashfuncties & Collisions
* **Bekende algoritmen:**
  * **MD5 (Message Digest 5):** Zeer snel en nog steeds veelgebruikt voor eenvoudige integriteitscontroles, maar cryptografisch verzwakt.
  * **CRC (Cyclic Redundancy Check):** Vooral gebruikt voor foutdetectie bij datatransmissie en opslag (geen cryptografische beveiliging).
  * **SHA (Secure Hash Algorithm):** De moderne standaardfamilie (waaronder **SHA-2 / SHA-256** en **SHA-3**).
* **Collisions (Botsingen):** Omdat er een oneindig aantal mogelijke digitale bestanden bestaat, maar een hashfunctie een eindig aantal mogelijke uitvoerwaarden heeft, bestaat de theoretische kans dat twee verschillende bestanden dezelfde hash genereren. Dit heet een **collision**. Hoe sterker de hashfunctie (zoals SHA-256 ten opzichte van MD5), hoe kleiner de kans op een collision.

### Praktische Toepassingen voor IT & Cybersecurity
1. **System Administrators:** Valideren de integriteit en echtheid van software-installers en executables die van internet zijn gedownload.
2. **SOC Analysts:** Berekenen hashes van verdachte bestanden om te controleren of ze overeenkomen met bekende malware (bijv. in Threat Intelligence-platformen of VirusTotal). Aanvallers hernoemen malware vaak naar vertrouwde namen, maar het wijzigen van de bestandsnaam verandert de hashwaarde niet.
3. **Incident Responders:** Leggen hashwaarden vast voor elke *Indicator of Compromise* (IOC) die op een gecompromitteerd systeem wordt aangetroffen.
4. **Forensic Analysts:** Genereren hashes van alle forensische tools die zij op een gecompromitteerd systeem draaien om aan te tonen dat hun tools bekend, veilig en ongewijzigd zijn en de digitale plaats delict niet besmetten.

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Bestandsidentiteit & Integriteit Verifiëren via Hashes
Dit stappenplan demonstreert waarom SOC-analisten vertrouwen op hashes in plaats van bestandsnamen, en hoe gevoelig een hash is voor minimale aanpassingen:

1. **Maak drie testbestanden aan in aparte mappen (`file1` en `file2` met inhoud `"moo"`, `file3` met inhoud `"woof"`):**
   ```bash
   mkdir hash1 hash2 hash3
   touch hash1/file1 hash2/file2 hash3/file3
   echo "moo" > hash1/file1
   echo "moo" > hash2/file2
   echo "woof" > hash3/file3
   ```
2. **Vergelijk de MD5-hashes van de bestanden:**
   ```bash
   openssl dgst -md5 hash1/file1
   openssl dgst -md5 hash2/file2
   openssl dgst -md5 hash3/file3
   ```
   * *Resultaat:* `hash1/file1` en `hash2/file2` leveren exact dezelfde MD5-hash op omdat hun inhoud identiek is, terwijl `hash3/file3` een totaal andere hash heeft.
3. **Test het effect van hernoemen en extensiewijziging (Malware-masquerading simulatie):**
   ```bash
   mv hash1/file1 hash1/happypuppy.exe
   openssl dgst -md5 hash1/happypuppy.exe
   openssl dgst -sha256 hash1/happypuppy.exe
   openssl dgst -sha256 hash2/file2
   ```
   * *Inzicht:* Ondanks de nieuwe naam en `.exe`-extensie blijft zowel de MD5- als de SHA-256-hash van `happypuppy.exe` 100% gelijk aan die van `file2`.
4. **Test het lawine-effect bij een minimale wijziging in een groot bestand (1 MB):**
   ```bash
   base64 /dev/urandom | head -c 1M > abigfile.txt
   openssl dgst -sha256 abigfile.txt
   echo " " >> abigfile.txt
   openssl dgst -sha256 abigfile.txt
   ```
   * *Inzicht:* Het toevoegen van één enkele spatie aan het einde van een bestand van 1 megabyte zorgt ervoor dat de volledige SHA-256-hash compleet verandert.

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `BASH.md` (Sectie 10: *Scripting, Python & Cryptografie*) voor `openssl dgst`, `md5sum` en `sha256sum`.
  * Zie `CMD.md` (`certutil -hashfile`) en `PowerShell.md` (`Get-FileHash`) voor de Windows-equivalenten.
* **[Aanvullend] Officiële Documentatie & Hulpmiddelen:**
  * [OpenSSL `dgst` Manual](https://docs.openssl.org/master/man1/openssl-dgst/) — Officiële documentatie voor het genereren en verifiëren van digests en handtekeningen.
  * [NIST FIPS 180-4: Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/upd1/final) — Officiële specificatie van SHA-1, SHA-224, SHA-256, SHA-384 en SHA-512.
  * [VirusTotal](https://www.virustotal.com/) — Praktijkplatform waarin SOC-analisten SHA-256- en MD5-hashes opzoeken om verdachte bestanden te controleren op bekende malware.