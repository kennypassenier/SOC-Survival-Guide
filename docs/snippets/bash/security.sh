#region openssl
# 1. Genereer een RSA private key en leid de publieke sleutel af
openssl genpkey -algorithm rsa -out cybraryprivate.key
openssl rsa -pubout -in cybraryprivate.key -out cybrarypublic.key

# 2. Versleutel een bericht met de publieke sleutel van de ontvanger (-pubin)
openssl pkeyutl -encrypt -inkey sallypublic.key -pubin -in message.txt -out message.enc

# 3. Ontsleutel het bericht met je eigen private sleutel
openssl pkeyutl -decrypt -inkey sallyprivate.key -in message.enc -out message.txt

# 4. Bereken MD5- en SHA-256-hashes van een bestand
openssl dgst -md5 happypuppy.exe
openssl dgst -sha256 happypuppy.exe

# Symmetrische AES-256-CBC encryptie & decryptie met moderne PBKDF2-sleutelafleiding
openssl enc -aes-256-cbc -salt -pbkdf2 -in geheim.txt -out geheim.enc
openssl enc -d -aes-256-cbc -pbkdf2 -in geheim.enc -out geheim.txt

# Digitale handtekening maken en verifiëren
openssl dgst -sha256 -sign cybraryprivate.key -out message.sig message.txt
openssl dgst -sha256 -verify cybrarypublic.key -signature message.sig message.txt
#endregion openssl

#region hashes
# Bereken en verifieer SHA-256-hashes
sha256sum happypuppy.exe
sha256sum -c checksums.txt
#endregion hashes
