# Group Policy Basics

Hoe Group Policy instellingen centraal afdwingt, hoe de hiërarchie werkt en hoe je conflicten oplost.

## Concepts

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

```mermaid
flowchart LR
    L["1. Local"] --> S["2. Site"] --> D["3. Domain"] --> O["4. OU<br/>diepste OU laatst"]
    O --> R["Resultaat: laatste toegepaste instelling wint"]
```
Wanneer meerdere GPO's op verschillende niveaus conflicterende instellingen bevatten, worden ze in een vaste volgorde verwerkt — onthouden met het acroniem **LSDOU** (*Local, Site, Domain, Organizational Unit*). **De laatst toegepaste GPO wint** en overschrijft eerdere instellingen:

| Volgorde | Niveau | Bereik & Voorrangsregel |
| :--- | :--- | :--- |
| **1 (Eerst)** | **L**ocal Group Policy | Staat op de lokale computer zelf (`gpedit.msc`). Heeft de **laagste prioriteit** en wordt overschreven door elk AD-niveau. |
| **2** | **S**ite Group Policy | Gekoppeld aan een Active Directory Site (fysieke netwerklocatie/subnet). Overschrijft Local GPO's. |
| **3** | **D**omain Group Policy | Gekoppeld aan het gehele AD-domein (bijv. *Default Domain Policy*). Overschrijft Local en Site GPO's. |
| **4 (Laatst)** | **O**rganizational **U**nit (OU) | De aanbevolen methode voor granulair beheer. Overschrijft alle bovenliggende niveaus; bij geneste OU's wint de **meest specifieke (diepste) child-OU**. |

