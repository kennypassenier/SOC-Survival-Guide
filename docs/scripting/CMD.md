# Command Prompt (CMD) Referentie

Klassieke Windows CLI-commando's voor systeembeheer en snelle triage.

## 1. Shell & Identiteit

Gebruik `whoami /priv` om je privileges te controleren.

<<< @/snippets/cmd/system.bat#shell{cmd}
<<< @/snippets/cmd/system.bat#identity{cmd}
<<< @/snippets/cmd/system.bat#runas{cmd}

### Hulp & Historie
<<< @/snippets/cmd/system.bat#help{cmd}
<<< @/snippets/cmd/system.bat#history{cmd}

## 2. Navigatie & Bestanden

### Bestandsbeheer
<<< @/snippets/cmd/file.bat#navigation{cmd}
<<< @/snippets/cmd/file.bat#dir{cmd}
<<< @/snippets/cmd/file.bat#file-ops{cmd}

## 3. Tekstverwerking & Hashing

### Echo & Output
<<< @/snippets/cmd/processing.bat#echo{cmd}

### Zoeken (Findstr)
<<< @/snippets/cmd/processing.bat#search{cmd}

### Certutil & Scripting
`certutil` is een krachtige LOLBin voor hashing en encoding.

<<< @/snippets/cmd/processing.bat#certutil{cmd}
<<< @/snippets/cmd/processing.bat#script{cmd}

## 4. Permissies & ADS

### Icacls
Beheer NTFS-rechten en overerving.

<<< @/snippets/cmd/access-control.bat#icacls{cmd}

### Alternate Data Streams (ADS)
<<< @/snippets/cmd/access-control.bat#ads{cmd}

## 5. Systeembeheer

### Info & Processen
<<< @/snippets/cmd/os-management.bat#sysinfo{cmd}

### Services (SC & WMIC)
<<< @/snippets/cmd/os-management.bat#services{cmd}

### Gebruikers & Shares (Net)
<<< @/snippets/cmd/os-management.bat#net{cmd}

### Backup
<<< @/snippets/cmd/os-management.bat#backup{cmd}

## 6. Netwerk & GPO

### Netwerkdiagnose
<<< @/snippets/cmd/network.bat#network{cmd}

### Group Policy
<<< @/snippets/cmd/network.bat#gpo{cmd}
