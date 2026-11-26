# Linux File System Basics

De structuur van het Linux-bestandssysteem, permissies en loganalyse.

## 1. Mappenstructuur & Bestanden

### Systeemstructuur en Visuele Weergave
* **`tree`**: Toont de mappenstructuur als boomdiagram (optie `-L <niveau>` voor diepte).
* **`apt`** / **`pacman`**: Pakketbeheerders voor software-installatie.

<<< @/snippets/bash/file.sh#structure{bash}

## 2. Gebruikers & Systeemcontext

### Rechten en Beheer
* **`sudo`**: Voert commando's uit met root-rechten.
* **`adduser`** / **`useradd`**: Maakt nieuwe gebruikers aan.
* **`last`** / **`who`**: Overzicht van actieve en historische logins.
* **`tail`**: Volgt logbestanden live (optie `-f`).

<<< @/snippets/bash/system.sh#users{bash}

## 3. Schijfbeheer & Processen

### Opslag en Processen
* **`fdisk`**: Beheert partitietabellen (optie `-l` voor lijst).
* **`df`**: Toont vrije schijfruimte (optie `-h` voor human-readable).
* **`lsblk`**: Toont blokapparaten en koppelpunten.
* **`ps`**: Toont actieve processen (optie `-e`).

<<< @/snippets/bash/system.sh#storage{bash}
