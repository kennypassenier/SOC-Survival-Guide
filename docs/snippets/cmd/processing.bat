:: #region certutil
:: Bereken de SHA-256 (of MD5) hash van een verdacht uitvoerbaar bestand
certutil -hashfile happypuppy.exe SHA256
certutil -hashfile happypuppy.exe MD5

:: Codeer en decodeer bestanden via Base64
certutil -encode message.enc message.base64
certutil -decode message.base64 message.enc
:: #endregion certutil

:: #region script
:: Start een Python-script op Windows
python caesar.py
py caesar.py

:: Genereer een modern Ed25519 asymmetrisch sleutelpaar
ssh-keygen -t ed25519
:: #endregion script
