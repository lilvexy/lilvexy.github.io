#!/bin/bash
# system_report.sh - CSI: Linux Edition

DATUM=$(date +"%Y-%m-%d_%H-%M-%S")  #ändrar formatet på datum
RAPPORT="$HOME/rapport/systemrapport_$DATUM.txt" #anger rapport samma som systemrapportdatum.txt dvs rapport är en variabel som håller denna filtext nu. 
mkdir -p "$(dirname "$RAPPORT")" #skapar mapp om dem inte finns längst sökvägen. 

echo "==== Systemrapport $DATUM ====" > "$RAPPORT" #echo outputtar systemrapport datum fint och dirigerar till rapport variabeln. 

# 1. Senaste 10 misslyckade inloggningar
echo -e "\n[1] Senaste 10 misslyckade inloggningar:" >> "$RAPPORT" #outputtar text i rapport filen \n innebär newline så detta ska börja texten i nyrad och argument e är för att de inte ska läsas som en del av stringen..
journalctl -u ssh --since "1 week ago" | grep "Failed password" | tail -n 10 >> "$RAPPORT"

# 2. 5 senast skapade användare
echo -e "\n[2] 5 senast skapade användare:" >> "$RAPPORT"
awk -F: '{if ($3 >= 1000 && $1 != "nobody") print $1}' /etc/passwd | tail -n 5 >> "$RAPPORT" #-f delar vid : $3 identifierar uid och över1000 för att slippa systemkonton och sen tas nobody bort de printar de som blir kvar och pipe för att plocka ut botten 5 då konton hamnar längst ner som dirigeras till rapport

# 3. Användare som använt sudo senaste 24h
echo -e "\n[3] Sudo-användare senaste 24h:" >> "$RAPPORT"
journalctl -t sudo --since "24 hours ago" | awk '{print $NF}' | sort | uniq >> "$RAPPORT" #argument -t visar bara de som anges som loggkälla. tex sudo. --since flaggan anges för att sätta 24timmar sedan. pipe awk printar ut sista fälten på raden. sorterar sedan unika och append dirigeras till rapport.

# 4. SSH-anslutningar per IP (senaste 100 loggrader)
echo -e "\n[4] SSH-försök per IP (senaste 100 rader):" >> "$RAPPORT"
#plockar ut accepted och eller failed password från ssh loggar. visar sista 100. grep -o plockar only matching med regexet. -e gör de enklare att skriva ut regexet utan massa \- ,
#sorterar efter ipadress. räknar förekomst av ipadressen dvs unika count. sorterar efter störst antal "nr".
journalctl -u ssh | grep "Accepted\|Failed password" | tail -n 100 | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c | sort -nr >> "$RAPPORT"

# 5. Diskutrymme + varning vid >80%
echo -e "\n[5] Diskutrymme:" >> "$RAPPORT"
df -h --output=pcent,target | tail -n +2 | while read rad; do #df= diskussage -h humanreadable output i % och target visar monteringspunkter, där tail visar neifrån +2 alltså andra raden och uppåt.
#read läser en rad i taget från df utdata in i variabeln rad. 
    Procent=$(echo $rad | awk '{print $1}' | tr -d '%') # ur variabeln rad hämtar awk  ut första fältet dvs diskprocent. tr -d tar bort % tecknet och procent variabeln blir = detta. 
    if [ "$Procent" -ge 80 ]; then #om procent -greater than 80 då kör den igång varning och loggar detta med append omdirigering. 
        echo "VARNING: $rad" >> "$RAPPORT"
    else #annars om procent variabeln inte är högre än 80 så loggar den OK procentm monteringspunkt
        echo "OK: $rad" >> "$RAPPORT"
    fi 
done
