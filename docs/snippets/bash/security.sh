#region openssl
# 1. genpkey genereert een privésleutel (-algorithm = algoritme, -out = uitvoerbestand)
openssl genpkey -algorithm rsa -out cybraryprivate.key
# rsa -pubout leidt de publieke sleutel af uit de privésleutel (-in = invoer)
openssl rsa -pubout -in cybraryprivate.key -out cybrarypublic.key

# 2. Versleutel met de publieke sleutel van de ontvanger: -encrypt = versleutelen, -inkey = sleutel,
#    -pubin = de sleutel is een publieke sleutel, -in = bericht, -out = versleuteld resultaat
openssl pkeyutl -encrypt -inkey sallypublic.key -pubin -in message.txt -out message.enc

# 3. Ontsleutel met je eigen privésleutel (-decrypt)
openssl pkeyutl -decrypt -inkey sallyprivate.key -in message.enc -out message.txt

# 4. dgst berekent een hash; -md5 en -sha256 kiezen het algoritme
openssl dgst -md5 happypuppy.exe
openssl dgst -sha256 happypuppy.exe

# Symmetrische versleuteling: enc -aes-256-cbc = algoritme, -salt = willekeurige salt toevoegen,
# -pbkdf2 = moderne sleutelafleiding uit het wachtwoord
openssl enc -aes-256-cbc -salt -pbkdf2 -in geheim.txt -out geheim.enc
# -d: ontsleutelen
openssl enc -d -aes-256-cbc -pbkdf2 -in geheim.enc -out geheim.txt

# Digitale handtekening: -sign tekent de hash met je privésleutel, -out is het handtekeningbestand
openssl dgst -sha256 -sign cybraryprivate.key -out message.sig message.txt
# -verify controleert met de publieke sleutel of de handtekening (-signature) bij het bestand hoort
openssl dgst -sha256 -verify cybrarypublic.key -signature message.sig message.txt
#endregion openssl

#region hashes
# Bereken de SHA-256-hash van een bestand
sha256sum happypuppy.exe
# -c: lees een lijst met hashes en bestandsnamen en controleer of alles klopt
sha256sum -c checksums.txt
#endregion hashes
