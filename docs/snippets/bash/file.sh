#region navigation
pwd
cd /var/log
tree / -L 1
sudo tree /home
#endregion navigation

#region ls
ls -l
ls -la
ls -R
ls -latr
#endregion ls

#region file-ops
mkdir -p ~/labwork/blue ~/labwork/red
touch file1.txt file2.txt
cp -p file1.txt ~/labwork/blue/
mv file2.txt ~/labwork/red/renamed.txt
file ~/labwork/red/renamed.txt
rm -i file1.txt
#endregion file-ops

#region permissions
# Maak een script uitvoerbaar voor de eigenaar (of stel 750 / 600 rechten in)
chmod +x script.sh
chmod 600 id_ed25519
chmod -R 750 /opt/app/

# Wijzig eigenaar en groep van een map recursief
sudo chown -R root:analysts /opt/app/

# Inspecteer gedetailleerde POSIX ACL's
getfacl /opt/app/
#endregion permissions
