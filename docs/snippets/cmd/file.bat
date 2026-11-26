:: #region navigation
:: Navigeer naar de persoonlijke home-directory via omgevingsvariabele
cd %HOMEPATH%

:: Maak een nieuwe map en een geneste submap aan
mkdir C:\Labwork
mkdir "C:\Program Files\my service"

:: Verwijder een map inclusief alle onderliggende submappen en bestanden
rmdir /S C:\Labwork
:: #endregion navigation

:: #region dir
:: Toon recursief alle submappen en pauzeer per scherm
dir /S /P

:: Genereer een kale lijst van alle volledige bestandspaden voor piping
dir /s /b

:: Bekijk de 8.3 korte bestandsnamen in de root van C:\
dir /x C:\

:: Toon de volledige mappen- en bestandsstructuur van een projectmap
tree Hall_of_Justice /F
:: #endregion dir

:: #region file-ops
:: Kopieer een bestand naar een andere map of onder een nieuwe naam
copy apple1\cow.txt apple2\notacow.txt

:: Hernoem een bestand
rename apple2\notacow.txt reallyacow.txt

:: Verplaats een bestand naar een andere directory
move apple3\manycows.txt apple2

:: Verwijder een bestand met bevestigingsprompt
del /P apple2\reallyacow.txt
:: #endregion file-ops
