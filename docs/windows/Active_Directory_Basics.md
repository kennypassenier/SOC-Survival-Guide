# Active Directory Basics

## 1. Overzicht van Relevante Commando's & Tools

### A. PowerShell AD DS Installatie & Domeinpromotie (`Install-WindowsFeature`, `Install-ADDSForest`, `Get-ADDomain`)

#### `Install-WindowsFeature`
* **Doel:** Installeert de **Active Directory Domain Services (AD DS)** serverrol inclusief de bijbehorende grafische en PowerShell-beheertools op een Windows Server.
* **Parameters & Opties:**
  * `-Name AD-Domain-Services`: De exacte rolnaam voor Active Directory Domain Services.
  * `-IncludeManagementTools`: Installeert direct alle beheerconsoles (zoals *Active Directory Users and Computers* / `dsa.msc`) en de PowerShell `ActiveDirectory`-module.
* **Praktijkgebruik:**
  ```powershell
  # Installeer de AD DS-rol inclusief alle beheertools
  Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
  ```

#### `Install-ADDSForest`
* **Doel:** Promoveert een Windows Server tot de eerste **Domain Controller (DC)** van een volledig nieuw Active Directory **Forest** en **Root Domain**, en installeert direct de geïntegreerde DNS-serverrol.
* **Parameters & Opties:**
  * `-DomainName "<fqdn>"`: De DNS-naam van het nieuwe root-domein (bijv. `"legionofdoom.local"`).
  * `-CreateDnsDelegation:$false`: Slaat het aanmaken van een DNS-delegatie naar een bovenliggende DNS-zone over.
  * `-DatabasePath "<pad>"`: Locatie van de AD-database (`NTDS.dit`, standaard `"C:\Windows\NTDS"`).
  * `-LogPath "<pad>"`: Locatie van de AD-transactielogboeken (standaard `"C:\Windows\NTDS"`).
  * `-SysvolPath "<pad>"`: Locatie van de `SYSVOL`-map voor Group Policy-objecten en logonscripts (standaard `"C:\Windows\SYSVOL"`).
  * `-DomainMode "7"` & `-ForestMode "7"`: Stelt het *Domain Functional Level* en *Forest Functional Level* in (niveau `7` = Windows Server 2016).
  * `-DomainNetbiosName "<naam>"`: De NetBIOS-naam van het domein (maximaal **15 tekens**, bijv. `"LEGIONOFDOOM"`).
  * `-InstallDns:$true`: Installeert en configureert de DNS-serverrol op deze Domain Controller.
  * `-NoRebootOnCompletion:$False`: Herstart de server automatisch zodra de promotie is voltooid.
  * `-Force:$true`: Voert de promotie uit zonder interactieve bevestigingsprompts (vraagt alleen nog om het **DSRM**-wachtwoord).
