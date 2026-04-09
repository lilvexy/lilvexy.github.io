## **Attack Tekniker & Metoder**

MITM‑attacker kan genomföras på flera OSI‑lager, från fysiskt avlyssnande på lager 1 till protokoll‑ och applikationsbaserade attacker på lager 7\. Vi går genom vissa metoder för att uppnå MITM.  
MITM‑attacker utnyttjar främst protokoll som saknar autentisering, kryptering eller integritetskontroller.

##  **(**Om trafiken är krypterad är innehållet inte läsbart, men okrypterad trafik kan avlyssnas gäller alla exempel nedan om inget annat nämns.)

**Layer1:** där du kan avtappa kommunikation/signal från kablarna , eller waves från wifi/bluetooth,  
**Layer 2** :ARP cache poisioning/spoofing, switch table flooding, Rogue routing  
**Layer 3**, ip spoofing, BGP hijacking  
**Lager4:**  tcp hijacking  
**Lager 5** : session hijacking  
**Layer 6** : innehåller inga fristående MITM‑attacker. Kryptering hör till detta lager, men i praktiken hanteras den av applikationer, vilket gör att MITM‑attacker som påverkar kryptering ofta utförs och beskrivs på lager 7\.  
**Layer 7:** ssl stripping, dns spoofing(etableras i lager 3 men utförs i 7),API interception, http spoofing 

## **Steg-för-steg: Vad händer under attacken?** 

#### **Fysisk sniffing** är en attack där en angripare med fysisk åtkomst till nätverksinfrastruktur, exempelvis en media‑converter som omvandlar Ethernet (RJ45) till fiber, manipulerar dess konfiguration eller mjukvara för att passerande nätverkstrafik. Attacken utnyttjar att all data, oavsett protokoll, i slutändan transporteras som elektriska eller optiska signaler på OSI‑lager 1 (fysiska lagret), medan protokoll som Ethernet, IP och högre lager enbart kapslas ovanpå dessa signaler.

Angriparen behöver få fysisk tillgång till utrustningen, exempelvis i ett serverrum, teknikskåp eller annan otillräckligt skyddad miljö. Därefter modifieras mediakonvertern så att den speglar trafiken till angriparens egen enhet utan att påverka den ordinarie kommunikationen. Angriparen kan därefter analysera den kopierade trafiken och identifiera använda protokoll genom synlig metadata, exempelvis information från en TLS‑handshake, vilket avslöjar om och hur kommunikationen är krypterad.

Attacken utnyttjar främst avsaknad av fysiskt skydd och övervakning, samt avsaknad av kryptering i nätverksstacken.

Konsekvenserna för en organisation kan leda till informationsläckage**,** brott mot sekretesskrav, förlorat förtroende och potentiella regulatoriska konsekvenser. Angriparen kan samla in känslig information från okrypterad trafik, kartlägga nätverkets struktur och kommunikationsmönster samt förbereda vidare attacker. 

### **ARP spoofing** är en attack där en angripare utnyttjar svagheter i Address Resolution Protocol (ARP), som används för att mappa IP-adresser (OSI-lager 3\) till MAC-adresser på OSI-lager 2 i lokala nätverk. ARP saknar autentisering och bygger på tillit, vilket gör att enheter accepterar ARP-svar utan att verifiera avsändaren.

För att genomföra attacken måste angriparen befinna sig på samma lokala nätverk eller broadcast-domän som offret. Man skickar förfalskade ARP-svar till både offret och till exempel nätverkets gateway. Dessa svar länkar angriparens MAC-adress med offrets mot gatewayen och gatewayens IP-adress till angriparen för offrets arp cache, vilket gör att mottagarna uppdaterar sina ARP-tabeller. Trafik som normalt går direkt mellan offret och gatewayen omdirigeras därmed genom angriparen.

När angriparen hamnar i denna position kan trafiken vidarebefordras för att förbli oupptäckt (MITM), analyseras eller modifieras, eller släppas helt för att orsaka denial of service. Attacken kräver nätverksåtkomst och utnyttjar ARP-protokollets avsaknad av verifiering på IP–MAC-bindningar.

Konsekvenserna kan bli avlyssning av okrypterad trafik, stöld av inloggningsuppgifter och sessionsdata samt manipulering av information. För en organisation kan detta leda till informationsläckage, kontokapning, driftstörningar och minskat förtroende, attacken är svår att upptäcka utan skyddsåtgärder såsom Dynamic arp inspection, de går även att neutralisera konsekvenserna av de flesta MITM attackerna genom att kryptera trafiken. 

