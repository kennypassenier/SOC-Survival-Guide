# CMD

## Useful commands

dir - lists the files and folders in the current directory
dir /s - lists all the subfolders as well
dir /b only lists the names of the folders and files

findstr "content" filename.txt finds a string inside a file
findstr /s /i "searchTerm" *.* searches in all subfolders and files in those folders for the searchTerm (inside the content)

dir /s /b | findstr apple | findstr .txt - Pipes the output of the dir command into findstr which looks for the word apple in file and directory names. That get's piped into the last findstr which looks for .txt in those names

find /c "searchOption" can be used to count items

move
copy
rm - deletes
rmdir /s DIRNAME - removes a folder
tree DIRNAME 
doskey /history - shows all the commands that have been issued (in this session?)

### Administrative commands
systeminfo
tasklist
date /t
time /t
sc query | more - views active services and drivers
net - can view and modify users, groups, shares, etc
net user - shows all local user accounts
net help user - shows the help guide
net localgroup - lists all groups on the machine
net accounts - shows the current password requirements
for /L %a in (1,1,255) do @ping -n 1 -w 10 x.y.z.%a > null && echo x.y.z.%a is up! and press Enter, replacing x.y.z with the first three octets of an IP. Also known as a ping sweep
ping x.x.x.x
nslookup www.website.com
netstat -ant - shows all current TCP and UDP network connections to and from the machine
