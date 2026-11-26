#region sym-mail
# Stuur de inhoud van een bestand via een pipe als e-mail; -s zet het onderwerp, john is de ontvanger
cat keyforjohn.send | mail -s "For John" john

# Open de lokale mailbox van de huidige gebruiker
mail
#endregion sym-mail

#region sym-lab-step1
# Genereer de gedeelde sleutel
openssl genpkey -algorithm rsa -out keyforjohn.key
# Codeer de binaire sleutel naar Base64-tekst zodat hij als mail kan worden verstuurd
base64 keyforjohn.key > keyforjohn.send
# Verstuur de tekst naar john
cat keyforjohn.send | mail -s "For John" john
#endregion sym-lab-step1

#region sym-lab-step2
# Wissel naar het account van john en open zijn mailbox
su - john
mail
#endregion sym-lab-step2

#region sym-lab-step2-decode
# Plak de Base64-tekst uit de mail in een bestand
echo "<GEPLAKTE_BASE64_SLEUTEL>" > keyforjohn.base64
# Decodeer terug naar het oorspronkelijke sleutelbestand; -d = decode
base64 -d keyforjohn.base64 > keyfromcybrary.key
#endregion sym-lab-step2-decode

#region sym-lab-step3
# Schrijf het geheime bericht
echo "Be sure to drink your ovaltine!" > message.txt
# Versleutel het met de ontvangen sleutel (-encrypt, -inkey = sleutel, -in = invoer, -out = uitvoer)
openssl pkeyutl -encrypt -inkey keyfromcybrary.key -in message.txt -out message.enc
# Het resultaat is binair, dus eerst naar Base64 coderen voor transport
base64 message.enc > message.send
# Verstuur het naar cybrary en sluit de sessie van john af
cat message.send | mail -s "Secret Message from John" cybrary
exit
#endregion sym-lab-step3

#region sym-lab-step4
# Terug als cybrary: open de mailbox
mail
#endregion sym-lab-step4

#region sym-lab-step4-decode
# Plak de Base64-tekst uit de mail in een bestand
echo "<GEPLAKTE_BASE64_BERICHT>" > message.base64
# Decodeer naar het binaire versleutelde bestand
base64 -d message.base64 > message.enc
# Ontsleutel met de oorspronkelijke sleutel (-decrypt) en lees het bericht
openssl pkeyutl -decrypt -inkey keyforjohn.key -in message.enc -out message.txt
cat message.txt
#endregion sym-lab-step4-decode
