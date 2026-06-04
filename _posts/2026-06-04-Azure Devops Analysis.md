# **Northstar Care**

## Bakgrund

Northstar Care arbetar med att flytta och konsolidera flera interna IT-system till Microsoft Azure. I fokus för detta case står företagets interna webbportal som används av supportpersonal och chefer för att hantera kundärenden, ladda upp dokument och söka i interna rutiner. Företaget har även påbörjat tester av en agentfunktion som kan besvara frågor baserat på interna dokument.

Efter migreringen finns misstankar om felkonfigurationer och brister i säkerheten. Uppgiften går därför ut på att undersöka den befintliga lösningen, identifiera risker och föreslå eller genomföra förbättringar där det är möjligt.

## Uppgiftens omfattning

Arbetet omfattar:

- Kartläggning av applikationens arkitektur och Azure-resurser.
- Analys av roller, behörigheter och åtkomsthantering.
- Granskning av CI/CD-flödet i Azure DevOps.
- Hantering av secrets och konfigurationsdata.
- Identifiering och bedömning av säkerhetsrisker.
- Genomförande av utvalda säkerhetsåtgärder.
- Reflektion kring resultat, begränsningar och lärdomar.

## Rapportens innehåll

Rapporten beskriver den tekniska lösningen, de Azure-tjänster som används, identifierade säkerhetsbrister samt de åtgärder som genomförts under arbetet. Den innehåller även en diskussion kring kvarstående risker och de begränsningar som funnits, bland annat relaterade till behörigheter i Azure-miljön.

Syftet med arbetet är att analysera hur en molnbaserad applikation kan säkras genom förbättrad konfiguration, säkrare hantering av hemligheter, förstärkt autentisering och ett mer kontrollerat deploymentsflöde.









# **Rapport**


## Kort beskrivning av lösningen

Applikationen är uppbyggd som en fullstack-lösning med en separat frontend och backend. Frontend är byggd med Vite och innehåller React-baserade komponenter, sidor och API-anrop som kommunicerar med backend.   
Backend är en Node.js-applikation med Express och är strukturerad i olika lager såsom controllers, routes, services, repositories och middleware för att separera ansvar och logik. Applikationen använder även en SQLite-databas via better-sqlite3 för lagring av data.

Deploymentflödet sker via en CI/CD-pipeline i Azure DevOps. När kod pushas till repositoryt triggas en pipeline som installerar dependencies, bygger applikationen och kör kontroller innan den deployas automatiskt till en Azure App Service.

De Azure-resurser som används är främst en App Service för hosting av webbapplikationen samt en service connection mellan Azure DevOps och Microsoft Azure som möjliggör deployment från pipelinen till molnmiljön. Application Settings används även för konfiguration och miljövariabler.

## Roller och rättigheter

   
Vi behövde tillhöra organisationen northstarcare i Azure DevOps och ha rätt roller för att kunna arbeta med pipelines. De viktigaste rollerna var Project Administrator, för att kunna skapa pipelines och hantera projektinställningar, samt Contributor, för att kunna köra pipelines och modifiera kod. Utöver detta krävdes även specifika Build- och Release-rättigheter kopplade till projektet för att kunna köra och hantera pipeline runs.

Skillnaden mellan Azure DevOps och Microsoft Azure är tydlig. Azure DevOps används för utvecklingsprocessen, där man hanterar kod, pipelines och automatiserade tester. Azure Portal används däremot för att hantera resurser i molnet, såsom webbtjänster, nätverk och säkerhetsinställningar.

Därför behövs båda delarna i vårt fall. Azure DevOps används för att bygga, testa och distribuera applikationen via pipelines, medan Azure Portal används för att tillhandahålla infrastrukturen där webbapplikationen körs. Utan en applikation finns inget att köra i molnet, och utan molninfrastruktur skulle applikationen behöva hostas på en egen server. I vårt fall använder vi azures appservice som en form av Platform as a Service (PaaS) för att hosta vår webbapplikation.

Även när vi lägger till loggning och övervakning via Azure Monitor samt säkerhetstjänster som Microsoft Defender for Cloud förändras inte hela lösningen till SaaS. Istället använder vi flera olika tjänstemodeller samtidigt. Själva webbapplikationen hostas som en plattformstjänst (PaaS), medan övervakning och säkerhet tillhandahålls som molnbaserade tjänster ovanpå denna. Azure DevOps är i sin tur en SaaS-tjänst som används för CI/CD-processen

## CI/CD

CI/CD-pipelinen i Azure DevOps är uppbyggd för att automatisera hela flödet från kod till deployment. När kod pushas till repositoryt triggas pipelinen automatiskt och kör en sekvens av steg som säkerställer att koden är byggbar, säker och redo för drift.

Först installeras dependencies och applikationen byggs. Därefter körs kontroller som inkluderar validering av konfiguration samt säkerhetsgranskning av beroenden. Under arbetet identifierades tidigare brister såsom osäkra npm-paket och avsaknad av säkerhetskontroller, vilket ledde till att förbättringar infördes i form av uppdaterade paket samt införande av säkerhetsrelaterade bibliotek som express-rate-limit och helmet.

Om alla steg lyckas paketeras applikationen och deployas automatiskt till App Service i Microsoft Azure, vilket gör att nya versioner snabbt och konsekvent kan tas i drift utan manuell hantering.

## 

## Secrets och konfiguration

Applikationen kräver två känsliga konfigurationsvärden för att fungera korrekt: en hemlig nyckel (JWT-secret) för att signera och verifiera autentiseringstokens samt en sökväg till databasen för att applikationen ska kunna läsa och spara data.

