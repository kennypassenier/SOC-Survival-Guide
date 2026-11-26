:: #region shell
:: Start de klassieke Windows CLI vanuit een PowerShell-sessie
cmd
:: #endregion shell

:: #region identity
:: Toon de huidige gebruikerscontext
whoami

:: Toon privileges en groepen
whoami /priv
whoami /groups
:: #endregion identity

:: #region runas
:: Open een nieuwe Command Prompt als lokale Administrator
runas /user:Administrator cmd
:: #endregion runas

:: #region help
:: Bekijk de documentatie van een ingebouwd CMD-commando
help dir

:: Gebruik /? voor externe CLI-hulpprogramma's
findstr /?
:: #endregion help

:: #region history
:: Bekijk de commandogeschiedenis van het huidige CMD-venster
doskey /history
:: #endregion history
