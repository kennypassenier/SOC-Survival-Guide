#region apt-patching
# Ververs de pakketlijsten (installeert nog niets)
sudo apt update
# Toon welke pakketten een update hebben; more pagineert de uitvoer
sudo apt list --upgradable | more

# -s: simuleer de upgrade zonder iets te wijzigen
sudo apt -s upgrade
# Bewaar het resultaat van de simulatie in een bestand
sudo apt -s upgrade > simulated_upgrade.txt

# Werk de lijsten bij en installeer daarna alle updates; && voert het tweede alleen uit als het eerste slaagt
sudo apt update && sudo apt upgrade
# Werk alleen deze pakketten bij zonder nieuwe te installeren
sudo apt install --only-upgrade package1 package2
#endregion apt-patching

#region apt-hold
# Voorkom dat apt het pakket ufw upgradet
sudo apt-mark hold ufw
# Toon alle pakketten die on hold staan
sudo apt-mark showhold
# Haal het pakket weer van de hold-lijst
sudo apt-mark unhold ufw
#endregion apt-hold

#region docker-patching
# Toon draaiende containers
sudo docker ps
# Toon de details van de container en filter op de versievariabele
sudo docker inspect mysql | grep MYSQL_VERSION
# Stop en verwijder de oude container
sudo docker stop mysql
sudo docker rm mysql
# Haal het nieuwste image op en toon de lokale images
sudo docker pull mysql
sudo docker images
# Start een nieuwe container: --name = naam, --restart=always = herstart automatisch,
# -e = omgevingsvariabele, -v = koppel hostmap aan containermap voor behoud van data, -d = op de achtergrond
sudo docker run --name=mysql --restart=always -e MYSQL_ROOT_PASSWORD=cybrary -v /home/cybrary/mysql:/var/lib/mysql -d mysql
#endregion docker-patching