Ursprungligen var JWT-secret hårdkodad i källkoden som ett fallback-värde (“northstar-dev-secret”), vilket innebar att nyckeln var synlig för alla med åtkomst till repositoryt. Detta åtgärdades genom att generera en kryptografiskt stark nyckel med openssl rand \-hex 64 och därefter lagra den som en miljövariabel i Microsoft Azure via Application Settings.

Även databassökvägen gjordes om till en obligatorisk miljövariabel och konfigureras på samma sätt, vilket säkerställer att applikationen inte kan startas utan korrekt och säker konfiguration.

## Säkerhetsanalys

I denna uppgift genomfördes en säkerhetsanalys av applikationen, dess CI/CD-flöde i Azure DevOps samt molnmiljön i Microsoft Azure. Analysen visade på flera allvarliga sårbarheter, framför allt kopplade till autentisering, hantering av hemligheter och API-säkerhet.

Bland de mest kritiska problemen som identifierades fanns ett hårdkodat JWT-secret i källkoden, vilket innebar att en angripare potentiellt kunde förfalska autentiseringstokens och få administratörsbehörighet. Utöver detta upptäcktes att standardlösenord var hårdkodade och identiska för alla användare, vilket utgjorde en stor risk för obehörig åtkomst. Även JWT-verifieringen saknade begränsning av algoritm, vilket öppnade upp för manipulation av tokens.

Flera sårbarheter med hög och medelhög risk identifierades också, såsom avsaknad av rate limiting på inloggningsendpointen, vilket gjorde systemet sårbart för brute force-attacker, samt att JWT-tokens inte ogiltigförklarades vid logout. Det upptäcktes även att känslig information loggades i klartext och att applikationen saknade viktiga säkerhetsheaders samt en korrekt konfigurerad CORS-policy, vilket ökade attackytan ytterligare.

Prioriteringen av dessa problem gjordes utifrån deras potentiella påverkan. Kritiska sårbarheter som rörde autentisering och hemligheter åtgärdades först, följt av sårbarheter som kunde utnyttjas för attacker, såsom brute force och token-manipulation. Därefter hanterades svagheter som rörde konfiguration och best practice.

Upptäckterna kom från flera delar av systemet. De flesta sårbarheterna återfanns i själva applikationen, medan pipeline-analysen i Azure DevOps visade på beroendesårbarheter och avsaknad av vissa säkerhetskontroller. Möjligheten att använda Microsoft Defender for Cloud var begränsad eftersom nödvändiga behörigheter (Owner) saknades i Azure Portal, vilket innebar att analysen i större utsträckning fick genomföras manuellt.

## Åtgärder

För att åtgärda de identifierade säkerhetsbristerna genomfördes flera förbättringar i både applikation, pipeline och konfiguration. Kritiska sårbarheter som hårdkodat JWT-secret och standardlösenord eliminerades genom att flytta känsliga värden till miljövariabler i Microsoft Azure via Application Settings samt genom att ersätta statiska värden med kryptografiskt säkra och unikt genererade nycklar och lösenord.

Autentiseringsflödet förstärktes genom att begränsa JWT-algoritm, införa token blacklist vid logout samt implementera rate limiting för att minska risken för brute force-attacker. Säkerheten i API:et förbättrades ytterligare genom införande av HTTP-säkerhetsheaders via Helmet samt en striktare CORS-konfiguration som begränsar åtkomst till betrodda domäner.

Loggning och dataskydd förbättrades genom att känslig information togs bort från audit logs, vilket minskar risken för informationsläckage. Dessutom säkerställdes att databaskonfigurationen är robust genom att göra DB\_PATH till en obligatorisk miljövariabel, vilket eliminerar osäkra fallback-lägen.

Sammantaget har dessa åtgärder avsevärt förbättrat säkerhetsnivån genom att minska attackytan, stärka autentisering och säkerställa bättre skydd av känslig data. Samtidigt kvarstår vissa begränsningar, såsom avsaknad av fullständig automatisering av security gates i CI/CD-pipelinen samt begränsningar i molnbehörigheter som påverkar möjligheten att implementera vissa säkerhetsfunktioner.

## Reflektion

En av de största utmaningarna i arbetet var att förstå hur säkerhetsbrister samverkar mellan olika delar av systemet, såsom applikationen, pipelinen och molninfrastrukturen. Det var också utmanande att hantera både begränsningar i och brist på behörigheter, särskilt kopplat till RBAC och ärvda rättigheter i Microsoft Azure. Trots administratörsbehörighet kunde vi inte isolera vår grupp eller fullt ut tillämpa principen om least privilege. Vi hade inte heller tillräckliga rättigheter för att implementera Microsoft Defender for Cloud, vilket ytterligare begränsade möjligheten att införa säkerhetsåtgärder på önskad nivå.

Det mest lärorika var att arbeta praktiskt och audita källkoden med verkliga säkerhetsproblem och se hur små misstag, som hårdkodade hemligheter, kan få allvarliga konsekvenser. Arbetet visade också tydligt hur viktigt det är med rätt behörigheter i molnmiljöer, då avsaknaden av tillgång till verktyg som Microsoft Defender for Cloud begränsade möjligheten att arbeta med inbyggda säkerhetsfunktioner.

Om lösningen skulle byggas om från början hade säkerhet integrerats tidigare i utvecklingsprocessen enligt principen “secure by design”. Det hade även varit fördelaktigt att implementera striktare rollbaserad åtkomstkontroll från start samt att inkludera säkerhetskontroller direkt i CI/CD-pipelinen. Slutligen hade en mer genomtänkt hantering av användarautentisering och lösenordsflöden kunnat minska behovet av senare åtgärder.

