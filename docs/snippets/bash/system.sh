#region identity
# Controleer huidige gebruikersnaam, UID, GID en groepen
whoami
id
#endregion identity

#region sudo
# Voer een beheercommando uit met root-rechten
sudo ls /root

# Wissel naar een ander lokaal gebruikersaccount (afsluiten met exit)
su - sally
#endregion sudo

#region users
# Debian / Ubuntu: interactief gebruiker aanmaken inclusief home-map en wachtwoord
sudo adduser michael

# Arch Linux & universeel Linux-equivalent
sudo useradd -m michael
sudo passwd michael

# Groep aanmaken, gebruiker toevoegen en controleren
sudo groupadd analysts
sudo usermod -aG analysts michael
getent group analysts
#endregion users
