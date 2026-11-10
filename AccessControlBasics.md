# Access Control Basics & Windows File System Permissions

Een diepgaande technische naslaggids over toegangscontrolemodellen (MAC, DAC, RBAC), Windows NTFS-permissiestructuren, overerving (inheritance), het verplaatsen en kopiëren van objecten, effectieve rechten en auditing met `icacls`.

---

## 1. Concepten van Toegangscontrole

Toegangscontrole (**Access Control**) is het proces waarbij een geauthenticeerd subject autorisatie krijgt om specifieke acties uit te voeren op een object (zoals bestanden, mappen, netwerkshares of registersleutels).

### Kernbegrippen
* **Subject:** De entiteit die actie onderneemt (een gebruiker, groep, service-account of computersysteem).
* **Authentication:** De initiële stap waarin een subject diens identiteit bewijst (via wachtwoord, certificaat, biometrie, etc.).
* **Security Principal:** Zodra een subject succesvol geauthenticeerd is, wordt het aangeduid als een security principal.
* **Security Identifier (SID):** Een unieke alfanumerieke tekenreeks die door Windows aan elke security principal wordt toegekend (bijvoorbeeld `S-1-5-21-...`). Windows berekent rechten uitsluitend op basis van de SID, nooit op basis van de weergavenaam.
* **Object:** De bron of entiteit waartoe toegang wordt gezocht (bestand, map, printer, registersleutel).
* **Access Control Entry (ACE):** Een individuele regel die een specifieke permissie koppelt aan een SID.
<pre>
Formule: SID + Permissie + Type (Allow/Deny) = ACE
Voorbeeld: SID(S-1-5-21-...) + Write + Allow = 1 ACE
</pre>
* **Access Control List (ACL):** De complete verzameling van alle ACE-regels die aan een specifiek object zijn gekoppeld. Er zijn twee soorten ACL's:
  * **DACL (Discretionary ACL):** Bepaalt wie daadwerkelijk toegang heeft en met welke rechten.
  * **SACL (System ACL):** Bepaalt welke gebeurtenissen (succesvolle of mislukte toegangspogingen) gelogd worden in het Security Event Log ten behoeve van auditing.

---

## 2. Toegangscontrole Modellen (Access Control Models)

| Eigenschap | Discretionary Access Control (DAC) | Role-Based Access Control (RBAC) | Mandatory Access Control (MAC) |
| :--- | :--- | :--- | :--- |
| **Wie bepaalt toegang?** | De eigenaar (*Creator Owner*) van het object. | De beheerder, op basis van bedrijfsfuncties. | Het besturingssysteem/security kernel beleid. |
| **Grondslag** | Directe toekenning van ACE's aan gebruikers of objecten. | Lidmaatschap van groepen die functie-rollen representeren. | Security Labels (Classificatie en Compartiment/Categorie). |
| **Flexibiliteit** | Zeer hoog, maar gevoelig voor wildgroei en beheerfouten. | Hoog, schaalbaar en overzichtelijk in organisaties. | Zeer star; gericht op absolute data-isolatie. |
| **Implementatie in Windows** | Lokale NTFS ACL's met individuele gebruikers-SIDs. | Groepen (bijv. *Finance*, *HR*, *Heroes*) met specifieke functierechten. | Niet standaard aanwezig (vergelijkbaar met SELinux MLS / defensie). |

---

## 3. Windows NTFS Permissies

Windows kent zes standaard bestands- en mappermissies. Achter de schermen zijn deze opgebouwd uit **14 geavanceerde permissies** (granular permissions).

### De Zes Standaard Permissies

| Standaard Permissie | Omschrijving en Rechten |
| :--- | :--- |
| **Full Control** | Volledige controle: lezen, schrijven, uitvoeren, verwijderen, submappen wissen, rechten wijzigen (`Change Permissions`) en eigenaarschap overnemen (`Take Ownership`). |
| **Modify** | Lezen, schrijven, uitvoeren en bestanden/mappen verwijderen. Mag de permissies of eigenaar **niet** aanpassen. |
| **Read & Execute** | Bestanden inzien, door mappen bladeren en uitvoerbare binaries/scripts draaien. |
| **List Folder Contents** | Uitsluitend van toepassing op mappen: de inhoud en bestandsnamen van een directory tonen. |
| **Read** | Bestanden openen, attributen en metadata bekijken. |
| **Write** | Nieuwe bestanden en mappen aanmaken, data wegschrijven en attributen wijzigen. |

