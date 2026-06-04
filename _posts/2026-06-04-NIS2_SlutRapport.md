**B3. Slutrapport (Inlämnad inom en månad – 16 juni 2026\)**

**Slutgiltigt utredningsresultat**

Den forensiska utredningen är avslutad. Det har fastställts att hotaktören var en extern aktör som utnyttjade en kombination av applikationssårbarheter och ett svagt lösenord på systemnivå. Angriparen lyckades dumpa delar av applikationens användardatabas samt komma åt systemets användarlista via filen /etc/passwd. Eftersom det komprometterade kontot saknade administratörsrättigheter (sudo) bekräftas att systemets /etc/shadow\-fil och dess lösenordshashar aldrig har blivit exponerade. Systemen har sanerats och inga spår av persistent skadlig kod, bakdörrar eller kvarvarande obehöriga sessioner har identifierats.

**Rotorsaksanalys**

Incidenten möjliggjordes av tre primära organisatoriska och tekniska brister:

* Arkitektonisk felkonfiguration (Origin Bypass): En felaktig portmappning i containerarkitekturen tillät direkt extern åtkomst till webbplatsens backend-port, vilket gjorde det möjligt för angriparen att runda säkerhetskontrollerna i organisationens reverse proxy.  
    
* Bristande systemisolering: Containrarna i Docker-miljön var direkt sammankopplade, vilket tillät sidledsförflyttning till administrationsservern när webbapplikationen väl var attackerad.  
    
* Otillräcklig åtkomstkontroll: Den administrativa servern tillät sårbar lösenordsbaserad autentisering med ett alldeles för svagt lösenord för kontot student, vilket gjorde det möjligt för angriparen att gissa rätt.

**Vidtagna och planerade härdningsåtgärder**

För att minimera risken för återupprepning har följande åtgärder verkställts:

* Eliminering av skuggportar och isolering: Den publika direktporten till backend-applikationen har stängts permanent och all trafik tvingas passera genom reverse proxyn. Nätverkskopplingarna har konfigurerats om för att isolera både webbcontainrar och övervakningssystemet (Wazuh Dashboard) från övriga interna systemenheter.  
    
* Identitetshärdning: Lösenordsautentisering för administrativa fjärranslutningar har inaktiverats helt. Systemet tillåter nu uteslutande kryptografiska SSH-nycklar i kombination med en strikt och centraliserad lösenordspolicy för alla administrativa paneler.  
    
* Implementering av skyddsmekanismer: Begränsningar för antal anrop per minut (rate limiting) har aktiverats i reverse proxyn för att blockera automatiserade enumerationer. En Web Application Firewall (WAF) har installerats för att inspektera och blockera applikationsattacker i realtid, och operativsystemsnära revisionsloggning (auditd) har driftsatts för att omedelbart larma vid obehöriga filläsningar.  
    
* Etablering av Incident Response-plan: En formell policy för incidenthantering samt tekniska playbooks har upprättats för att standardisera framtida detektions- och inneslutningsförlopp.


Härmed anses ärendet avslutat från Northern Digital AB:s sida.  
