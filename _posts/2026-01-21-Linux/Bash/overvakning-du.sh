#!/bin/bash

# färgkoder
RED="\e[31m"
GREEN="\e[32m"
RESET="\e[0m"

# Datum för loggfilen
DATUM=$(date +"%Y-%m-%d_%H-%M-%S")

# Loggfilens sökväg
RAPPORT="$HOME/rapport/disk_overvakning_$DATUM.txt" #home är för att de ska vara home för den som kör och inte hårdkoda in min egna user.

# Skapa mappen om den inte finns
mkdir -p "$(dirname "$RAPPORT")"

# Skriv startinfo till loggfil
echo "Diskövervakning startad: $DATUM" > "$RAPPORT" #dirigerar in info till fil längst ovan givna sökväg

# Kolla diskutrymme fungerar precis som 80% varianten.
df -h --output=pcent,target | tail -n +2 | while read rad; do
    PROCENT=$(echo $rad | awk '{print $1}' | tr -d '%') #syftet av att ta bort % tecknet är för att -ge ska fungera. 
    MOUNT=$(echo $rad | awk '{print $2}')

    if [ "$PROCENT" -ge 90 ]; then
        echo -e "${RED}VARNING: $MOUNT är ${PROCENT}% fullt!${RESET}" | tee -a "$RAPPORT" #tee append finns med för att de ska både visa i terminal och append to file
    else
        echo -e "${GREEN}OK: $MOUNT är ${PROCENT}% fullt.${RESET}" | tee -a "$RAPPORT" #append finns för att inte överskriva existerande rapport utan tillägga precis som >>
    fi
done
# För att sen starta övervakningen gör följande
# chmod +x sökvägtillskript t.ex (chmod +x /home/kali/overvakning-du.sh) gör jag i min terminal.
# skriv "crontab -e " i terminalen du får upp nano och där skriver du över #editthistext med */10 * * * * /home/kali/overvakning-du.sh   (ändra sökvägen till skriptet om de skiljer sig på din) vill du att körtiderna ska vara annorlunda kan du nyttja cronguru.