* **Belangrijke uitzondering (Account & Password Policies):** Domeinbrede wachtwoord- en accountvergrendelingsinstellingen voor domeinaccounts worden beheerd in de AD-database (niet in de lokale SAM). Daarom heeft de **Default Domain Policy** op domeinniveau voorrang boven een wachtwoordbeleid op OU-niveau (tenzij expliciet *Fine-Grained Password Policies* worden gebruikt).
* **Enforced & Block Inheritance:** Binnen de GPMC kan een beheerder een bovenliggende GPO markeren als **Enforced** (*No Override*, waardoor onderliggende OU's deze niet kunnen overschrijven) of op een OU **Block Inheritance** inschakelen.

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

## Commands

De commando's voor dit onderwerp staan in de referentiepagina's, met parameters en voorbeelden:

- [gpupdate](/scripting/cmd#cmd-gpupdate)
- [gpresult](/scripting/cmd#cmd-gpresult)
- [gpedit.msc & gpmc.msc](/scripting/cmd#cmd-gpedit-msc-gpmc-msc)
- [Import-Module, New-ADOrganizationalUnit & Add-ADGroupMember](/scripting/powershell#ps-domeinscript-importeren-en-ou-hi-rarchie)

## Scenarios

### Scenario 1: Werkstation Hardening met Local Group Policy (`gpedit.msc`)
Het lokaal beperken van gebruikersrechten op een losstaand werkstation en het direct testen van de afgedwongen restricties:

1. **Open de Local Group Policy Editor (`gpedit.msc`) en configureer de gebruikersbeperkingen:**
   * Navigeer onder **User Configuration → Administrative Templates** naar de volgende onderdelen en zet de beleidsregels op **Enabled**:
     * *Control Panel* → **Prohibit access to Control Panel and PC Settings** (`Enabled`)
     * *Start Menu and Taskbar* → **Turn off all balloon notifications** (`Enabled`)
     * *System* → **Prevent access to registry editing tools** (`Enabled`)
     * *Windows Components → File Explorer* → **Remove Security tab** (`Enabled`)
2. **Pas het lokale beleid onmiddellijk toe:**
   <<< @/snippets/ps/windows-group-policy.ps1#scenario-1-stap-1{powershell}
3. **Valideer dat de beperkingen actief zijn:**
   * Probeer `regedit` of `control` te starten vanuit een prompt; Windows blokkeert beide tools met een melding dat deze door de systeembeheerder zijn uitgeschakeld.

### Scenario 2: GPO-conflicten Oplossen & Gelaagde OU-policies Testen in GPMC
Het demonstreren van de LSDOU-hiërarchie waarbij eerst een Domain-GPO een Local-GPO overschrijft, en vervolgens een sub-OU-GPO een bovenliggende OU-GPO overschrijft:

1. **Los een conflict tussen Local GPO en Default Domain Policy op:**
   * In de *Local GPO* staat *Prohibit access to Control Panel and PC Settings* op `Enabled` (blokkeert toegang).
   * Open **Group Policy Management (`gpmc.msc`)**, klik met rechts op **Default Domain Policy → Edit**, navigeer naar *User Configuration → Policies → Administrative Templates → Control Panel* en zet dezelfde instelling op **Disabled** (staat toegang expliciet toe; *Not configured* zou de lokale instelling ongemoeid laten).
   * Voer `gpupdate /force` en `gpresult /Z` uit: de **Default Domain Policy** overschrijft de Local GPO, waardoor het Configuratiescherm weer toegankelijk is.
2. **Bouw een geneste OU-structuur met een algemene en een uitzonderings-GPO:**
   <<< @/snippets/ps/windows-group-policy.ps1#scenario-2-stap-1{powershell}
   * **Bovenliggende OU (`Cybrary`):** Maak en koppel via *Create a GPO in this domain, and Link it here...* de GPO **`Cybrary-All-Desktops`**, en zet onder *Computer Configuration → Policies → Administrative Templates → Windows Components → Windows Update* de optie **Configure Automatic Updates** op **Enabled**.
   * **Geneste sub-OU (`Engineering`):** Maak en koppel op de OU `Engineering` de GPO **`Disable-Windows-Update`** en zet **Configure Automatic Updates** op **Disabled**.
3. **Simuleer en controleer de winnende GPO met Group Policy Modeling:**
   * Klik in de GPMC met rechts op **Group Policy Modeling → Group Policy Modeling Wizard**.
   * Selecteer bij *Computer Information* de container van de sub-OU (`OU=Engineering,OU=Cybrary,DC=cybrary,DC=local`) en rond de wizard af.
   * *Resultaat:* In het *Group Policy Report* is **`Disable-Windows-Update`** de *Winning GPO* voor computers in `Engineering`, omdat een child-OU altijd voorrang heeft op een parent-OU (`Cybrary-All-Desktops`).

## References

* **Interne Commandoreferenties (SOC Analyst Map):**
  * Zie `PowerShell.md` (`gpupdate /force`, `gpresult /Z`, `Invoke-GPUpdate`, `Get-GPResultantSetOfPolicy`, `New-ADOrganizationalUnit`, `Add-ADGroupMember`) en `CMD.md` (`gpedit.msc`, `gpmc.msc`, `gpupdate`, `gpresult`).
  * Zie `BASH.md` voor Linux-configuratiebeheer (`ansible`, `sssd`).
* **Officiële Documentatie & Security Referenties:**
  * [Microsoft Learn: Group Policy Overview](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/group-policy/group-policy-overview) — Officiële documentatie over GPO-architectuur, `SYSVOL`, LSDOU-verwerkingsvolgorde en RSoP.
  * [Microsoft Security Compliance Toolkit (SCT)](https://www.microsoft.com/en-us/download/details.aspx?id=55319) — Officiële Microsoft Security Baselines (GPO-templates) om Windows-servers en werkstations te hardenen.
  * [MITRE ATT&CK T1484.001: Domain or Tenant Policy Modification — Group Policy Modification](https://attack.mitre.org/techniques/T1484/001/) — Overzicht van hoe aanvallers kwaadaardige GPO's misbruiken om malware of scripts domeinbreed uit te rollen.
