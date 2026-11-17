# Group Policy Basics

## 1. Overzicht van Relevante Commando's & Tools

### A. Group Policy Beheer & Troubleshooting (`gpupdate`, `gpresult`, `gpedit.msc`, `gpmc.msc`)

#### `gpupdate`
* **Doel:** Dwingt een onmiddellijke vernieuwing (*refresh*) af van zowel de lokale als de Active Directory Group Policy-instellingen op de computer en voor de ingelogde gebruiker (zonder te hoeven wachten op de standaard achtergrondcyclus van 90 minuten).
* **Parameters & Opties:**
  * `/force`: Past alle beleidsinstellingen opnieuw toe, ook de instellingen die sinds de laatste verversing niet zijn gewijzigd.
* **Praktijkgebruik:**
  ```powershell
  # Forceer het direct opnieuw toepassen van alle Computer- en User-policies
  gpupdate /force
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * Bepaalde beleidsinstellingen — zoals software-installaties, mapomleidingen (*Folder Redirection*) of computer-opstartscripts — kunnen niet altijd direct op de achtergrond worden toegepast en vereisen een herstart of opnieuw aanmelden (*logoff/logon*).
  * **[Aanvullend] Extra `gpupdate`-switches & PowerShell-equivalent:**
    * `gpupdate /target:computer /force` of `gpupdate /target:user /force`: Vernieuwt uitsluitend het computer- of gebruikersgedeelte.
    * **PowerShell-cmdlet:** `Invoke-GPUpdate -Force` (onderdeel van de `GroupPolicy`-module; kan met `-Computer "<hostnaam>"` ook op afstand op een domeincomputer worden uitgevoerd).

#### `gpresult`
* **Doel:** Genereert een **Resultant Set of Policy (RSoP)**-rapport op de opdrachtregel om te analyseren welke Group Policy Objects (GPO's) daadwerkelijk zijn toegepast, welke instellingen actief zijn en welke GPO heeft gewonnen bij een conflict.
* **Parameters & Opties:**
  * `/Z` (`Z` = super-verbose): Toont alle gedetailleerde beleidsinstellingen (inclusief *Administrative Templates* en registerwaarden) die voor de gebruiker en computer gelden.
  * `/R` **[Aanvullend]** (`R` = **R**esultant summary): Geeft een beknopt overzicht van toegepaste GPO's, groepslidmaatschappen en de laatst gebruikte Domain Controller.
  * `/H <pad.html>` **[Aanvullend]** (`H` = **H**TML report): Exporteert een overzichtelijk, klikbaar RSoP-rapport naar een HTML-bestand (bijv. `gpresult /H C:\Temp\rsop.html`).
* **Praktijkgebruik:**
  ```powershell
  # Genereer een volledig gedetailleerd RSoP-rapport in de console (inclusief Administrative Templates)
  gpresult /Z
  ```
* **Tips, Valkuilen & Modernere Mogelijkheden:**
  * Om in `gpresult /Z` ook de **Computer Configuration**-policies te kunnen zien, moet je het commando uitvoeren vanuit een verhoogde (**Administrator**) PowerShell- of CMD-sessie.
  * **[Aanvullend] PowerShell-alternatief:** `Get-GPResultantSetOfPolicy -ReportType Html -Path "C:\Temp\rsop.html"`.

#### `gpedit.msc` & `gpmc.msc`
* **Doel:**
  * `gpedit.msc`: Opent de **Local Group Policy Editor** om het lokale groepsbeleid op een individuele Windows-machine te bekijken en te configureren.
  * `gpmc.msc`: Opent de **Group Policy Management Console (GPMC)** op een Domain Controller of beheerwerkstation om domeinbrede GPO's aan te maken, te koppelen (*linken*), te bewerken en te simuleren (*Group Policy Modeling* / *Group Policy Results*).
* **Praktijkgebruik:**
  ```cmd
  :: Open de Local Group Policy Editor
  gpedit.msc

  :: Open de Group Policy Management Console (voor AD-domeinen)
  gpmc.msc
  ```
* **[Aanvullend] Linux- & Cloud-equivalenten (Debian/Ubuntu, Arch & Entra ID):**
  * **Cloud (Microsoft Entra ID / Intune):** In moderne cloud-only omgevingen wordt Group Policy vervangen door **Microsoft Intune Configuration Profiles** (MDM / CSP-policies) in combinatie met *Entra ID Conditional Access*.
  * **Linux (Debian/Ubuntu & Arch):** Er bestaat geen native GPO-engine, maar centraal configuratiebeheer wordt uitgevoerd met **Configuration Management / IaC-tools** zoals **Ansible**, **Puppet** of **SaltStack**. Voor Linux-clients die aan een Active Directory-domein zijn gekoppeld, kunnen **SSSD (`sssd-ad`)** of **Ubuntu ADSys** een subset van AD Group Policies toepassen.

---

### B. Ondersteunende PowerShell Cmdlets voor AD & Groepsbeheer

#### `Import-Module`, `New-ADOrganizationalUnit` & `Add-ADGroupMember`
* **Doel:**
  * `Import-Module .\Install-AD.ps1`: Laadt een lokaal PowerShell-script of -module in de huidige sessie (zoals het hulpscript met `Invoke-ADInstaller -DomainName cybrary.local`).
  * `New-ADOrganizationalUnit`: Maakt een hiërarchie van Organizational Units (OU's) aan waarop domein-GPO's gekoppeld kunnen worden (bijv. `Cybrary` en een geneste sub-OU `Engineering`).
  * `Add-ADGroupMember` & `Get-ADGroupMember`: Voegt een gebruiker toe aan `"Domain Admins"` en controleert het groepslidmaatschap (vereist na aanpassing een *Sign out* en opnieuw inloggen voordat het nieuwe Kerberos-toegangstoken actief wordt).
* **Praktijkgebruik & Permutaties:**
  ```powershell
  # Voeg gebruiker 'cybrary' toe aan Domain Admins en verifieer
  Add-ADGroupMember -Identity "Domain Admins" -Members "cybrary"
  Get-ADGroupMember -Identity "Domain Admins"

  # Maak een hoofd-OU en een geneste sub-OU aan voor gelaagde GPO-toepassing
  New-ADOrganizationalUnit -Name "Cybrary" -Path "DC=cybrary,DC=local"
  New-ADOrganizationalUnit -Name "Engineering" -Path "OU=Cybrary,DC=cybrary,DC=local"
  ```

---

## 2. Algemene Uitleg & Theorie

### Werking & Architectuur van Group Policy
* **Definitie & Historie:** Group Policy is een Windows-beheermechanisme (geïntroduceerd in **1999** met **Windows 2000** en Active Directory) waarmee beheerders gecentraliseerd instellingen voor gebruikersaccounts en computersystemen kunnen afdwingen. Vóór Group Policy moesten beheerders losse registeraanpassingen (*registry tweaks*) handmatig verspreiden.
* **Opbouw van een Group Policy Object (GPO):** Een GPO is een verzameling beleidsinstellingen in Active Directory en bestaat uit twee delen:
  1. **Group Policy Template (GPT):** Opgeslagen in de gedeelde **`SYSVOL`**-map op Domain Controllers; bevat onder meer *Administrative Templates* en opstart-/aanmeldscripts.
  2. **Group Policy Container (GPC):** De corresponderende Active Directory-attributen en koppelingen (*links*) die bepalen op welke Sites, Domeinen of OU's de GPO van toepassing is.
* **Computer Configuration vs. User Configuration:**
  * **Computer Configuration (Computer policies):** Worden toegepast wanneer het besturingssysteem **opstart** (*system startup*) en gelden voor het systeem ongeacht wie er inlogt.
  * **User Configuration (User policies):** Worden toegepast wanneer een gebruiker **inlogt** (*user logon*) en volgen de gebruiker binnen het domein op elke computer waarop hij of zij inlogt.
* **Verversingscyclus:** Alle Group Policies worden op de achtergrond standaard **elke 90 minuten** automatisch opnieuw toegepast (aanpasbaar per beleidsinstelling), of handmatig geforceerd via `gpupdate /force`.

### GPO-hiërarchie & Voorrangsregels (LSDOU)
Wanneer meerdere GPO's op verschillende niveaus conflicterende instellingen bevatten, worden ze in een vaste volgorde verwerkt — onthouden met het acroniem **LSDOU** (*Local, Site, Domain, Organizational Unit*). **De laatst toegepaste GPO wint** en overschrijft eerdere instellingen:

| Volgorde | Niveau | Bereik & Voorrangsregel |
| :--- | :--- | :--- |
| **1 (Eerst)** | **L**ocal Group Policy | Staat op de lokale computer zelf (`gpedit.msc`). Heeft de **laagste prioriteit** en wordt overschreven door elk AD-niveau. |
| **2** | **S**ite Group Policy | Gekoppeld aan een Active Directory Site (fysieke netwerklocatie/subnet). Overschrijft Local GPO's. |
| **3** | **D**omain Group Policy | Gekoppeld aan het gehele AD-domein (bijv. *Default Domain Policy*). Overschrijft Local en Site GPO's. |
| **4 (Laatst)** | **O**rganizational **U**nit (OU) | De aanbevolen methode voor granulair beheer. Overschrijft alle bovenliggende niveaus; bij geneste OU's wint de **meest specifieke (diepste) child-OU**. |

* **Belangrijke uitzondering (Account & Password Policies):** Domeinbrede wachtwoord- en accountvergrendelingsinstellingen voor domeinaccounts worden beheerd in de AD-database (niet in de lokale SAM). Daarom heeft de **Default Domain Policy** op domeinniveau voorrang boven een wachtwoordbeleid op OU-niveau (tenzij expliciet *Fine-Grained Password Policies* worden gebruikt **[Aanvullend]**).
* **[Aanvullend] Enforced & Block Inheritance:** Binnen de GPMC kan een beheerder een bovenliggende GPO markeren als **Enforced** (*No Override*, waardoor onderliggende OU's deze niet kunnen overschrijven) of op een OU **Block Inheritance** inschakelen.

### Visualisatie- & Analysehulpmiddelen
Vanwege de gelaagde overerving biedt Microsoft vier tools om te achterhalen welke beleidsregels daadwerkelijk actief zijn (*Resultant Set of Policy*):
1. **RSoP (`rsop.msc`):** Grafische weergave van het resulterende beleid op een machine.
2. **`gpresult`:** CLI-tool voor directe analyse (`gpresult /Z` of `gpresult /H`).
3. **Group Policy Results (in GPMC):** Wizard om het werkelijk toegepaste beleid op een specifieke computer en gebruiker in het domein op te vragen.
4. **Group Policy Modeling (in GPMC):** Simulatiewizard om vooraf te testen wat het effect van GPO's en OU-plaatsing zal zijn zonder dat de gebruiker hoeft in te loggen.

### Praktische Toepassingen van Group Policy
Met duizenden beschikbare instellingen regelt Group Policy onder meer:
* Wachtwoordbeleid (*Account Policies*: lengte, complexiteit, maximale wachtwoordleeftijd) en *Account Lockout Policy* (standaard uitgeschakeld).
* **Windows Defender Firewall**-regels en Windows Updates (*Configure Automatic Updates*).
* Netwerkschijven koppelen (*Map Drives*), mapomleiding (*Folder Redirection*, bijv. *Mijn Documenten*) en bureaubladachtergronden.
* Beveiligingsbeperkingen (*Hardening*): toegang blokkeren tot het Configuratiescherm (*Control Panel*), de Register-editor (`regedit`), het tabblad *Security* in Verkenner, of het uitschakelen van systeemafsluiting en ballonmeldingen.
* Uitvoeren van **Startup/Shutdown-scripts** (Computer) en **Logon/Logoff-scripts** (User), proxy-instellingen, netwerkprinters, bestandsauditing (*File Auditing*), Windows Time en energiebeheer (*Power Plans*).

---

## 3. Praktijkscenario's & Stappenplannen

### Scenario 1: Werkstation Hardening met Local Group Policy (`gpedit.msc`)
Het lokaal beperken van gebruikersrechten op een losstaand werkstation en het direct testen van de afgedwongen restricties:

1. **Open de Local Group Policy Editor (`gpedit.msc`) en configureer de gebruikersbeperkingen:**
   * Navigeer onder **User Configuration → Administrative Templates** naar de volgende onderdelen en zet de beleidsregels op **Enabled**:
     * *Control Panel* → **Prohibit access to Control Panel and PC Settings** (`Enabled`)
     * *Start Menu and Taskbar* → **Turn off all balloon notifications** (`Enabled`)
     * *System* → **Prevent access to registry editing tools** (`Enabled`)
     * *Windows Components → File Explorer* → **Remove Security tab** (`Enabled`)
2. **Pas het lokale beleid onmiddellijk toe:**
   ```powershell
   gpupdate /force
   ```
3. **Valideer dat de beperkingen actief zijn:**
   * Probeer `regedit` of `control` te starten vanuit een prompt; Windows blokkeert beide tools met een melding dat deze door de systeembeheerder zijn uitgeschakeld.

### Scenario 2: GPO-conflicten Oplossen & Gelaagde OU-policies Testen in GPMC
Het demonstreren van de LSDOU-hiërarchie waarbij eerst een Domain-GPO een Local-GPO overschrijft, en vervolgens een sub-OU-GPO een bovenliggende OU-GPO overschrijft:

1. **Los een conflict tussen Local GPO en Default Domain Policy op:**
   * In de *Local GPO* staat *Prohibit access to Control Panel and PC Settings* op `Enabled` (blokkeert toegang).
   * Open **Group Policy Management (`gpmc.msc`)**, klik met rechts op **Default Domain Policy → Edit**, navigeer naar *User Configuration → Policies → Administrative Templates → Control Panel* en zet dezelfde instelling op **Disabled** (staat toegang expliciet toe; *Not configured* zou de lokale instelling ongemoeid laten).
   * Voer `gpupdate /force` en `gpresult /Z` uit: de **Default Domain Policy** overschrijft de Local GPO, waardoor het Configuratiescherm weer toegankelijk is.
2. **Bouw een geneste OU-structuur met een algemene en een uitzonderings-GPO:**
   ```powershell
   New-ADOrganizationalUnit -Name "Cybrary" -Path "DC=cybrary,DC=local"
   New-ADOrganizationalUnit -Name "Engineering" -Path "OU=Cybrary,DC=cybrary,DC=local"
   ```
   * **Bovenliggende OU (`Cybrary`):** Maak en koppel via *Create a GPO in this domain, and Link it here...* de GPO **`Cybrary-All-Desktops`**, en zet onder *Computer Configuration → Policies → Administrative Templates → Windows Components → Windows Update* de optie **Configure Automatic Updates** op **Enabled**.
   * **Geneste sub-OU (`Engineering`):** Maak en koppel op de OU `Engineering` de GPO **`Disable-Windows-Update`** en zet **Configure Automatic Updates** op **Disabled**.
3. **Simuleer en controleer de winnende GPO met Group Policy Modeling:**
   * Klik in de GPMC met rechts op **Group Policy Modeling → Group Policy Modeling Wizard**.
   * Selecteer bij *Computer Information* de container van de sub-OU (`OU=Engineering,OU=Cybrary,DC=cybrary,DC=local`) en rond de wizard af.
   * *Resultaat:* In het *Group Policy Report* is **`Disable-Windows-Update`** de *Winning GPO* voor computers in `Engineering`, omdat een child-OU altijd voorrang heeft op een parent-OU (`Cybrary-All-Desktops`).

---

## 4. Aanvullende Bronnen & Referenties

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `PowerShell.md` (`gpupdate /force`, `gpresult /Z`, `Invoke-GPUpdate`, `Get-GPResultantSetOfPolicy`, `New-ADOrganizationalUnit`, `Add-ADGroupMember`) en `CMD.md` (`gpedit.msc`, `gpmc.msc`, `gpupdate`, `gpresult`).
  * Zie `BASH.md` voor Linux-configuratiebeheer (`ansible`, `sssd`).
* **[Aanvullend] Officiële Documentatie & Security Referenties:**
  * [Microsoft Learn: Group Policy Overview](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/group-policy/group-policy-overview) — Officiële documentatie over GPO-architectuur, `SYSVOL`, LSDOU-verwerkingsvolgorde en RSoP.
  * [Microsoft Security Compliance Toolkit (SCT)](https://www.microsoft.com/en-us/download/details.aspx?id=55319) — Officiële Microsoft Security Baselines (GPO-templates) om Windows-servers en werkstations te hardenen.
  * [MITRE ATT&CK T1484.001: Domain or Tenant Policy Modification — Group Policy Modification](https://attack.mitre.org/techniques/T1484/001/) — Overzicht van hoe aanvallers kwaadaardige GPO's misbruiken om malware of scripts domeinbreed uit te rollen.