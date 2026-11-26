# Access Control Basics

Toegangscontrole, NTFS-permissies en autorisatiemodellen in Windows en Linux.

## 1. Commando's & Permissiebeheer

### Windows ACL (`icacls`)
* **`icacls`**: Toont of wijzigt Access Control Lists (ACL's) op bestanden en mappen.
* **`tree /F`**: Toont mappenstructuur inclusief bestanden.
* **`net localgroup`**: Beheert lokale Windows-groepen.

<<< @/snippets/cmd/access-control.bat#icacls{cmd}

## 2. Toegangscontrole Modellen

| Model | Kenmerk | Gebruik |
| :--- | :--- | :--- |
| **MAC** (*Mandatory*) | Strenge labels (Classificatie & Categorie) | Overheid & Defensie |
| **DAC** (*Discretionary*) | Eigenaar wijzigt rechten per object | Standaard in Windows NTFS |
| **RBAC** (*Role-Based*) | Rechten gekoppeld aan functierollen (groepen) | Bedrijfsomgevingen |

## 3. Windows Machtigingen & Overerving

### Standaardmachtigingen
* **Full Control**: Volledig beheer.
* **Modify**: Lezen, schrijven, uitvoeren, verwijderen.
* **Read & Execute**: Lezen en uitvoeren.

### Voorrangsregels
- **Expliciete Deny** heeft altijd voorrang op **Allow**.
- **Overerving (*Inheritance*)**: Rechten stromen van bovenliggende mappen naar submappen, tenzij overerving expliciet wordt uitgeschakeld.
