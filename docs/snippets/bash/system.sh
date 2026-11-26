#region identity
# Toon de huidige gebruikersnaam
whoami
# Toon UID, GID en alle groepen van de gebruiker
id
#endregion identity

#region sudo
# Voer één commando uit met root-rechten
sudo ls /root

# Wissel naar een ander account met een volledige login-shell (-); sluit af met exit
su - sally
#endregion sudo

#region users
# Debian/Ubuntu: maakt een gebruiker aan, vraagt om wachtwoord en maakt de home-map
sudo adduser michael

# Universeel equivalent: -m maakt de home-map aan, passwd stelt het wachtwoord in
sudo useradd -m michael
sudo passwd michael

# Maak een groep aan
sudo groupadd analysts
# -a: voeg toe zonder bestaande groepen te wissen, -G: lijst van groepen
sudo usermod -aG analysts michael
# Toon de groep en haar leden
getent group analysts
#endregion users
