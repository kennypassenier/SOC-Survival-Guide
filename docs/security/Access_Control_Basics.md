# Access Control Basics

## 1. Overzicht van Relevante Commando's

### A. Windows ACL & Permissiebeheer (`icacls`)

#### `icacls`
* **Doel:** *Integrity Control Access Control List*: toont, kopieert, wijzigt of herstelt Access Control Lists (ACL's) en overervingsinstellingen (*inheritance*) op bestanden en mappen.
* **Parameters, Switches & Permissiecodes:**
  * `/t` (`t` = **t**raverse / recursive): Past de actie of weergave recursief toe op alle onderliggende submappen en bestanden binnen de opgegeven map.
  * **Permissiecodes in uitvoer:**
    * `(F)`: **F**ull Control (volledig beheer)
    * `(M)`: **M**odify (wijzigen, lezen, schrijven, uitvoeren en verwijderen)
    * `(RX)`: **R**ead & e**X**ecute (lezen en uitvoeren)
    * `(R)`: **R**ead-only (alleen lezen)
    * `(W)`: **W**rite-only (alleen schrijven)
  * **Overervingsvlaggen (*Inheritance flags*):**
    * `(I)`: **I**nherited (deze machtiging is overgenomen van de bovenliggende map).
    * `(OI)`: **O**bject **I**nherit (bestanden in deze map nemen deze machtiging over).
    * `(CI)`: **C**ontainer **I**nherit (submappen nemen deze machtiging over).
    * `(IO)`: **I**nherit **O**nly (geldt niet voor de map zelf, maar wordt wel doorgegeven aan nieuw aangemaakte submappen/bestanden, zoals bij `CREATOR OWNER`).
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Toon de ACL (alle ACE's) van de map Hall_of_Justice
  icacls Hall_of_Justice

  :: Toon recursief alle ACL's van een map en alle onderliggende submappen en bestanden
  icacls Hall_of_Justice /t

  :: Controleer specifiek de rechten op een submap
  icacls Hall_of_Justice\Leadership
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * Waar het tabblad *Security* in Verkenner slechts één map of bestand tegelijk toont, kan `icacls <map> /t` in één oogopslag de rechten over duizenden onderliggende mappen en bestanden valideren.
  * **[Aanvullend] Permissies aanpassen & overerving beheren via CLI (`icacls`):**
    * Groep rechten geven met overerving op mappen en bestanden: `icacls C:\Leadership /grant "Leaders:(OI)(CI)M"`
    * Overerving uitschakelen en bestaande regels kopiëren naar expliciete regels: `icacls C:\Leadership /inheritance:d` (`d` = **d**isable & copy, `r` = **r**emove all inherited, `e` = **e**nable).
    * Een groep verwijderen uit de ACL: `icacls C:\Leadership /remove "BUILTIN\Users"`
  * **[Aanvullend] Modernere PowerShell- en Linux-equivalenten:**
    * **Windows PowerShell:** `Get-Acl -Path C:\Hall_of_Justice | Format-List` en `Set-Acl` (of de community-module `NTFSSecurity` met `Get-NTFSAccess` en `Get-NTFSEffectiveAccess`).
    * **Linux (Debian/Ubuntu & Arch):** `chmod` (rechten wijzigen), `chown` (eigenaar/groep wijzigen) en `getfacl` / `setfacl` (voor uitgebreide POSIX Access Control Lists).

---

### B. Ondersteunende CMD-commando's (`tree` & `net localgroup`)

#### `tree /F` & `net localgroup`
* **Doel:**
  * `tree <map> /F`: Geeft de volledige mappenstructuur inclusief alle bestanden (`/F` = **F**iles) weer voordat je permissies wijzigt of verplaatst.
  * `net localgroup <groepsnaam>`: Toont alle gebruikersaccounts die lid zijn van een specifieke lokale Windows-groep (bijv. om te verifiëren welke gebruikers een RBAC-rol bezitten).
* **Praktijkgebruik & Permutaties:**
  ```cmd
  :: Bekijk de volledige boomstructuur inclusief bestanden
  tree Hall_of_Justice /F
  tree Hall_of_Doom /F

  :: Controleer welke gebruikers lid zijn van de lokale groep 'Leaders'
  net localgroup Leaders
  ```
* **[Aanvullend] Modernere PowerShell-equivalenten:**
  * **Groepsleden opvragen:** `Get-LocalGroupMember -Group "Leaders"`
  * **Mappenstructuur inclusief bestanden:** `Get-ChildItem -Path C:\Hall_of_Justice -Recurse`

---

## 2. Algemene Uitleg & Theorie

### Authenticatie vs. Autorisatie & Security Principals
* **Authentication (Authenticatie):** Het proces waarbij een entiteit (*subject*, zoals een gebruiker, groep of computer) zijn of haar geclaimde identiteit bewijst (bijv. via wachtwoord of certificaat).
* **Security Principal & SID:** Zodra een subject succesvol is geauthenticeerd, wordt het een **security principal**, geïdentificeerd door een unieke waarde genaamd een **SID** (*Security Identifier*).
* **Access Control (Autorisatie):** Het proces dat plaatsvindt **na** authenticatie en bepaalt welke acties een geauthenticeerde *security principal* mag uitvoeren op een **object** (zoals een bestand, map of netwerkshare). Dit waarborgt de **vertrouwelijkheid (confidentiality)** van gegevens.

### De Drie Belangrijkste Access Control Modellen
1. **Mandatory Access Control (MAC):**
   * Het strengste toegangscontrolemodel, voornamelijk gebruikt in overheids- en militaire omgevingen.
   * Zowel subjects als objects krijgen twee beveiligingslabels: **classificatie** (bijv. *High Security*) en **categorie** (bijv. *Top Secret*). Beide labels moeten exact overeenkomen voordat toegang wordt verleend.
2. **Discretionary Access Control (DAC):**
   * Subjects krijgen rechtstreeks machtigingen op objecten toegewezen door de eigenaar of beheerder (standaardmodel in Windows NTFS).
   * Het besturingssysteem werkt met **Access Control Entries (ACE's)**:
     $$\text{SID} + \text{Permission} = \text{ACE}$$
   * De volledige lijst van alle ACE's op een object vormt de **Access Control List (ACL)**.
3. **Role-Based Access Control (RBAC):**
   * Toegang wordt niet op basis van individuele gebruikers-SID's verleend, maar op basis van de **functierol** van een gebruiker.
   * In Windows wordt RBAC geïmplementeerd door beveiligingsgroepen aan te maken die specifieke **functierollen** vertegenwoordigen (bijv. *Editors* of *Leaders*), de ACE's aan die groep toe te wijzen en gebruikers aan die groep toe te voegen. *(Opmerking: willekeurig gebruikers in groepen stoppen is nog geen RBAC; de groepen moeten daadwerkelijk bedrijfsrollen weerspiegelen).*

### Windows Standaardmachtigingen & Voorrangsregels
* **De 6 standaard Windows-machtigingen:**
  1. **Full Control** (volledig beheer, inclusief rechten aanpassen en eigenaarschap overnemen)
  2. **Modify** (lezen, schrijven, uitvoeren en verwijderen)
  3. **Read & Execute** (bestanden lezen en programma's uitvoeren, mappen doorlopen)
  4. **List Folder Contents** (inhoud van mappen bekijken)
  5. **Read** (bestanden en eigenschappen lezen)
  6. **Write** (nieuwe bestanden/mappen aanmaken en bestaande aanpassen)
* **Allow vs. Deny:** Elke machtiging kan op *Allow* of *Deny* staan. **Een expliciete `Deny` heeft altijd voorrang op een `Allow`**. Als een gebruiker *Allow Modify* heeft maar *Deny Read*, kan hij het bestand niet openen. Omdat expliciete *Deny*-regels vaak onverwachte neveneffecten veroorzaken, is het vrijwel altijd beter om een recht simpelweg **niet toe te kennen** dan een *Deny* in te stellen.
* **Advanced Permissions:** Naast de 6 standaardmachtigingen bestaan er 14 *Advanced Permissions* (zoals *Traverse Folder* of *Delete Subfolders and Files*). Vermijd deze waar mogelijk om onoverzichtelijke "permissieknopen" (*permission knots*) te voorkomen.

### Inheritance (Overerving) & Het Effect van Verplaatsen vs. Kopiëren
* **Werking van Inheritance:** Machtigingen (ACE's) die op een bovenliggende map (*parent*) staan, stromen automatisch omlaag naar alle onderliggende submappen en bestanden (*children*).
* **Wat gebeurt er bij kopiëren of verplaatsen van objecten?**

| Actie | Expliciete machtigingen | Overgenomen machtigingen (*Inherited*) |
| :--- | :--- | :--- |
| **Verplaatsen binnen hetzelfde volume** (bijv. `C:\MapA` → `C:\MapB`) | Blijven **behouden**. | Oude overgenomen rechten verdwijnen; het object neemt de rechten van de **nieuwe bovenliggende map** over. |
| **Verplaatsen naar een ander volume** (bijv. `C:\` → `D:\`) | Gaan **verloren**. | Neemt alle rechten over van de **nieuwe bovenliggende map** op het doelvolume. |
| **Kopiëren** (binnen hetzelfde of naar ander volume) | Gaan **verloren** (het wordt een nieuw object). | Neemt alle rechten over van de **nieuwe bovenliggende map**. |

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: RBAC-toegang Configureren & Het "Parent Folder Traverse"-probleem Oplossen
Wanneer een specifieke groep (bijv. `Leaders`) toegang moet krijgen tot een dieper gelegen submap (`C:\Hall_of_Justice\Leadership`) zonder dat zij rechten hebben op de bovenliggende map (`C:\Hall_of_Justice`), treedt er een klassiek toegangsprobleem op:

1. **Inspecteer de bestaande rechtenstructuur:**
   ```cmd
   icacls C:\Hall_of_Justice /t
   net localgroup Leaders
   ```
2. **Ken rechten toe op de submap en controleer de Effective Access:**
   * Voeg via **Properties → Security → Edit → Add** de groep `Leaders` toe aan `Leadership` met *Allow Modify*.
   * Open **Properties → Security → Advanced → Effective Access**, selecteer een gebruiker uit die groep (bijv. `lex.luthor`) en klik op **View Effective Access**.
   * *Valkuil:* Hoewel `lex.luthor` op `Leadership` zelf alle *Modify*-rechten heeft, blijkt uit **Effective Access** op de bovenliggende map `Hall_of_Justice` dat hij daar **geen rechten** heeft om door de map heen te bladeren (*Traverse Folder*). Via Verkenner kan hij de map dus niet bereiken.
3. **Vermijd "permission pinholes" door de mappenstructuur te herpositioneren:**
   * Geef **geen** losse *Traverse Folder*-uitzonderingen op `Hall_of_Justice` (dit leidt tot onbeheerbare *pinholes* in je toegangsmodel).
   * Verplaats (*Cut & Paste*) de map `Leadership` in plaats daarvan rechtstreeks naar de root van `C:\` (`C:\Leadership`), waar standaardgebruikers wel voldoende basistoegang hebben om doorheen te navigeren.

### Scenario 2: Overerving Blokkeren & Ongewenste Standaardgroepen (`BUILTIN\Users`) Verwijderen
Na het verplaatsen van `Leadership` naar `C:\Leadership` erft de map automatisch alle standaardmachtigingen van `C:\`, waaronder lees- en uitvoerrechten voor `BUILTIN\Users` (alle lokale gebruikers). Zo schakel je dit veilig uit:

1. **Controleer de ACL na de verplaatsing:**
   ```cmd
   icacls C:\Leadership
   ```
   * *Observatie:* De expliciete rechten van `Leaders` zijn behouden gebleven tijdens de verplaatsing op `C:\`, de oude overgenomen rechten van `Heroes` zijn verdwenen, en `BUILTIN\Users` is nieuw geërfd van `C:\`.
2. **Schakel overerving uit met behoud van bestaande regels:**
   * Open **Properties → Security → Advanced** op `C:\Leadership`.
   * Klik op **Disable inheritance** en kies **Convert inherited permissions into explicit permissions on this object** (zodat systeemaccounts zoals `SYSTEM` en `Administrators` niet per ongeluk worden gewist).
3. **Verwijder de ongewenste `Users`-groep en valideer met `icacls`:**
   * Klik op **Edit**, selecteer `Users` (`BUILTIN\Users`), klik op **Remove** en bevestig met **OK**.
   * Valideer het eindresultaat vanaf de opdrachtprompt:
```cmd
icacls C:\Leadership /t
```
   * Controleer met **Effective Access** op zowel `C:\` als `C:\Leadership` dat `lex.luthor` nu zonder omwegen bij `C:\Leadership` kan en daar *Modify*-rechten bezit, terwijl andere lokale gebruikers geen toegang hebben.

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `CMD.md` en `PowerShell.md` voor `icacls`, `net localgroup`, `Get-Acl` en `Get-LocalGroupMember`.
  * Zie `BASH.md` voor Linux-permissiebeheer (`chmod`, `chown`, `getfacl`, `setfacl`).
* **[Aanvullend] Officiële Documentatie & Security Referenties:**
  * [Microsoft Learn: `icacls` Command Reference](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/icacls) — Volledige lijst van alle `icacls`-switches, permissiecodes en overervingsvlaggen.
  * [Microsoft Learn: Access Control Overview](https://learn.microsoft.com/en-us/windows/security/identity-protection/access-control/access-control) — Officiële documentatie over SID's, ACL's, ACE's en overervingsregels in Windows.