* **Praktijkgebruik:**
  ```powershell
  # Maak een nieuw AD-forest en root-domein aan en promoveer de server tot Domain Controller
  Install-ADDSForest -DomainName "legionofdoom.local" -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "7" -DomainNetbiosName "LEGIONOFDOOM" -ForestMode "7" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$False -SysvolPath "C:\Windows\SYSVOL" -Force:$true
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * Bewaar het **Directory Services Restore Mode (DSRM)**-wachtwoord veilig; dit is het lokale herstelwachtwoord waarmee een beheerder kan inloggen wanneer de Active Directory-database offline hersteld of gerepareerd moet worden.
  * Een NetBIOS-domeinnaam mag **maximaal 15 tekens** lang zijn.
  * **[Aanvullend] Modernere Domeinnaamgeving & Best Practices:** Gebruik in productieomgevingen bij voorkeur **geen `.local`**-top-level domain (dit conflicteert met mDNS/Bonjour op Linux en macOS). Gebruik in plaats daarvan een subdomein van een geregistreerd bedrijfsdomein, zoals `ad.bedrijf.nl` of `corp.bedrijf.be`. Voor het toevoegen van een extra Domain Controller aan een bestaand domein gebruik je `Install-ADDSDomainController`.

#### `Get-ADDomain`
* **Doel:** Toont de eigenschappen van het huidige Active Directory-domein, waaronder de **Distinguished Name (`DistinguishedName`)**, NetBIOS-naam, DNS-root en FSMO-rolhouders.
* **Praktijkgebruik:**
  ```powershell
  # Bekijk de domeininformatie en de Distinguished Name (bijv. DC=legionofdoom,DC=local)
  Get-ADDomain
  ```
* **[Aanvullend] Aanvullende Verificatie-cmdlets:** Gebruik `Get-ADForest` om het volledige forest (inclusief alle vertrouwde domeinen en Global Catalogs) te inspecteren, en `Get-ADDomainController -Filter *` om alle Domain Controllers op te vragen.

---

### B. PowerShell AD Objectbeheer (OUs, Users & Groups)

#### `New-ADOrganizationalUnit` & `Get-ADOrganizationalUnit`
* **Doel:**
  * `New-ADOrganizationalUnit`: Maakt een nieuwe **Organizational Unit (OU)** aan binnen een opgegeven domein- of ouderpad.
  * `Get-ADOrganizationalUnit`: Zoekt en toont bestaande Organizational Units op basis van een filter.
* **Parameters & Opties:**
  * `-Name "<naam>"`: De naam van de nieuwe OU (spaties zijn toegestaan, bijv. `"Hall of Doom"`).
  * `-Path "<DN>"`: De *Distinguished Name* van de bovenliggende container of OU (bijv. `"DC=legionofdoom,DC=local"`).
  * `-Filter ' Name -like "*" '`: Filterexpressie die alle OU's ophaalt.
* **Praktijkgebruik & Permutaties:**
  ```powershell
  # Maak een nieuwe Organizational Unit aan
  New-ADOrganizationalUnit -Name "Hall of Doom" -Path "DC=legionofdoom,DC=local"

  # Controleer alle aangemaakte OU's in tabelformaat
  Get-ADOrganizationalUnit -Filter ' Name -like "*" ' | Format-Table Name
  ```

#### `New-ADUser` & `Get-ADUser`
* **Doel:**
  * `New-ADUser`: Maakt een nieuw Active Directory-gebruikersaccount aan binnen een specifieke OU en activeert dit direct.
  * `Get-ADUser`: Zoekt en inspecteert AD-gebruikersaccounts op basis van een filter of naam.
* **Parameters & Opties:**
  * `-Name "<volledige naam>"`: De weergave-/objectnaam in AD (bijv. `"Lex Luthor"`).
  * `-DisplayName "<naam>"`, `-GivenName "<voornaam>"`, `-Surname "<achternaam>"`: Persoonsgegevens voor het gebruikersobject.
  * `-SamAccountName "<logon>"`: De klassieke pre-Windows 2000 aanmeldnaam (bijv. `"lex.luthor"`).
  * `-UserPrincipalName "<upn>"`: De moderne aanmeldnaam in e-mailformaat (`lex.luthor@legionofdoom.local`).
  * `-Path "<OU_DN>"`: De exacte locatie (OU) waarin het account wordt geplaatst (bijv. `"OU=Hall of Doom,DC=legionofdoom,DC=local"`).
  * `-AccountPassword (Read-Host -AsSecureString "Input Password")`: Vraagt veilig en gemaskeerd naar het wachtwoord.
  * `-Enabled:$true`: Activeert het account direct (zonder deze vlag maakt `New-ADUser` standaard een uitgeschakeld account aan).
* **Praktijkgebruik & Permutaties:**
  ```powershell
  # Maak een nieuw actief AD-gebruikersaccount aan in een specifieke OU
  New-ADUser -Name "Lex Luthor" -DisplayName "Lex Luthor" -GivenName "Lex" -Surname "Luthor" -SamAccountName "lex.luthor" -UserPrincipalName "lex.luthor@legionofdoom.local" -Path "OU=Hall of Doom,DC=legionofdoom,DC=local" -AccountPassword (Read-Host -AsSecureString "Input Password") -Enabled:$true

  # Zoek een gebruiker op naam
  Get-ADUser -Filter ' Name -like "Lex*" '
  ```
* **[Aanvullend] SOC-triage & Extra User-cmdlets:**
  * `Get-ADUser -Identity lex.luthor -Properties *`: Toont alle attributen van een gebruiker (waaronder `LastLogonDate`, `PasswordLastSet`, `MemberOf` en `LockedOut`).
  * `Unlock-ADAccount -Identity lex.luthor` & `Disable-ADAccount -Identity lex.luthor`: Account ontgrendelen of bij een incident direct blokkeren.

#### `New-ADGroup`, `Get-ADGroup`, `Add-ADGroupMember` & `Get-ADGroupMember`
* **Doel:**
  * `New-ADGroup`: Maakt een nieuwe Active Directory-groep aan (Security of Distribution, met scope Global, DomainLocal of Universal).
  * `Get-ADGroup`: Zoekt groepen op in Active Directory.
  * `Add-ADGroupMember`: Voegt één of meer gebruikers of groepen toe als lid van een AD-groep.
  * `Get-ADGroupMember`: Toont alle huidige leden van een opgegeven AD-groep.
* **Parameters & Opties:**
  * `-GroupCategory Security` (of `Distribution`): Bepaalt of de groep gebruikt wordt voor toegangsrechten (`Security`) of e-maillijsten (`Distribution`).
  * `-GroupScope Global` (of `DomainLocal` / `Universal`): Bepaalt het bereik van de groep binnen het domein of forest.
  * `-Identity "<groepsnaam>"`: De naam of DN van de doelgroep.
  * `-Members <account>`: Eén of meer gebruikers-/groepsnamen (kommagescheiden).
* **Praktijkgebruik & Permutaties:**
  ```powershell
  # Maak een nieuwe Global Security Group aan binnen een OU
  New-ADGroup -Name "Villains" -SamAccountName "Villains" -GroupCategory Security -GroupScope Global -DisplayName "Villains" -Path "OU=Hall of Doom,DC=legionofdoom,DC=local"

  # Controleer of de groep bestaat
  Get-ADGroup -Filter ' Name -like "Villains" '

  # Voeg gebruiker 'lex.luthor' toe aan de groep 'Villains'
  Add-ADGroupMember -Identity "Villains" -Members lex.luthor

  # Controleer alle leden van de groep 'Villains'
  Get-ADGroupMember -Identity "Villains"
  ```
* **[Aanvullend] Linux- en Cloud-equivalenten:**
  * **Cloud (Microsoft Entra ID / Azure AD):** Het cloud-equivalent van on-premises Active Directory is **Microsoft Entra ID**, beheerd via PowerShell met de `Microsoft.Graph`-module (`New-MgUser`, `New-MgGroup`, `New-MgGroupMember`).
  * **Linux (Debian/Ubuntu & Arch):** Lokale groepen en gebruikers beheer je met `groupadd`, `usermod -aG <groep> <gebruiker>` en `getent group <groep>`. Voor centrale domeinauthenticatie op Linux worden **FreeIPA** of **Samba Active Directory DC** gebruikt.

---

### C. GUI-beheerconsoles & Lab-verificatie

#### `dsa.msc` & `servermanager`
* **Doel:**
  * `dsa.msc`: Opent **Active Directory Users and Computers (ADUC)** (via *Uitvoeren* / `Win + R` of de CLI) om grafisch OU's, gebruikers, computers en groepen te beheren.
  * `servermanager`: Opent de **Windows Server Manager** om rollen en features (*Add Roles and Features*) toe te voegen en een server tot Domain Controller te promoveren.
* **Praktijkgebruik:**
  ```cmd
  :: Open Active Directory Users and Computers (ADUC)
  dsa.msc
  ```

---

## 2. Algemene Uitleg & Theorie

### Kerncomponenten van Active Directory
* **Active Directory (AD):** Een hiërarchische, gecentraliseerde database die informatie opslaat over objecten op het netwerk — zoals **users**, **groups** en **computers** — om gebruikers te identificeren en gecontroleerde toegang tot netwerkbronnen te verlenen.
* **Domain Controller (DC):** Een Windows Server waarop de **Active Directory Domain Services (AD DS)**-rol draait en die authenticatie- en autorisatiediensten levert aan gebruikers en computers binnen het domein.
* **Forest (Het hoogste niveau & Beveiligingsgrens):**
  * De eerste installatie van Active Directory creëert automatisch een **forest**: het hoogste niveau in de AD-hiërarchie.
  * **Ultimate Security Boundary:** Een forest vormt de ultieme beveiligingsgrens (niet het domein!). Beheerdersrechten gelden niet automatisch buiten het forest, tenzij er expliciet een *Forest Trust* wordt opgezet.
  * **Transitive Trusts:** Alle domeinen binnen hetzelfde forest vertrouwen elkaar automatisch via **transitieve vertrouwensrelaties** (*transitive trust relationships*), waardoor authenticatie tussen domeinen naadloos verloopt.
  * **Gedeelde onderdelen binnen een forest:** Alle domeinen in een forest delen hetzelfde **Schema** (de blauwdruk van alle mogelijke objecttypen en hun attributen), dezelfde **Global Catalog** en dezelfde **Configuration Container**.
* **Domain (Administratieve grens):**
  * Een logische groepering binnen een forest die fungeert als **administratieve grens** (*administrative boundary*).
  * Elk domein beheert zijn eigen AD-database, groepsbeleid (GPO's), wachtwoordbeleid en beveiligingsinstellingen. Meerdere domeinen binnen een forest vormen samen een boomstructuur onder een gedeelde DNS-naamruimte (bijv. `cybrary.it`, `eu.cybrary.it` en `sa.cybrary.it`).
* **Organizational Units (OUs) vs. Standaard Containers:**
  * Een domein wordt onderverdeeld in **Organizational Units (OUs)** om de structuur van een organisatie (afdelingen, locaties, rollen) logisch weer te geven.
  * **Cruciaal verschil:** Standaard aangemaakte mappen in AD (zoals *Users* en *Computers*) zijn **Containers**, geen OU's. **Group Policy Objects (GPO's) kunnen niet rechtstreeks aan Containers worden gekoppeld**, maar wél aan **OUs**. Plaats nieuwe gebruikers en computers daarom altijd in zelf aangemaakte OU's.

### De Symbiotische Relatie tussen Active Directory en DNS
* **DNS als fundament van AD:** Domain Name System (DNS) is geen optionele extra dienst, maar diep verweven met de werking van Active Directory. Clients en Domain Controllers gebruiken DNS (specifiek DNS SRV-records) om elkaar te vinden en te authenticeren.
* **Troubleshooting-vuistregel:** Op tijdsynchronisatieproblemen (Kerberos-tijdsverschil > 5 minuten) na, zijn **vrijwel alle storingen in Active Directory terug te voeren op een verkeerd geconfigureerde DNS**.

### Active Directory Groepen & Best Practice: AGDLP
* **Twee groepscategorieën:**
  1. **Distribution Groups:** Uitsluitend bedoeld voor e-maildistributielijsten (bijv. in combinatie met Microsoft Exchange); kunnen niet worden gebruikt om toegangsrechten toe te wijzen.
  2. **Security Groups:** De primaire manier om machtigingen op netwerkbronnen (mappen, printers, shares) toe te kennen.
* **De drie groepsscopes:**
  * **Universal Groups:** Kunnen gebruikers en groepen bevatten uit **elk domein** binnen het gehele forest.
  * **Global Groups:** Kunnen gebruikers en groepen bevatten uit **hetzelfde domein** (worden gebruikt om gebruikers met vergelijkbare functies te groeperen).
  * **Domain Local Groups:** Worden gebruikt om daadwerkelijk **toegangsrechten (permissies)** toe te wijzen aan bronnen binnen dat specifieke domein.
* **Het AGDLP-principe (Microsoft Best Practice):**
  * **A**ccounts (gebruikers) → worden lid van **G**lobal Groups (functierollen) → worden lid van **D**omain **L**ocal Groups (toegangsgroepen op een bron) → krijgen **P**ermissions (machtigingen zoals *Modify* of *Read* op een map of share).
  * Dit voorkomt een onbeheersbaar web van directe gebruikersrechten op mappen en servers.

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Een Nieuw AD Forest & Domain Controller Opzetten via PowerShell
Het geautomatiseerd uitrollen van een nieuw Active Directory-domein (`legionofdoom.local`) inclusief DNS op een schone Windows Server:

1. **Installeer de AD DS-rol en beheertools:**
   ```powershell
   Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
   ```
2. **Promoveer de server tot Domain Controller van een nieuw forest:**
   ```powershell
   Install-ADDSForest -DomainName "legionofdoom.local" -CreateDnsDelegation:$false -DatabasePath "C:\Windows\NTDS" -DomainMode "7" -DomainNetbiosName "LEGIONOFDOOM" -ForestMode "7" -InstallDns:$true -LogPath "C:\Windows\NTDS" -NoRebootOnCompletion:$False -SysvolPath "C:\Windows\SYSVOL" -Force:$true
   ```
   * Voer tweemaal het DSRM-herstelwachtwoord in (`P@ssw0rd!`). De server herstart hierna automatisch (dit duurt tot 5 minuten).
3. **Verifieer na herstart de domeinconfiguratie:**
   ```powershell
   Get-ADDomain
   ```
   * Controleer de `DistinguishedName` (`DC=legionofdoom,DC=local`) en controleer of de DNS- en AD-services draaien.

### Scenario 2: OU's, Gebruikers en Security Groups Inrichten (PowerShell vs. ADUC GUI)
Het bouwen van een gestructureerde organisatie-eenheid met gebruikers en beveiligingsgroepen:

1. **Via PowerShell (snel en reproduceerbaar):**
   ```powershell
   # 1. Maak de Organizational Unit aan
   New-ADOrganizationalUnit -Name "Hall of Doom" -Path "DC=legionofdoom,DC=local"

   # 2. Maak het actieve gebruikersaccount aan in de nieuwe OU
   New-ADUser -Name "Lex Luthor" -DisplayName "Lex Luthor" -GivenName "Lex" -Surname "Luthor" -SamAccountName "lex.luthor" -UserPrincipalName "lex.luthor@legionofdoom.local" -Path "OU=Hall of Doom,DC=legionofdoom,DC=local" -AccountPassword (Read-Host -AsSecureString "Input Password") -Enabled:$true

   # 3. Maak een Global Security Group aan en voeg de gebruiker toe
   New-ADGroup -Name "Villains" -SamAccountName "Villains" -GroupCategory Security -GroupScope Global -DisplayName "Villains" -Path "OU=Hall of Doom,DC=legionofdoom,DC=local"
   Add-ADGroupMember -Identity "Villains" -Members lex.luthor

   # 4. Verifieer het resultaat
   Get-ADGroupMember -Identity "Villains"
   ```
2. **Via Active Directory Users and Computers (`dsa.msc`):**
   * Start `dsa.msc`, klik met rechts op het domein (`superfriends.local`) → **New → Organizational Unit** (`Hall of Justice`).
   * Klik met rechts op de OU `Hall of Justice` → **New → User** (`bruce.wayne`) en stel het wachtwoord in.
   * Klik met rechts op de OU `Hall of Justice` → **New → Group** (`Heroes`, Scope: *Global*, Type: *Security*), open de eigenschappen van de groep en voeg `Bruce Wayne` toe op het tabblad **Members**.

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `PowerShell.md` voor alle `ActiveDirectory`-cmdlets (`Install-ADDSForest`, `Get-ADDomain`, `New-ADOrganizationalUnit`, `New-ADUser`, `New-ADGroup`, `Add-ADGroupMember`, `Get-ADGroupMember`).
  * Zie `CMD.md` voor het openen van de ADUC-console (`dsa.msc`).
* **[Aanvullend] Officiële Documentatie & Security Referenties:**
  * [Microsoft Learn: Active Directory Domain Services Overview](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview) — Officiële documentatie over Forests, Domeinen, Schema's en Global Catalogs.
  * [Microsoft Learn: Active Directory PowerShell Module](https://learn.microsoft.com/en-us/powershell/module/activedirectory/) — Volledige cmdlet-referentie voor AD-beheer en automatisering.
  * [MITRE ATT&CK TA0006 / TA0007: Active Directory Discovery & Credential Access](https://attack.mitre.org/) — Overzicht van hoe SOC-analisten verdachte AD-enumeratie (zoals massale `Get-ADUser` / `Get-ADGroupMember`-queries) herkennen.