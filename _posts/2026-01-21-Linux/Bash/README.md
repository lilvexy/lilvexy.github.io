Del 1- Command history:
  ```
547  sudo nano /etc/ssh/sshd_config #ändrade rootlogin till no ctr+o och ctr+x
  548  sudo systemctl restart ssh #startar om ssh
  551  ssh-keygen -t ed25519 -a 100 -C "diorak98@gmail.com." #genererar keypair och jag har satt lösenord på key.
  552  ls -l .ssh/ #kopierade public key
  553  ufw status #glömde sudo
  554  sudo ufw
  555  sudo ufw
  556  sudo ufw enable
#hade redan laddat ner ufw innan så denna del saknas men de går att
sudo apt install ufw
```


Del 2 -Command history:
```


  907  groupadd admins #skapar grupperna först
  908  groupadd developers
  909  groupadd users
  911  useradd -m tetra # -m skapar users med homefolders
  912  useradd -m Peter
  913  useradd -m Oskar
  914  useradd -m ella
  915  useradd -m Bera
  916  usermod -aG developers Peter #adderar user till group
  917  usermod -aG developers oskar
  918  usermod -aG users tetra
  919  usermod -aG users ella
  920  usermod -aG admins Bera                          
  921  groupadd Shared_group
  922  usermod -aG Shared_group Bera #adderar Bera till en delad grupp där alla i delade gruppen har access + ägaren
  923  usermod -aG Shared_group Peter
  924  usermod -aG Shared_group Oskar
  925  mkdir developers # Skapa delade mapparna
  926  mkdir admins
  927  mkdir users
  928  chown developers developers # chown [group] [folder] för att sätta groupowner
  929  chown admins admins
  930  chown users users
  931  chmod 770 developers # Ge ägaren och gruppägare full access
  932  chmod 770 admins
  933  chmod 770 users
```


![Folders och rättigheter](https://i.gyazo.com/c7c6d5d237d953985529a7a0dc65510f.png)!




Där ser du exempel på vilka som tillhör de olika grupperna och de satta rättigheterna för gruppens egna folders, delad folder och personliga folders.




Del 3: Documentation av skripten finns i kommentarerna i varje enskild skript.
Skripten är i ordning 
backup.sh (skript 1 som tar backup och raderar gammalt)
user_manager.sh (skript2 skapar meny med 5val för användarhantering.)
system_report.sh (skript 3 rapporterar ssh försök, sudo, senaste users och sparar systemrapportlog) kan köras via crontab om man så önskar
overvakning-du.sh (extra uppgiften som ska köras av cronjob, övervakar diskutrymme och loggar med vacker CLI) 

MÅSTE göras för varje skript.
``` 
chmod +x /home/kali/overvakning-du.sh # gör jag i min terminal, du får ändra sökvägen till där du sparat ner skripten på din dator.
```
Schemalägga skripts via crontab. 
``` 
crontab -e #tar upp crontab i nano där skriver du över ( #edit this text ) med " */10 * * * * /home/kali/overvakning-du.sh " alternativt egen önskad tid och kolla så sökvägen till skriptet stämmer på din dator.
```
crontab går att köra igång från skriptet men detta kör över existerande cronjobs och rekommenderas ej så här och i skriptet finns de bara en förklaring till manuell start av crontab.


Resultatet av skripten visas nedan.
![resultat av skripts](https://i.gyazo.com/c74faa618eec0be1847151b01f9e7bd8.png)!


![innehåll av skriptlog](https://i.gyazo.com/a8ccb693823d6079f8cb8a9bdd0145fe.png)!




Del 4 : $ sudo nano /etc/ssh/sshd_config #för att få upp config och där kan du ändra configen för ssh port, utförd i del 1.
det går att lägga till host i configen också genom att skriva in nedanstående info i configen.
    Host minserver
    HostName server-ip
    User användare
    Port 2222
    IdentityFile ~/.ssh/id_ed54543  
ssh port ändring beskrivs men sparas ej då jag är lätt glömsk, kan vara bra att veta (ssh port behövs anges om port är ändrad från default port 22. )





Anslutning mellan dator och vm.
![Vm anslutning](https://i.gyazo.com/f69b5ae78670170c00265317506c6e36.png)!





Del 5:

Jag installerade en färdig uppsättning av kali linux på vmware genom denna länk https://www.kali.org/get-kali/#kali-virtual-machines där hittar du docs som förklarar exakt hur du går tillväga för att sätta upp vmen. ssh finns redan du kan kolla status genom “sudo systemctl status ssh, är den disabled får du köra up pil ändra status to enable för att sätta igång. sudo apt install ufw sedan sudo ufw enable detta finns i del 1.del 2 är också väldokumenterad.




säkerhetskonfig som utförs är nedladdning av ufw firewall , ändring av ssh port , skapat ssh keys med lösenord. ändrat rootlogin till no på ssh config och även PasswordAuthentication är satt på no så man måste ha ssh key för att få åtkomst. PubkeyAuthentication yes så man kan använda den och till framtiden går de att förbättra genom att sätta rättigheter på ssh keysen man kan även addera fail2ban för att förhindra bruteforce försök genom att utnyttja fail2ban som t.ex blockar ipn en stund efter för många failade inloggningsförsök (tex som telefoner har när du skriver fel och blir utlåst).
så går du till väga:
```
sudo apt install fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
/etc/fail2ban/jail.local # är konfigfil location om man skulle vilja addera mer än standardconfig.
```

utmaning: jag hade lite nätverksstrul som försvårade ssh uppkoppling där ssh fungerade men inte scp och tvärtom. detta lärde mig dock att felsöka mer och vänja mig vid ssh och scp syntax då jag använde scp för att flytta över skript från datorn till vm för att testa funktionen av skriptet samt att kontrollera så ssh inte slutade fungera igen.Löste detta genom att ändra nätverksadapter och ändring av wired connection 1, manuellt sätta ip samt att ssh key gjorde de mer stabilt också.
hade även lite strul mentalt att använda awk , tyckte att awk var svårt i syntaxet och krävde mycket definiering av de man ville göra så jag ska fortsätta öva på awk.