### Evaluatieregels: Allow vs. Deny
1. **Explicit Deny heeft voorrang:** Een expliciete `DENY` overschrijft altijd een `ALLOW` (ongeacht groepslidmaatschap). Heeft een gebruiker `Allow Modify` via groep A, maar `Deny Read` via groep B, dan kan de gebruiker het bestand **niet** openen.
2. **Explicit overschrijft Inherited:** Een expliciete toekenning direct op een object weegt zwaarder dan een overgeërfde regel van een bovenliggende map.
3. **Cumulative Permissions:** Rechten via meerdere groepen tellen bij elkaar op (bijvoorbeeld `Read` via groep A + `Write` via groep B = `Read & Write`).
4. **Best Practice:** Vermijd het gebruik van `DENY`. Blokkeer toegang door géén permissies toe te kennen in plaats van expliciete verboden in te stellen, om onoverzichtelijke permissieknooppunten te voorkomen.

---

## 4. Overerving (Inheritance) & Bestandstransacties

Overerving zorgt ervoor dat ACE's van een bovenliggende map (parent) automatisch doorstromen naar onderliggende mappen en bestanden (children).

### Gedrag bij Kopiëren en Verplaatsen

<pre>
Actie                                          Resultaat voor NTFS Permissies
---------------------------------------------------------------------------------------------------------
Kopiëren (Binnen hetzelfde volume)             Verliest originele permissies. Erft permissies van de NIEUWE doelmap.
Kopiëren (Naar een ander volume)               Verliest originele permissies. Erft permissies van de NIEUWE doelmap.
Verplaatsen (Binnen hetzelfde volume)          BEHOUDT expliciete permissies. Verliest oude overgeërfde permissies,
                                               erft nieuwe overgeërfde permissies van de doelmap.
Verplaatsen (Naar een ander volume)            Wordt behandeld als Copy + Delete: verliest alles en erft uitsluitend
                                               permissies van de NIEUWE doelmap.
</pre>

### Overerving Uitschakelen (Disabling Inheritance)
Wanneer overerving wordt verbroken via de GUI of CLI, dwingt Windows een keuze af:
1. **Convert inherited permissions into explicit permissions:** Behoudt de huidige regels als statische, bewerkbare regels direct op het object (aanbevolen om lock-outs te voorkomen).
2. **Remove all inherited permissions:** Begint met een volledig schone lei (geen enkele toegang, tenzij expliciet opnieuw toegekend).

---

## 5. Command-Line Auditing & Modificatie: `icacls`

`icacls` is de ingebouwde Windows-tool voor het inspecteren, back-uppen en aanpassen van DACL's over complete mappenstructuren.

### Betekenis van icacls Notaties en Maskers

<pre>
Permissie Codes:
  (F)  : Full Control
  (M)  : Modify
  (RX) : Read and Execute
  (R)  : Read-only
  (W)  : Write-only

Overervings- en Toepassingsvlaggen:
  (I)  : Inherited (overgeërfd van een parent container)
  (OI) : Object Inherit (bestanden in deze map erven deze ACE)
  (CI) : Container Inherit (submappen in deze map erven deze ACE)
  (IO) : Inherit Only (permissie geldt NIET voor de map zelf, alleen voor de inhoud)
  (NP) : Do Not Propagate (permissie wordt niet verder naar beneden doorgegeven)
</pre>

### Veelgebruikte `icacls` Commando's

* **Huidige permissies van een map bekijken:**
<pre>
icacls C:\Hall_of_Justice
</pre>

* **Recursief alle rechten van bestanden en submappen weergeven:**
<pre>
icacls C:\Hall_of_Justice /t
</pre>

* **Een groep expliciet Modify-rechten toekennen met overerving:**
<pre>
icacls C:\TargetFolder /grant "Heroes":(OI)(CI)(M)
</pre>

* **Overerving uitschakelen en overgeërfde regels converteren naar expliciet:**
<pre>
icacls C:\Leadership /inheritance:d
</pre>

* **Overerving uitschakelen en alle overgeërfde regels direct verwijderen:**
<pre>
icacls C:\Leadership /inheritance:r
</pre>

* **Een specifieke groep of gebruiker volledig verwijderen uit de DACL:**
<pre>
icacls C:\Leadership /remove "BUILTIN\Users"
</pre>

---

## 6. Lab Walkthrough: Mappenstructuren, RBAC & Effective Access

