**B2. Incidentanmälan (Inlämnad inom 72 timmar – 19 maj 2026\)**

**Uppdaterad händelsebeskrivning**

Efter genomförd teknisk analys kan ett fullständigt angreppsförlopp bekräftas. Incidenten har eskalerat från webbattacker till en systemkompromettering. Hotaktören har utnyttjat en felaktig nätverkskonfiguration (origin bypass), vilket möjliggjorde direkt kommunikation med applikationens backend utan att passera etablerade säkerhetsfilter.

Parallellt har en storskalig, automatiserad brute force-attack riktats mot organisationens administrativa server. Hotaktören lyckades kompromettera ett lokalt användarkonto och uppnå obehörig systemåtkomst. På grund av felaktigt sammankopplade systembehållare (containrar) kunde angriparen ta sig vidare och utföra en dumpning av systemets användarlista via filen /etc/passwd. Då det komprometterade kontot saknade administratörsrättigheter har inga krypterade lösenordshashar från /etc/shadow varit åtkomliga. Listan över systemets användarnamn slogs därefter samman med de stulna användaruppgifterna från webbplatsen i en lokal uppsamlingsfil i syfte att förbereda datastöld.

Tidslinje över incidentförloppet (16 maj 2026\)

* 13:13 Misstänkt skanningsaktivitet och riktade webbattacker identifieras mot den publika webbplatsen.  
* 13:14 Obehöriga anrop och kontoenumerationer observeras mot webbplatsens bakomliggande tjänster.  
* 13:15 Avvikande och högfrekventa inloggningsförsök identifieras mot den administrativa servern.  
* 13:16 Kompromettering och obehörig inloggning på det lokala användarkontot verifieras till följd av lyckad brute force.  
* 13:17 Upptäckt av en obehörigt skapad lokal datafil innehållande stulna användaruppgifter och systemets användarlista.  
* 13:18 Incidenten klassificerades formellt som en allvarlig säkerhetsincident.  
* 13:20 Akuta inneslutningsåtgärder verkställs och angriparens externa kommunikationsvägar kapas.

Bedömning av påverkan

* Påverkade tjänster: Den publika webbapplikationens tillgänglighet har varit temporärt begränsad på grund av ett tekniskt funktionsfel i backend. Det administrativa servergränssnittet har varit komprometterat på användarnivå.  
* Konsekvenser för verksamheten: Incidenten har medfört en bekräftad påverkan på informationens konfidentialitet gällande användaruppgifter och interna användarnamn. Risken för sidledsförflyttning (spridning) är nu helt avvärjd.  
* Allvarlighetsgrad: Hög.

Samordning med parallell lagstiftning (GDPR)

Incidenten har utretts i samråd med organisationens dataskyddsfunktion och dataskyddsombud (DPO). Då det har konstaterats att hotaktören har kommit åt och sammanställt användarprofiler samt systemets interna användarnamn tillhörande cirka tio anställda, har händelsen klassificerats som en personuppgiftsincident enligt dataskyddsförordningen (GDPR).

En parallell anmälan enligt artikel 33 GDPR upprättas och skickas till Integritetsskyddsmyndigheten (IMY). 