#### **Switch Flooding**

En switch använder en **adress tabell (CAM‑tabell)** för att veta vilken port varje MAC‑adress hör till. En angriparen utnyttjar detta genom att skicka **många Ethernet‑ramar med påhittade käll‑MAC‑adresser** in i switchen.  
När tillräckligt många unika MAC‑adresser tas emot blir switchens CAM‑tabell **överfull**, vilket gör att switchen inte längre vet vilken port legitima MAC‑adresser finns på.  
När detta sker börjar switchen skicka trafik till alla portar, likt en hub. Angriparen kan då ta emot kopior av trafik som egentligen var avsedd för andra enheter. 

#### **Rogue routing** är en attack där en angripare introducerar en obehörig eller komprometterad router i ett nätverk, eller tar kontroll över en befintlig router, och börjar annonsera falska eller manipulerade rutter via ett routingprotokoll såsom RIP, OSPF eller BGP. Eftersom routingprotokoll bygger på automatisk informationsutbyte och tillit accepterar andra routrar dessa annonseringar och uppdaterar sina routingtabeller.

Detta leder till att trafik istället dirigeras via angriparens router. **BGP hijacking** är en särskild form av rogue routing som sker på internet nivå mellan större, självständiga nätverk, exempelvis nät som drivs av internetleverantörer eller stora organisationer. I denna attack annonserar angriparen falska BGP-rutter för IP-prefix som tillhör andra aktörer. Andra routrar på internet accepterar annonseringarna och väljer dem baserat på faktorer som kortaste väg eller prefix.

För att genomföra rogue routing krävs åtkomst till routing infrastruktur, till exempel genom komprometterad router eller felaktig konfiguration. I fallet med BGP hijacking krävs att angriparen kan annonsera rutter till andra nätverk på internet. Attacken utnyttjar routingprotokollens brist på inbyggd verifiering av rutter. 

Konsekvenserna kan vara trafikdirigering, MITM attacker, DoS, dataläckage och förlust av förtroende. För organisationer kan detta innebära att tjänster blir otillgängliga och att nätverkstrafik avlyssnas eller missbrukas, både internt och över internet. En lösning på detta skulle kunna vara att routing uppdateringar signeras eller skyddas med kryptering genom ipsec tunlar. OSPF auth, RIP auth, TCP-AO signering (använder HMAC-SHA) är existerande lösningar som används idag, Varför hash och inte kryptering? Hash används för integritet och autentisering, inte sekretess, och en förändring av innehållet resulterar i en annan hash vilket möjliggör verifiering.

#### **IP spoofing** innebär att attackern skickar nätverkspaket med en förfalskad ip-adress så att de ser ut att komma från en annan adress.

För att genomföra attacken behöver personen kunna skicka IP-trafik till målet, men ingen fysisk åtkomst eller autentisering krävs. Attacken utnyttjar sårbarheten i IP-protokollet, dvs den avsaknad av mekanismen för att verifiera om IP-adressen är sann.  
Konsekvensen för en organisation kan vara en DoS attack, kringgående av IP-baserade säkerhetsregler, log förfalskning samt möjliggörande av mer avancerade attacker, särskilt i miljöer där tillit baseras på IP-adress snarare än stark autentisering.

#### **TCP hijacking** skickar angriparen spoofade tcp segment till servern som innehåller klientens ip och port, korrekt SEQ-Nummer och servern tror då att detta är klienten och uppdaterar tcp tillstånd, servern har nu accepterat data från angriparen och den riktiga klientens nästa paket får nu fel SEQ nummer så servern ignorerar klient eller svarar med en ACK.

För en tcp hijacking behöver angriparen kunna se trafiken (t.ex. via ARP spoofing, switch flooding, rogue router) för att få aktuell SEQ/ACK nummer samt veta vilka som pratar(klient och server) och angriparen behöver skicka paketet till servern innan klientens paket når till server för att lyckas. Konsekvenserna kan vara sessions kapning, datamanipulation och obehörig åtkomst, särskilt i okrypterade eller dåligt skyddade TCP-förbindelser.

#### **Session hijacking** är när angriparen tar över en redan autentiserad session mellan en klient och en server genom att komma över en sessionscookie, token eller ett giltigt TCP-tillstånd. Angriparen kan få denna information genom avlyssning på nätverket (t.ex. via ARP-spoofing), XSS, oskyddad HTTP-trafik eller bristfällig sessionshantering.