### Stap 1: Initiële Structuur en Permissies Inspecteren
Open een command prompt op de root van de systeemschijf (`C:\`):

<pre>
# Mappen en bestanden recursief visualiseren
tree Hall_of_Justice /F
tree Hall_of_Doom /F

# Basispermissies inspecteren
icacls Hall_of_Justice
</pre>

De uitvoer toont standaard dat `CREATOR OWNER`, `NT AUTHORITY\SYSTEM`, `BUILTIN\Administrators` en de lokale gebruiker `cybrary` volledige rechten `(F)` hebben. `CREATOR OWNER` heeft de vlaggen `(OI)(CI)(IO)`, wat betekent dat degene die een bestand aanmaakt automatisch volledige controle krijgt over het gemaakte item.

Recursieve controle via CLI:
<pre>
icacls Hall_of_Justice /t
</pre>

---

### Stap 2: RBAC Permissies Configureren (Heroes & Villains)

Doelstelling:
* Groep `Heroes` krijgt **Modify** op `C:\Hall_of_Justice` en alle onderliggende objecten.
* Groep `Villains` krijgt **Read & Execute**, **List Folder Contents** en **Read** op `C:\Hall_of_Doom`.

Configuratie via GUI (`Properties > Security > Edit > Add`):
1. Voeg `Heroes` toe aan `Hall_of_Justice`, vink **Allow Modify** aan en sla op.
2. Voeg `Villains` toe aan `Hall_of_Doom`, vink **Allow Read & Execute**, **List Folder Contents** en **Read** aan.

Verificatie met `icacls`:
<pre>
icacls Hall_of_Justice /t
icacls Hall_of_Doom /t
</pre>
De output toont nu voor de onderliggende items de notatie `(I)(M)` voor Heroes, wat aantoont dat Modify succesvol overgeërfd is.

---

### Stap 3: Het Traverse Checking Probleem (Lex Luthor & Leadership)

Er wordt een gedeelde map aangemaakt: `C:\Hall_of_Justice\Leadership`. De rol-groep `Leaders` krijgt expliciet **Modify** op deze map.

Controle van groepslidmaatschap:
<pre>
net localgroup Leaders
</pre>
*Lid:* `lex.luthor`.

Hoewel Lex lid is van `Leaders` en expliciete rechten heeft op `Leadership`:
1. Open `Properties > Security > Advanced > Effective Access` op `C:\Hall_of_Justice\Leadership`.
2. Selecteer gebruiker `lex.luthor` en klik op **View Effective Access**.
3. *Resultaat:* Lex lijkt op papier alle rechten te hebben op de map zélf.
4. Controleer nu de **Effective Access** op de bovenliggende map `C:\Hall_of_Justice`:
5. *Resultaat:* Lex heeft **geen** rechten om door de bovenliggende map te bladeren (`Traverse Folder`). Zonder toegang tot het bovenliggende pad kan Lex de submap fysiek niet bereiken.

---

### Stap 4: Herstructurering & Isolatie (Verplaatsen naar C:\)

In plaats van onveilige uitzonderingen (pinholes) te maken in de beveiliging van `Hall_of_Justice`, wordt de architectuur aangepast door de map te verplaatsen naar `C:\`:

1. Verplaats `C:\Hall_of_Justice\Leadership` naar `C:\Leadership`.
2. Inspecteer direct de resulterende rechten via `icacls`:
<pre>
icacls C:\Leadership
</pre>

*Observaties:*
* De rechten voor `Heroes` zijn verdwenen (want die waren overgeërfd van `Hall_of_Justice`).
* De expliciete rechten voor `Leaders` zijn behouden gebleven.
* Er is ongewenste overerving bijgekomen: `BUILTIN\Users` heeft nu overgeërfde rechten vanaf `C:\`.

---

### Stap 5: Overerving Breken en Opschonen

Om te voorkomen dat alle standaardgebruikers toegang krijgen tot de directiekamer:

1. Open `Properties > Security > Advanced` op `C:\Leadership`.
2. Klik op **Disable inheritance**.
3. Kies: **Convert inherited permissions into explicit permissions on this object**.
4. Klik op OK.
5. Ga naar `Edit Permissions`, selecteer de groep **Users** en klik op **Remove**.

Valideer het eindresultaat via de commandline:
<pre>
icacls C:\Leadership
</pre>
*Uitkomst:* Alle overgeërfde markeringen `(I)` en de groep `Users` zijn verdwenen. Uitsluitend administrators, SYSTEM en de groep `Leaders` hebben toegang.

Controleer via **Effective Access**:
* Op `C:\` heeft Lex Luthor voldoende basale rechten om het station te benaderen.
* Op `C:\Leadership` heeft Lex Luthor volledige functionele toegang conform zijn rol binnen de groep `Leaders`.
