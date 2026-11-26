# Linux CLI Basics

Essentiële terminal-commando's voor navigatie, bestandsbeheer en systeeminspectie.

## Identiteit & Systeemcontext

### Gebruiker en Systeem
* **`whoami`**: Toont de huidige gebruikersnaam.
* **`hostname`**: Toont de hostnaam van het systeem (optie `-I` voor alle IP-adressen).
* **`id`**: Toont UID, GID en alle groepslidmaatschap.

<<< @/snippets/bash/system.sh#identity{bash}

## Navigatie & Bestandsstructuur

### Navigeren in het Bestandssysteem
* **`pwd`**: Toont het absolute pad van de huidige werkmap (*Print Working Directory*).
* **`cd`**: Wisselt van map (`..` is omhoog, `~` is home-directory).
* **`ls`**: Toont mappen en bestanden (`-l` voor detail, `-a` inclusief verborgen bestanden).

<<< @/snippets/bash/file.sh#navigation{bash}

## Bestandsbeheer & Redirection

### Mappen en Bestanden Maken
* **`mkdir`**: Maakt mappen aan (optie `-p` voor hiërarchie).
* **`touch`**: Maakt lege bestanden aan of werkt timestamps bij.
* **`echo`**: Schrijft tekst naar de terminal of bestanden via `>` (overschrijven) en `>>` (toevoegen).

<<< @/snippets/bash/file.sh#creation{bash}

### Inspectie & Manipulatie
* **`cat`**: Leest bestanden uit naar stdout.
* **`file`**: Bepaalt het werkelijke bestandstype op basis van magic bytes.
* **`cp` / `mv` / `rm`**: Kopieer, verplaats/hernoem en verwijder bestanden.

<<< @/snippets/bash/file.sh#manipulation{bash}

## Pagers & Analyse

### Grote Bestanden Lezen
* **`more` / `less`**: Pagers om bestanden pagina voor pagina te bekijken (`less` ondersteunt voor- en achterwaarts scrollen).
* **`head`**: Toont de eerste regels van een bestand.
* **`base64`**: Encodeert of decodeert data.

<<< @/snippets/bash/processing.sh#viewing{bash}