När angriparen skickar requests till servern med den stulna session informationen accepterar servern dessa som äkta för att sessionen redan är autentiserad. Angriparen agerar då som användaren utan att behöva logga in på nytt.

Förutsättningen för attacken är att angriparen kan observera eller påverka trafiken eller applikationen, samt att sessionen inte är tillräckligt skyddad med kryptering, säkra cookies eller korrekt sessions livslängd. Attacken utnyttjar sårbarheten att servern identifierar användare via session data snarare än kontinuerlig autentisering.  
Konsekvenserna kan vara obehörig åtkomst, kontokapning, dataläckage och manipulation av användarens resurse**r** vare sig privatperson eller organisationer.

#### **TLS/SSL stripping** sker när klienten försöker ansluta till en webbplats via HTTP och sedan bli omdirigerad till HTTPS, där fångar angriparen upp begäran och hindrar övergången till HTTPS.

Angriparen etablerar själv en krypterad HTTPS‑anslutning till servern, medan klienten hålls kvar i en okrypterad HTTP‑anslutning mot angriparen. Klienten tror sig kommunicera säkert, men all data skickas i klartext till angriparen som kan läsa eller modifiera innehållet innan det vidarebefordras krypterat till servern.  
Förutsättningen för attacken är att angriparen kan placera sig i trafikflödet och att webbplatsen tillåter HTTP‑kommunikation utan påtvingande av HTTPS. Sårbarheten här är just HTTP som inte är krypterad, och att övergången till HTTPS inte är skyddad.  
Konsekvenserna kan vara stulna inloggningsuppgifter, sessionskapning och datamanipulation, särskilt på webbplatser som inte använder HSTS eller där användaren inte explicit verifierar HTTPS‑anslutningen.

#### 

#### Vid **DNS spoofing** skickar angriparen ett spoofad DNS‑svar till en klient så att domännamn felaktigt kopplas till en IP‑adress som angriparen kontrollerar. 

Förutsättningarna för dns spoofing är att veta rätt transactions id, rätt källport, samt hinna svara innan en riktig DNS svarar klienten, då det kan vara svårt att gissa rätt id och port så brukar man först utföra arp spoofing för insyn.   
Dns protokollet har inte kryptering, protokollet verifieras bara via id och port och därför finns security extension, DNSSEC som skapar krypterade signaturer.

Konsekvenserna kan vara trafikomdirigering, phishing, sessionkapning och MITM‑attacker, där användaren omedvetet kommunicerar med angriparens system istället för den legitima tjänsten.

**API-interception** är när angriparen fångar och analyserar eller manipulerar API‑anrop mellan en klient och server, oftast över HTTP/HTTPS. När klienten skickar en API‑anrop (t.ex. REST eller JSON) fångas begäran upp innan den når servern. Angriparen kan då läsa innehållet, modifiera parametrar, återuppspela anrop eller skicka egna API‑förfrågningar som om de kom från klienten.  
Förutsättningen är att angriparen har möjlighet att inspektera API‑trafiken och att skyddsmekanismer som stark autentisering, korrekt TLS‑validering eller signering av API‑anrop saknas eller kringgås. Attacken utnyttjar förtroendet av API‑servrar som ofta litar på tokens eller sessioner utan att verifiera anropets ursprung eller integritet.  
Konsekvenserna kan vara obehörig åtkomst till backend‑funktioner, dataläckage, manipulation av applikationslogik och missbruk av API‑resurser

**HTTP spoofing** är när angriparen utger sig för att vara en webbserver och svarar på HTTP‑förfrågningar med falskt innehåll. Detta kan ske genom DNS spoofing, ARP spoofing eller annan MITM‑teknik som gör att klientens HTTP‑trafik skickas till angriparens server istället för den riktiga.  
När klienten skickar en HTTP‑request accepteras svaret från angriparen eftersom HTTP saknar kryptering och autentisering, och klienten kan inte verifiera serverns identitet. Angriparen kan då leverera manipulerade webbsidor, injicera skadlig kod eller samla in inloggningsuppgifter.  
Förutsättningen för attacken är att trafiken sker över okrypterad HTTP och att angriparen kan påverka hur klienten når servern. Attacken utnyttjar att HTTP inte verifierar vem som skickar svaret, utan litar på att rätt server svarar.

Konsekvenserna kan vara phishing, malware‑spridning, stöld av inloggningsuppgifter och vidare MITM‑attacker, vilket kan leda till dataläckage och komprometterade system.  
