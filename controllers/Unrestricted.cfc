<cfcomponent
	extends="abstract_component_intranet">
		
	<cffunction name="init">
		<cfset filters(through="before",type="before") />
	</cffunction>
	
	<cffunction name="before">
		<cfscript>
			usesLayout(false);
		</cfscript>
	</cffunction>
		
	<cffunction name="getPrinters" >
		<cfscript>
			
			var obj = APPLICATION.cfc.printers.init();
			obj.xmlToDatabase();
			
			renderNothing();
		</cfscript>
	</cffunction>
	
	<cffunction name="getEstatesFromWeb"
		hint="Pobranie nieruchomości z formularza na stronie firmowej">
		<cfscript>
			
		</cfscript>
	</cffunction>
	
	<cffunction
		name="pobierzSaldaAjentow"
		hint="Pobranie sald Ajentow"
		description="Metoda wywołuje się cyklicznie raz na dob® aby zasilić 
			bazę nowymi danymi. Na tej podstawie generowane jest saldo Ajenta">
		
		<cfsetting requestTimeout="3600" />
		
		<cfscript>
			// <cfset createdNextMonthDate = CreateDate(year(Now()),month(dateAdd('m',1,Now())),1)>
			var monthFirstDay = CreateDate(Year(Now()), Month(Now()), 1);
			var prevMonthLastDay = DateAdd("d", -1, monthFirstDay);
			var obj = APPLICATION.cfc.asseco.init(datasource="asseco");
			
			// obj.potwierdzenieSaldaImport(naDzien="20130531");
			obj.potwierdzenieSaldaImport(naDzien="#DateFormat(prevMonthLastDay, 'yyyymmdd')#");
			renderNothing();
			
		</cfscript>
		
	</cffunction>
	
	<cffunction name="clearJvmMemory" hint="">
			
		<cfparam name="url.maxused" default="999">
		<cfparam name="url.minfree" default="300">

		<cfif NOT isDefined("runtime")>
			<cfset runtime = CreateObject("java","java.lang.Runtime").getRuntime()>
		</cfif>

		<cfset fm = runtime.freememory()/>
		<cfset fm = int((fm/1024)/1024)/>
		<cfset usedmem = 1270-fm/>
		
		<cfoutput>
			#Now()#<br>
			Before<br>
			Free: #fm# megs<br>
			Used: #usedmem# megs<br>
		</cfoutput>

		<br>
		<!--- check if we are using too much memory --->
		<cfif usedmem gt url.maxused or fm lt url.minfree>
 		<cfset runtime.gc()>
			Released Memory<br>
		<cfelse>
			No need to release memory using the thresholds you provided<br>
		</cfif>

		<br>
		<cfset fm = runtime.freememory()/>
		<cfset fm = int((fm/1024)/1024)/>
		<cfset usedmem = 1270-fm/>
		
		<cfoutput>
			After<br>
			Free: #fm# megs<br>
			Used: #usedmem# megs<br>
		</cfoutput>
		
		<cfset renderNothing() />
			
	</cffunction>
	
	<!---
		16.07.2013
		Akcja wywoływana codziennie z samego rana.
		Oznaczanie WAP, których data obowiązywania do się skończyła, 
		jako archiwalne.
	--->
	<cffunction name="archiveInstructions" output="false" access="public" hint="">
		<!--- Pobieram listę Instrunkcji, które dzisiaj się kończą --->
		<cfset expiredInstructions = model("instruction").getExpiredInstructions() />
		
		<!--- W pętli archiwizyje dokumenty --->
		<cfloop query="expiredInstructions">
			<cftry>
					
				<cfset toArchive = model("instruction").toArchive(documents = instruction_number) />
					
				<cfcatch type="any" >
					<cfmail
						to="admin@monkey.xyz"
						from="Archiwizacja WAP - Monkey<intranet@monkey.xyz>"
						replyto="#get('loc').intranet.email#"
						subject="Archiwizacja WAP"
						type="html">
					
						<cfdump var="#cfcatch#" />

					</cfmail>
				</cfcatch>
			</cftry>
		</cfloop>
		
		<cfset renderNothing() />
		
	</cffunction>
	
<!---	<cffunction name="workflowCount" output="false" access="public" hint="">
	
		<cfset var qcount = "" />
		<cfquery name="qcount" datasource="#get('loc').datasource.intranet#">
			select count(*), d.userid, u.givenname, u.sn from documents d inner join users u on d.userid = u.id where Year(d.documentcreated) = Year(Now()) and Month(d.documentcreated) = Month(Now()) and Day(d.documentcreated) = Day(Now()) group by d.userid;  
		</cfquery>
		
		<cfdump var="#qcount#" />
		<cfabort />
	</cffunction>--->
	
	<!--- Ta metoda wywoływana jest przez scheduler --->
	<cffunction name="delPermanentlyWorkflow" output="false" access="public" hint="">
		<cfsetting requesttimeout="30" />
		
		<!--- pobieram workflowid i documentid faktur do usuniecia --->
		<cfset ids = model("workflow").getToDelete() />
		
		<cfthread action="run" name="del#TimeFormat(Now(), 'HHmm')#" priority="HIGH" >
			<cfloop query="ids">
				<cftry>
				
				<!--- Usunięcie dokumentu z obiegu --->
				<cfset deletedWorkflow = model("workflow").delete(
					workflowid = workflowid,
					documentid = documentid,
					userid = 1,
					ip = 'local') />

				<cfcatch type="any"> <!--- Komunikat błędu aplikacji --->
					<cfsavecontent variable="myMail" >
						<h2>Błąd przy usuwaniu faktury</h2>
						<cfdump var="#ids#" />
						<cfdump var="#cfcatch#" />
					</cfsavecontent>
					
					<cfset sender = APPLICATION.cfc.email.init() />
					<cfset sender.setTo(
						model("user").findAll(where="id=2")
					).setSubject(subject="Usunięcie faktury").setBody(body=myMail).send() />
					
				</cfcatch>

				</cftry>
			</cfloop>
		</cfthread>
		
		<cfsavecontent variable="myDump" >
			<h2>Faktury do usunięcia</h2>
			<table>
				<thead>
					<tr>
						<th>Numer faktury</th>
						<th>workflowId</th>
						<th>documentId</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="ids">
						<tr>
							<td>#documentname#</td>
							<td>#workflowid#</td>
							<td>#documentid#</td>
						</tr>
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="2">Ilość faktur</th>
						<th><cfoutput>#ids.recordCount#</cfoutput></th>
					</tr>
				</tfoot>
			</table>
		</cfsavecontent>
		<cfset sender = APPLICATION.cfc.email.init() />
		<cfset sender.setTo(
				model("user").findAll(where="id=2")
			).setSubject(subject="Usunięcie faktur").setBody(body=myDump).send() />
		
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction 
		name="indexReminder"
		hint="Wysyłanie powiadomienia o indeksach"
		description="Wysyłanie zbiorczego powiadomienia o zmianach w indeksach raz na dobe"
		output="false" 
		access="public">
		
		<cfset datetime = DateFormat(DateAdd('d', -1, Now()),'yyyy-mm-dd') />
		
		<!---<cfset statuses = model("Product_step").findAll(
			select="userid, indexid, step, comment"
			,where="date > '#datetime#' AND notice_sent=0"
			,order="step ASC"
		)/>--->
		<cfset statuses = model("Product_step").findLastStatuses(date="#datetime#")/>

		<cfset emails = ArrayNew(2) />
		<cfset users = ArrayNew(1) />
		
		<cfset _users = model("Tree_groupuser").getGroupUsersFull(68) />
		<cfloop query="_users">
			
			<cfset users[_users.userid] = StructNew() />
			<cfset StructInsert(users[_users.userid], 'id', _users.userid, true) />
			<cfset StructInsert(users[_users.userid], 'email', _users.mail, true) />
			<cfset StructInsert(users[_users.userid], 'name', _users.givenname & ' ' & _users.sn, true) />
			
			<cfloop query="statuses">
				
				<cfset _status = StructNew() />
				<cfset StructInsert(_status, 'userid', statuses.userid, true) />
				<cfset StructInsert(_status, 'indexid', statuses.indexid, true) />
				<cfset StructInsert(_status, 'step', statuses.step, true) />
				<cfset StructInsert(_status, 'comment', statuses.comment, true) />
				<cfset StructInsert(_status, 'name', statuses.name, true) />
				
				<cfif statuses.step eq 1>
					<cfset StructInsert(_status, 'message', 'Nowy indeks "#statuses.name#" nr #statuses.indexid# w zakładce Nowe indeksy.', true) />
					<cfset ArrayAppend(emails[_users.userid], _status) />
				</cfif>
				
				<cfif statuses.step eq 4>
					<cfset StructInsert(_status, 'message', 'Zmieniono status indeksu "#statuses.name#" nr #statuses.indexid# na "zaakceptowany"', true) />
					<cfset ArrayAppend(emails[_users.userid], _status) />
				</cfif>
			</cfloop>
			
		</cfloop>
		
		<cfset _users = model("Tree_groupuser").getGroupUsersFull(69) />
		<cfloop query="_users">
			
			<cfset users[_users.userid] = StructNew() />
			<cfset StructInsert(users[_users.userid], 'id', _users.userid, true) />
			<cfset StructInsert(users[_users.userid], 'email', _users.mail, true) />
			<cfset StructInsert(users[_users.userid], 'name', _users.givenname & ' ' & _users.sn, true) />
			
			<cfloop query="statuses">
				
				<cfset _status = StructNew() />
				<cfset StructInsert(_status, 'userid', statuses.userid, true) />
				<cfset StructInsert(_status, 'indexid', statuses.indexid, true) />
				<cfset StructInsert(_status, 'step', statuses.step, true) />
				<cfset StructInsert(_status, 'comment', statuses.comment, true) />
				<cfset StructInsert(_status, 'name', statuses.name, true) />
				
				<cfif statuses.step eq 2>
					<cfset StructInsert(_status, 'message', 'Zmieniono status indeksu "#statuses.name#" nr #statuses.indexid# na "zweryfikowany"', true) />
					<cfset ArrayAppend(emails[_users.userid], _status) />
				</cfif>
				
				<cfif statuses.step eq 3>
					<cfset StructInsert(_status, 'message', 'Zmieniono status indeksu "#statuses.name#" nr #statuses.indexid# na "odrzucony na etapie weryfikacji"', true) />
					<cfset ArrayAppend(emails[_users.userid], _status) />
				</cfif>
			</cfloop>
			
		</cfloop>
		
		<cfset _users = model("Tree_groupuser").getGroupUsersFull(70) />
		<cfloop query="_users">
			
			<cfset users[_users.userid] = StructNew() />
			<cfset StructInsert(users[_users.userid], 'id', _users.userid, true) />
			<cfset StructInsert(users[_users.userid], 'email', _users.mail, true) />
			<cfset StructInsert(users[_users.userid], 'name', _users.givenname & ' ' & _users.sn, true) />
			
			<cfloop query="statuses">
				
				<cfset _status = StructNew() />
				<cfset StructInsert(_status, 'userid', statuses.userid, true) />
				<cfset StructInsert(_status, 'indexid', statuses.indexid, true) />
				<cfset StructInsert(_status, 'step', statuses.step, true) />
				<cfset StructInsert(_status, 'comment', statuses.comment, true) />
				<cfset StructInsert(_status, 'name', statuses.name, true) />
				
				<cfif statuses.step eq 4>
					<cfset StructInsert(_status, 'message', 'Zmieniono status indeksu "#statuses.name#" nr #statuses.indexid# na "zaakceptowany"', true) />
					<cfset ArrayAppend(emails[_users.userid], _status) />
				</cfif>
				
				<cfif statuses.step eq 5>
					<cfset StructInsert(_status, 'message', 'Zmieniono status indeksu "#statuses.name#" nr #statuses.indexid# na "brak akceptacji"', true) />
					<cfset ArrayAppend(emails[_users.userid], _status) />
				</cfif>
			</cfloop>
			
		</cfloop>
		
		<cfset renderPage(controller="emails", action="sendIndexReminder")>
		
	</cffunction>
	
	<!---
		Pobieranie danych z bazy eLeader do bazy PostgreSQL.
		Wszystkie operacje przetwarzania i pobierania raportów odbywają się na 
		bazie postgres
	--->
	<cffunction name="eleaderPobierzDane" output="false" access="public">
		<cfsetting requesttimeout="3600" />
		
		<cfset zadania = APPLICATION.cfc.eleader.pobierzDefinicjeZadanZEleader() />
		<cfset APPLICATION.cfc.eleader.aktualizujDefinicjeZadan(zadania) />
		
		<cfset pola = APPLICATION.cfc.eleader.pobierzDefinicjePolZEleader() />
		<cfset APPLICATION.cfc.eleader.aktualizujDefinicjePol(pola) />

		<cfset aos = application.cfc.eleader.pobierzWykonanieAosZEleader() />
		<cfset application.cfc.eleader.aktualizujWykonanieAos(aos) />
		
		<cfset wersje = application.cfc.eleader.pobierzWersjeZadanZEleader() />
		<cfset application.cfc.eleader.aktualizujWersjeZadan(wersje) />
		
		<cfset renderNothing() />
	</cffunction>
	
	<!---
		Wysyłanie powiadomień o odwołaniach od AOS.
		Email jest wysyłany do: Honoraty Czarnoty i Adama Czeszaka
	--->
	<cffunction name="powiadomienieOOdwolaniachAos" output="false" access="public" hint="Powiadomienia o odwołaniach">
		<cfset iloscOdwolan = application.cfc.eleader.iloscOdwolan() />
		<cfset structUzytkownicy = structNew() />
		<!---<cfset structInsert(structUzytkownicy, "Honorata Czarnota", "admin@monkey.xyz") />
		<cfset structInsert(structUzytkownicy, "Adam Czeszak", "admin@monkey.xyz") />--->
		
		<cfset structInsert(structUzytkownicy, "Honorata Czarnota", "honorata.czarnota@monkey.xyz") />
		<cfset structInsert(structUzytkownicy, "Adam Czeszak", "adam.czeszak@monkey.xyz") />
	</cffunction>
	
	<cffunction name="aktualizujDaneSklepu" outout="false" access="public">
		<cfsetting requesttimeout="3600" />
		
		<cfset APPLICATION.cfc.asseco.setDatasource(datasource="asseco") />
		<cfset stores = APPLICATION.cfc.asseco.getStores() />
		
		<cfloop query="stores">
		
			<cfset var tmpSklep = model("store_store").getStore(projekt=projekt, sklep=sklep, ajent=ajent) />
			<cfif tmpSklep.RecordCount EQ 0>
				<cfcontinue />
			</cfif>
			
			<cfset var podzielonyAdres = ListToArray(adressklepu) />
			<cfset var result = model("store_store").updateByKey(
				key = tmpSklep.id, 
				adressklepu = adressklepu, 
				ulica = podzielonyAdres[1],
				miasto = podzielonyAdres[2],
				loc_mall_name = loc_mall_name,
				loc_mall_location = loc_mall_location,
				ajent = "#NumberFormat(ajent, "000009")#",
				sklep = "#NumberFormat(sklep, "000009")#",
				nazwaajenta = nazwaajenta,
				dataobowiazywaniaod = dataobowiazywaniaod,
				m2_sale_hall = m2_sale_hall,
				m2_all = m2_all,
				longitude = longitude,
				latitude = latitude,
				<!--- zmiany z 30.12.2013 --->
				kodpsklepu = kodpsklepu,
				grupasklepu = grupasklepu,
				nip = nip,
				regon = regon,
				adresrejajenta = adresrejajneta,
				adreskorajenta = adreskorajneta
				<!--- koniec zmian z 30.12.2013 --->
				) />

		</cfloop>
		<cfset var gps = model("store_gps").tworzTabeleGps() />
		
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="przygotowanieTabelELeader" output="false" access="public" hint="">
	
		<!--- Start timing test --->
		<cfset tickBegin = GetTickCount()>

		<!--- This is where the script/code is you wish to test --->
		<cfset application.cfc.eleader.przygotujTabele() />

		<!--- Calculate final result --->
		<cfset tickEnd = GetTickCount()>
		<cfset testTime = tickEnd - tickBegin>

		<!--- Report the results of the test --->
		<cfoutput>Test time was: #testTime# milliseconds</cfoutput>
		<cfabort />
		
	</cffunction>
	
	<cffunction name="przebudowanieTabelEleader" output="false" access="public" hint="">
		<cfset tickBegin = getTickCount() />
		<cfset application.cfc.eleader.przygotujTabele() />
		<cfset tickEnd = getTickCount() />
		<cfset testTime = tickEnd - tickBegin />
		<cfoutput>Time was: #testTime# miliseconds</cfoutput>
		<cfabort />
	</cffunction>
	
	<cffunction 
		name="updateDebtrateData"
		hint="Metoda aktualizuje tabele z danymi do wskaźnika zadlużenia">
		
		<cfset qStarter = application.cfc.winapp.daylyUpdate() />		
		<cfset renderNothing() />		
		<cfreturn false />
		
	</cffunction>
	
	<cffunction name="cacheNieruchomosci" output="false" access="public" hint="">
		<cfsetting requestTimeout="3600" />
		
		<cfset nieruchomosciDb = createObject("component", "#get('loc').intranet.directory#.cfc.nieruchomosciIntranet").init(dsn=get('loc').datasource.intranet) />
		
		<cfset nieruchomosciDb.cacheFormularzyNieruchomosci() />
		<cfset renderNothing() />
	</cffunction>
	
	<!---
	<cffunction name="importWersjiMMarket" output="false" access="public" hint="">
		<cfsetting requestTimeout="3600" />
		<cfset pliki = model("mmarket").importAppVersionFiles() />
		
		<cfset db = model("mmarket").saveAppVersionInDb() />
		
		<cfset renderNothing() />
	</cffunction>
	--->
	
	<cffunction name="importNieruchomosciELeader" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		<cfset eleaderNieruchom = application.cfc.eleaderNieruchomosci.init(
			localDsn = "MSIntranet",
			remoteDsn = "eleader",
			intranetDsn = "intranet").synchronizujBaze() />
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="przeniesFaktureDoArchiwum" output="false" access="public" hint="">
		<cfsetting requesttimeout="7200" />
		
		<cfset sender = APPLICATION.cfc.email.init() />
		<cfset ids = model("workflow").pobierDoArchiwum() />
		
		<cfsavecontent variable="myIds" >
			<h2>Zaczynam przenoszenie do archiwum</h2>
			<table>
				<thead>
					<tr>
						<th>Numer faktury</th>
						<th>workflowId</th>
						<th>documentId</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="ids">
						<tr>
							<td>#numer_faktury#</td>
							<td>#workflowid#</td>
							<td>#documentid#</td>
						</tr>
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="2">Ilość faktur</th>
						<td><cfoutput>#ids.recordCount#</cfoutput></td>
					</tr>
				</tfoot>
			</table>
		</cfsavecontent>
		
		<cfset sender.setTo(
				model("user").findAll(where="id=2")
		).setSubject(subject="Przeniesienie faktur do archiwum").setBody(body=myIds).send() />
			
		<cfthread action="run" name="doArchiwum#TimeFormat(Now(), 'HHmmss')#" priority="high">
			<cfloop query="ids">
				<cftry>
					<cfset archiwumDokumentu = model("workflow").przeniesDoArchiwum(workflowid=workflowid,documentid=documentid,userid=1,ip='local') />
					
					<cfcatch type="any">
						<cfsavecontent variable="myMail">
							<cfdump var="#cfcatch#" />
						</cfsavecontent>
						
						<cfset sender = application.cfc.email.init() />
						<cfset sender.setTo(
							model("user").findAll(where="id=2")
							).setSubject(subject="Błąd przenoszenia do archiwum").setBody(body=myMail).send() />
					</cfcatch>
				</cftry>
			</cfloop>
		</cfthread>

		<cfset renderNothing() />
		
	</cffunction>
	
	<!---
		Raport wpłat z MMarket
	--->
	
	<cffunction name="pobierzRaportWplatZFtp" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		
		<cfset var startTime = getTickCount() />
		
		<cfset f = createObject("component", "cfc.ftp").init(usr="superuser", passwd="iSichei", prt="21", hst="10.99.9.3" ) />
		<cfset fa = createObject("component", "cfc.ftpActions").init(obj=f) />
		<cfset listaSklepow = fa.changeDirectory("sklepy").changeDirectory("in").listDirectory() />
		
		<cfset var licznikPlikow = 0 />
		<cfloop query="listaSklepow">
			<cfif listaSklepow.IsDirectory is "NO">
				<cfcontinue />
			</cfif>
			
			<cfset zawartoscKatalogu = fa.changeDirectory("/").changeDirectory("sklepy").changeDirectory("in").changeDirectory("#listaSklepow.name#").listDirectory() />
			
			<!---
				Pobieram tylko pliki ContributionReport
			--->
			<cfquery name="plikDoPobrania" dbtype="query" timeout="3600">
				select * from zawartoscKatalogu
				where NAME like 'AS_#listaSklepow.name#_ContributionReport%.xml'
			</cfquery>
			
			<cfloop query="plikDoPobrania">
				<cfset fa.getFile("#plikDoPobrania.name#", "ftp_mmarket").moveFile(fileName="#plikDoPobrania.name#", sourceDir="/sklepy/in/#listaSklepow.name#",destinationDir="/sklepy/arch/#listaSklepow.name#").moveFile(fileName="#plikDoPobrania.name#.flg", sourceDir="/sklepy/in/#listaSklepow.name#",destinationDir="/sklepy/arch/#listaSklepow.name#") />
				<cfset licznikPlikow++ />
			</cfloop>
			
		</cfloop>
		
		<cfset var stopTime = getTickCount()-startTime />
		
		<cfmail from="intranet@monkey.xyz" subject="Import raportów wpłat z FTP" to="admin@monkey.xyz" type="html" >
			<cfoutput>
				<h2>Import raportów wpłat z FTP</h2>
				Milisekundy: #stopTime# ms <br/>
				Sekundy: #stopTime/1000# <br />
				Ilość pobranych plików: #licznikPlikow#
			</cfoutput>
		</cfmail>
			
		<cfset renderNothing() />
		
	</cffunction>
	
	<cffunction name="importujRaportWplatDoBazy" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		
		<cfset var startTime = getTickCount() /> <!--- Zaczynam liczyć czas --->
		<cfset var licznikPlikow = 0 />
		
		<cfparam name="katalog" default="ftp_mmarket" />
		<cfdirectory action="list" directory="#expandPath( '#katalog#' )#" name="listaPlikow" filter="*.xml" />
		
		<cfloop query="listaPlikow">
			<cfif listaPlikow.size EQ 0>
				<cfcontinue />
			</cfif>
			
			<!--- Wersja pliku pobierana z jego nazwy --->
			<cfset var tmpName = ListToArray(listaPlikow.name, "_") />
			<cfset var nameVer = Left(tmpName[5], Len(tmpName[5])-4) />
			
			<!--- Otwieram plik --->
			<cfset var plik = fileRead(listaPlikow.directory & "/" & listaPlikow.name) />
			
			<!--- Dane raportu --->
			<cfset var report = xmlSearch(plik, "ContributionReport") />
			<cfset var xmlReport = xmlParse(report[1]) />
			
			<!--- Dane sprzedaży elektronicznej --->
			<cfset var electronic = xmlSearch(plik, "ContributionReport/ElectronicSales/ElectronicSale") />
			
			<cfset var nowyRaportSprzedazy = model("store_raport_wplat").dodaj(
				ver=nameVer, 
				fullLocationNumber=xmlReport.ContributionReport.FullLocationNumber.XmlText, 
				locationId=xmlReport.ContributionReport.LocationId.XmlText,
				contributionReportDate=xmlReport.ContributionReport.ContributionReportDate.XmlText,
				productsSaleAmount=xmlReport.ContributionReport.ProductsSaleAmount.XmlText,
				productsProductionAmount=xmlReport.ContributionReport.ProductsProductionAmount.XmlText,
				promoDiscountAmount=xmlReport.ContributionReport.PromoDiscountAmount.XmlText,
				electronicPaymentAmount=xmlReport.ContributionReport.ElectronicPaymentAmount.XmlText,
				paymentPercent=xmlReport.ContributionReport.PaymentPercent.XmlText,
				paymentAmount=xmlReport.ContributionReport.PaymentAmount.XmlText) />
			
			<cfloop array="#electronic#" index="e" >
				<cfset var xmlElectronic = xmlParse(e) />
				<cfset var nowaWplataElektroniczna = model("store_raport_wplat").dodajSprzedazElektroniczna(
					idRaportu=nowyRaportSprzedazy,
					idTypuSprzedazyElektronicznej=xmlElectronic.ElectronicSale.SaleTypeId.XmlText,
					saleAmount=xmlElectronic.ElectronicSale.SaleAmount.XmlText
				) />
			</cfloop>
			
			<cffile action="delete" file="#listaPlikow.directory#/#listaPlikow.name#" >
			<cfset licznikPlikow++ />
			
		</cfloop>
				
		<cfset var stopTime = getTickCount()-startTime /> <!--- Kończę liczyć czas --->
			
		<cfmail from="intranet@monkey.xyz" subject="Import raportu wpłat do bazy danych" to="admin@monkey.xyz" type="html" >
			<cfoutput>
				<h2>Import raportów wpłat do bazy danych</h2>
				Milisekundy: #stopTime# ms <br/>
				Sekundy: #stopTime/1000# <br />
				Ilość zaimportowanych plików: #licznikPlikow#
			</cfoutput> 
		</cfmail>
		<cfset renderNothing() />
	</cffunction>
	
	<!---
		BRANDBANK
	--->
	<cffunction name="brandbankProcessImages" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		<cfset img = model("brandbank").getImage(20) />
		
		<cfloop query="img">
			<cfscript>
				myImage=ImageRead(img.url);
				ImageWrite(myImage, "#expandPath('files/brandbank_images/#img.gtin#.#img.width#.#img.height#.png')#");
			</cfscript>
			
			<cfset imgImported = model("brandbank").imageImported(id) />
		</cfloop>
		
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="brandbankCoverageReport" output="false" access="public" hint="">
		<cfsetting requesttimeout="540" />
		
		<cfset var guidStr = "36FAD261-7363-4B86-94A3-CA95B686C33C" />
		<cfset var fileName = "#DateFormat(Now(), 'yyyy-mm-dd')#_#TimeFormat(Now(), 'HH-mm-ss')#" />
		<cfset var dane = createObject("component", "cfc.winapp").towaryWSieci() />

		<cfsavecontent variable="exportXml" >
			<cfoutput>
				<RetailerFeedbackReport xmlns="http://www.brandbank.com/schemas/CoverageFeedback/2005/11">
					<Message DateTime="#DateFormat(Now(), 'yyyy-mm-dd')#T#TimeFormat(Now(), 'HH:mm:ss')#.000" Domain="MAL" />
						
					<cfloop query="dane">
						
						<cfif Len(Trim(dane.NAZWA1)) EQ 0>
							<cfcontinue />
						</cfif>
						
						<Item HasLabelData="true" HasImage="true">
							<RetailerID>#dane.MG_KARID#</RetailerID>
							<Description>#REReplace(dane.OPIKAR, "&", " ", "all")#</Description>
							<GTINs>
								<GTIN Value="#Trim(dane.KODKRES)#">
									<Suppliers>
										<Supplier>
											<SupplierCode>#dane.SYMKAR#</SupplierCode>
											<SupplierName>#REReplace(dane.NAZWA1, "&", " ", "all")#</SupplierName>
										</Supplier>
									</Suppliers>
								</GTIN>
							</GTINs>
							<OwnLabel>false</OwnLabel>
							<Categories>
								<Category>#dane.KATEGORIA#</Category>
							</Categories>
						</Item>
					</cfloop>
						
				</RetailerFeedbackReport>
			</cfoutput>
		</cfsavecontent>
		
		<cffile action="write" file="#expandPath('files/brandbank/#fileName#.xml')#" output="#exportXml#" />
		<cfzip file = "#expandPath('files/brandbank/#fileName#.zip')#" 
			   source = "#expandPath('files/brandbank/#fileName#.xml')#" 
			   action = "zip" overwrite = "yes" />
		
		<cffile action="readbinary" file="#expandPath('files/brandbank/#fileName#.zip')#" variable="binaryZipFile" /> 
		
		<cfsavecontent variable="soapBody">
			<cfoutput>	
			<?xml version="1.0" encoding="utf-8"?>
			<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
						   xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
						   xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
				<soap:Header>
					<ExternalCallerHeader xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
						<ExternalCallerId>#guidStr#</ExternalCallerId>
					</ExternalCallerHeader>
				</soap:Header>
				<soap:Body>
					<SupplyCompressedCoverageReport xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
						<rawFileData>#toBase64(binaryZipFile, "utf-8")#</rawFileData>
					</SupplyCompressedCoverageReport>
				</soap:Body>
			</soap:Envelope>
			</cfoutput>
		</cfsavecontent>
		
		<cfhttp url="https://www.i-label.net/partners/webservices/datafeedbasic/reportdata.asmx?op=SupplyCompressedCoverageReport" 
				method="post" result="httpResponse" >

			<cfhttpparam type="header" name="SOAPAction" 
						 value="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11/SupplyCompressedCoverageReport" />
			<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
			<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
			<cfhttpparam type="xml" value="#trim( soapBody )#" />
 
		</cfhttp>

		<cfdump var="#httpResponse#" format="text" output="#expandPath('files/brandbank/#fileName#.txt')#" />
		
		<cfif find( "200", httpResponse.statusCode )>
			
			<cfset integrationStatus = structNew() />
			<cfset integrationStatus.success = true />
			<cfset integrationStatus.message = "Przesłałem raport Coverage Report." />
			<cfset integrationStatus.fileContent = httpResponse.Filecontent />
			
		<cfelse>
			
			<cfset integrationStatus = structNew() />
			<cfset integrationStatus.success = false />
			<cfset integrationStatus.message = "Nie mogłem przesłać raportu Coverage Report." />
			<cfset integrationStatus.fileContent = httpResponse.Filecontent />
			
		</cfif>
		
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="getUnsentProductData" output="false" access="public" hint="">
		<cfsetting requesttimeout="540" />
		<cfset var guidStr = "36FAD261-7363-4B86-94A3-CA95B686C33C" />
		
		<cfsavecontent variable="soapBody">
			<cfoutput>	
				<?xml version="1.0" encoding="utf-8"?>
				<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
							   xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
							   xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
					<soap:Header>
						<ExternalCallerHeader xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
							<ExternalCallerId>#guidStr#</ExternalCallerId>
						</ExternalCallerHeader>
					</soap:Header>
					<soap:Body>
						<GetUnsentProductData xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11" />
					</soap:Body>
				</soap:Envelope>
			</cfoutput>
		</cfsavecontent>
			
		<cfhttp url="https://www.i-label.net/partners/webservices/datafeedbasic/extractdata.asmx?op=GetUnsentProductData" 
				method="post" result="httpResponse" >
	
			<cfhttpparam type="header" name="SOAPAction" 
						 value="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11/GetUnsentProductData" />
			<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
			<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
			<cfhttpparam type="xml" value="#trim( soapBody )#" />
	 
		</cfhttp>
		
		<cfset response = structNew() />
		<cfset response.success = true />
		<cfset response.message = "Brakujące produkty zostały pobrane i są przetwarzane przez system" />
		
		<cfset var fileName = "#DateFormat(Now(), "yyyy-mm-dd")#_#TimeFormat(Now(), 'HH-mm-ss')#" />
		
		<cfif find("200", httpResponse.statusCode)>
			<cfset soapResponse = xmlParse( httpResponse.fileContent ) />
			<cffile action="write" file="#expandPath('files/brandbank_productdata/#fileName#.xml')#" output="#soapResponse#" />
			
			<cfset var requestDataFile = xmlParse(httpResponse.fileContent) />
			<cfset var requestDataFileResult = xmlSearch(requestDataFile,"//*[local-name()='Message']") />
			<cfset var requestDataFileMessageId = requestDataFileResult[1].XmlAttributes.id />
			
			<cfsavecontent variable="acknowledgment">
				<cfoutput>	
				<?xml version="1.0" encoding="utf-8"?>
					<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
						xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
						xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
						<soap:Header>
							<ExternalCallerHeader xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
								<ExternalCallerId>#guidStr#</ExternalCallerId>
							</ExternalCallerHeader>
						</soap:Header>
						<soap:Body>
							<AcknowledgeMessage xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
								<messageGuid>#requestDataFileMessageId#</messageGuid>
							</AcknowledgeMessage>
						</soap:Body>
					</soap:Envelope>
				</cfoutput>
			</cfsavecontent>
			
			<cfhttp url="https://www.i-label.net/partners/webservices/datafeedbasic/extractdata.asmx?op=AcknowledgeMessage" 
					method="post" result="httpAcknowledgment" >
		
				<cfhttpparam type="header" name="SOAPAction" 
							 value="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11/AcknowledgeMessage" />
				<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
				<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
				<cfhttpparam type="xml" value="#trim( acknowledgment )#" />
		 
			</cfhttp>
				
			<cfdump var="#httpAcknowledgment#" format="text" output="#expandPath('files/brandbank/#fileName#_acknowledgment.txt')#" />
		
		<cfelse>
				<cfset response.success = false />
				<cfset response.message = "Nie można wykonać zapytania :(" />
				<cfdump var="#httpResponse#" format="text" output="#expandPath('files/brandbank_errors/#fileName#_getUnsentProductData.txt')#" />
 		</cfif>
		
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="processingData" output="false" access="public" hint="">
		<cfsetting requesttimeout="540" />
		
		<cfset processingInformation = structNew() />
		<cfset processingInformation.success = true />
		<cfset processingInformation.message = "Zapisałem w bazie danych wszystkie informacje o produktach" />
		
		
		<cfset var katalogZDanymi = expandPath("files/brandbank_productdata") />
		<cfif directoryExists(katalogZDanymi)>
			<cfset var res = DirectoryList(katalogZDanymi, true, "query") />
			
			<cfloop query="res">
				<cfset objParser = CreateObject("component", "cfc.SubNodeXmlParser").Init(
					"Product",
					"#res.DIRECTORY#/#res.NAME#"
					)
				/>
				
				<cfset var soapResponse = xmlParse("#res.DIRECTORY#/#res.NAME#") />
				<cfset var results = xmlSearch(soapResponse,"//*[local-name()='Message']") />
				<cfset var messageId = results[1].XmlAttributes.id />
				
				<!---
					Tutaj zaczynam budować plik XML, który następnie wyślę do
					BrandBanku jako komunikat zwrotny.
				--->
				<cfset var feedbackRequest = "" />
				
				<cfset var i = 0 />
				<cfsavecontent variable="feedbackRequest" >
				<cfloop condition="true">
	 
					<!--- Get the next node. --->
					<cfset VARIABLES.Node = objParser.GetNextNode() />
					 
					<!---
					Check to see if the node was found. If not, then the
					variable, Node, will have been destroyed and will no
					longer exist in its parent scope.
					--->
					<cfif StructKeyExists( VARIABLES, "Node" )>
						
						<cfset var tmpIdentity = xmlSearch(Variables.Node["Identity"], "ProductCodes/Code") />
						<cfset var tmpDescription = xmlSearch(Variables.Node["Identity"], "DiagnosticDescription") />
						
						<!---
							Pobieram numer gtin (ean)
						--->
						<cfset var gtin = "" />
						<cfset var brandbankid = "" />
						<cfloop array="#tmpIdentity#" index="idn" >
							<cfif UCase(idn['XmlAttributes']['Scheme']) is 'GTIN'>
								<cfset gtin = idn['XmlText'] />
							</cfif>
								
							<cfif UCase(idn['XmlAttributes']['Scheme']) is 'BRANDBANK:PVID'>
								<cfset brandbankid = idn['XmlText'] />
							</cfif>
						</cfloop>
							
						<!---
							Pobieram opis produktu
						--->
						<cfset var desc = "" />
						<cfloop array="#tmpDescription#" index="ds" >
							<cfif UCase(ds['XmlAttributes']['Code']) is 'PL'
								and Len(ds['XmlText'] GT 0)>
								<cfset desc = ds['XmlText'] />
							</cfif>
						</cfloop>
						
						<!---
							Sprawdzam, czy istnieja grafiki.
						--->
						<cfif StructKeyExists(VARIABLES.Node, "Assets") and StructKeyExists(VARIABLES.Node['Assets'], "Image")>
							<cfset var tmpImage = xmlSearch(VARIABLES.Node["Assets"], "Image") />
							
							<cfset var bProduct = structNew() />
							<cfset bProduct.success = true />
							<cfset bProduct.message = "Dodałem produkt z BrandBanku" />
							<cfset bProduct.id = "" />
							
							<cfset bProduct = model("brandbank").createProduct(
								messageid = messageId,
								gtin = gtin,
								brandbankid = brandbankid,
								description = desc ) />
							
							<cfloop array="#tmpImage#" index="img" >
								<cfset var bImage = structNew() />
								<cfset bImage.success = true />
								<cfset bImage.message = "Dodałem zdjęcie z BrandBanku" />
								<cfset bImage.id = "" />
								
								<cfset bImage = model("brandbank").createImage(
									gtin = gtin,
									url = img.Url.XmlText,
									quality = img.Specification.Quality.XmlText,
									resolution = img.Specification.Resolution.XmlText,
									width = img.Specification.RequestedDimensions.Width.XmlText,
									height = img.Specification.RequestedDimensions.Height.XmlText) />
							</cfloop>
							
							<!---<cfsavecontent variable="feedbackRequest" >--->
								<cfoutput>
								<Item Status="Matched">
									<RetailerID />
									<MessageGUID>{#messageId#}</MessageGUID>
									<BrandbankID>#brandbankid#</BrandbankID>
									<Description>#Trim(desc)#</Description>
									<Comment />
								</Item>
								</cfoutput>
							<!---</cfsavecontent>--->
								
						
						<cfelse>

							<!---<cfsavecontent variable="feedbackRequest" >--->
								<cfoutput>
								<!---<Item Status="Not Sold">
									<RetailerID />
									<MessageGUID>{#messageId#}</MessageGUID>
									<BrandbankID>#brandbankid#</BrandbankID>
									<Description>#Trim(desc)#</Description>
									<Comment />
								</Item>--->
								</cfoutput>
							<!---</cfsavecontent>--->
	
						</cfif>
					 
					<cfelse>
					 
						<!--- We are done finding nodes so break out. --->
						<cfbreak />
					 
					</cfif>
					
				 	<cfset i++ />
				</cfloop>
				</cfsavecontent>
				
				<!---
					Po zasileniu bazy wysyłam Request do BrandBanku
					4) Product Processing Results
				--->
				<cfset var guidStr = "36FAD261-7363-4B86-94A3-CA95B686C33C" />
				<cfset var fileName = "#DateFormat(Now(), 'yyyy-mm-dd')#_#TimeFormat(Now(), 'HH-mm-ss')#" />
					
				<cfsavecontent variable="feedback" >
					<cfoutput>
						<RetailerProcessFeedback xmlns="http://www.brandbank.com/schemas/rpf/2005/11">
							<Message DateTime="#DateFormat(Now(), 'yyyy-mm-dd')#T#TimeFormat(Now(), 'HH:mm:ss')#.000" />
							#feedbackRequest#
						</RetailerProcessFeedback>
					</cfoutput>
				</cfsavecontent>
					
				<cffile action="write" file="#expandPath('files/brandbank/#fileName#_extraction_feedback.xml')#" output="#feedback#" />
					
				<cfzip file = "#expandPath('files/brandbank/#fileName#_extraction_feedback.zip')#" 
					   source = "#expandPath('files/brandbank/#fileName#_extraction_feedback.xml')#" 
					   action = "zip" overwrite = "yes" />
		
				<cffile action="readbinary" 
						file="#expandPath('files/brandbank/#fileName#_extraction_feedback.zip')#" 
						variable="binaryZipFile" /> 
		
				<cfsavecontent variable="soapBody">
					<cfoutput>
						<?xml version="1.0" encoding="utf-8"?>
						<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
							xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
							xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
							<soap:Header>
								<ExternalCallerHeader xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
									<ExternalCallerId>#guidStr#</ExternalCallerId>
								</ExternalCallerHeader>
							</soap:Header>
							<soap:Body>
								<SupplyCompressedExtractionFeedback xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
									<rawFileData>#toBase64(binaryZipFile, "utf-8")#</rawFileData>
								</SupplyCompressedExtractionFeedback>
							</soap:Body>
						</soap:Envelope>
					</cfoutput>
				</cfsavecontent>
		
				<cfhttp url="https://www.i-label.net/partners/webservices/datafeedbasic/reportdata.asmx?op=SupplyCompressedExtractionFeedback" 
					method="post" result="httpResponse" >

					<cfhttpparam type="header" name="SOAPAction" 
								 value="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11/SupplyCompressedExtractionFeedback" />
					<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
					<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
					<cfhttpparam type="xml" value="#trim( soapBody )#" />
 
				</cfhttp>

				<cfdump var="#httpResponse#" format="text" output="#expandPath('files/brandbank/#fileName#_extraction_feedback.txt')#" />
					
				<cffile action = "move" 
						destination = "#res.DIRECTORY#_bak/#res.NAME#" 
						source = "#res.DIRECTORY#/#res.NAME#" />
				
				<cfset processingInformation.success = true />
				<cfset processingInformation.message = "Zapisałem w bazie danych wszystkie informacje o produktach" />
				<cfset processingInformation.fileContent = httpResponse.fileContent />
		
			</cfloop>
		
		<cfelse>
			
			<cfset processingInformation.success = false />
			<cfset processingInformation.message = "Nie ma katalogu z plikami do pobrania" />
			 
		</cfif>
		
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="processingImages" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		<cfset img = model("brandbank").getImage(10) />
		
		<cfloop query="img">
			<cftry>
				<cfset imgImported = model("brandbank").imageImported(id, 2) />
				<cfscript>
					myImage=ImageRead(img.url);
					if (img.height eq 300 and img.width eq 300) {
						ImageWrite(myImage, "#expandPath('files/brandbank_images/#img.gtin#.png')#");
					} else {
						ImageWrite(myImage, "#expandPath('files/brandbank_images/#img.gtin#.#img.width#.#img.height#.png')#");
					}
				</cfscript>
				
				<cfset imgImported = model("brandbank").imageImported(id, 1) />
				
				<cfcatch type="any">
					<cfdump var="#CFCATCH#" format="text" output="#expandPath('files/brandbank_import_errors/#img.gtin#.#img.width#.#img.height#.txt')#" />
				</cfcatch>
			</cftry>
		</cfloop>
		
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="planogramyDoAsseco" output="false" access="public" hint="">
		
		<cfsetting requesttimeout="3600" />
		
		<cfset startTime = getTickCount() /> <!--- Zaczynam liczyć czas --->
		
		<cfset var a = createObject("component", "cfc.assecoConnector").init(
			assecoConnectorDsn = "assecoConnector",
			intranetDsn = "intranet",
			assecoDsn = "asseco") />
			
		<!--- Wysyłanie regałów --->
		<cfset var r = a.pobierzRegaly() />
		<cfset var i = a.wyslijRegaly(r) />
		
		<!--- Wysyłanie regałów na sklepie --->
		<cfset var s = a.pobierzSklepy() />
		<cfset var j = a.wyslijRegalyNaSklepach(s) />
		
		<!--- Wysyłanie towarów na regałach --->
		<cfset var p = a.pobierzPlanogramyZTu() />
		<cfset var p2r = a.wyslijProduktyNaRegalach(p) />
		
		<cfset stopTime = getTickCount()-startTime /> <!--- Kończę liczyć czas --->
		
		<cfmail 
			to="admin@monkey.xyz"
			from="INTRANET <intranet@monkey.xyz>"
			replyto="intranet@monkey.xyz"
			subject="Eksport planogramów do Asseco"
			type="html"> 
			
					
			<cfoutput>
				<h2>Eksport planogramów do Asseco</h2>
				Milisekundy: #stopTime# ms <br/>
				Sekundy: #stopTime/1000# <br />
			</cfoutput> 
			
		</cfmail>
					
		<cfset renderNothing() />
		
	</cffunction>
	
	<cffunction name="aktualizacjaSklepow" output="false" access="public" hint="">
		<cfsetting requestTimeout="3600" />
		<cfset var dodaneSklepy = "" />
		
		<cfset startTime = getTickCount() /> <!--- Zaczynam liczyć czas --->
	
		<cfset application.cfc.asseco.setDatasource(datasource="asseco") />
		<cfset stores = application.cfc.asseco.getStores() />
		
		<cfset var indeks = 1 />
		<cfloop query="stores">
			<cfif (Len(stores.dataobowiazywaniado) EQ 0 or DateCompare("#stores.dataobowiazywaniado#", "#DateFormat(Now(), 'yyyy-mm-dd')#") EQ 1) 
				and Len(stores.projekt) GT 0 
				and Len(stores.sklep) GT 0 
				and Len(stores.ajent) GT 0>
					
				<cfset var sklep = model("store_store").getStore(projekt = stores.projekt, sklep = stores.sklep, ajent = stores.ajent, dataod = stores.dataobowiazywaniaod) />
				
				<!---<cfdump var="#sklep#" label="sklep" />--->
				
				<!---<cfif stores.projekt IS "B14046">
				<cfdump var="#sklep#" />
				<cfdump var="#stores.projekt[indeks]#" label="projekt" />
					<cfdump var="#stores.sklep[indeks]#" label="sklep" />
					<cfdump var="#stores.ajent[indeks]#" label="ajent" />
					<cfdump var="|||||" />
					<cfabort />
				</cfif>--->
					
				<cfif sklep.RecordCount EQ 0>
					<cfset dodaneSklepy &= "#stores.projekt#, " />
					
					<!--- Dodanie nowego sklepu --->
					<!---
						1. Blokuje dostęp do poprzednich sklepów z tym loginem.
						2. Dodaje nowy sklep
						3. Dodaje nowego użytkownika
					--->
					
					<cfset var zablokowaneSklepy = model("store_store").zablokujSklepy(projekt=stores.projekt) />
					<cfset var podzielonyAdres = ListToArray(stores.adressklepu, ",") />
					<cfset var daneSklepu = {projekt = stores.projekt,
						sklep = "#NumberFormat(stores.sklep, "000009")#",
						ajent = "#NumberFormat(stores.ajent, "000009")#",
						email = stores.email,
						adressklepu = stores.adressklepu,
						telefon = Trim(stores.telefon),
						telefonkom = Trim(stores.telefonkom),
						m2_sale_hall = stores.m2_sale_hall,
						m2_all = stores.m2_all,
						longitude = stores.longitude,
						latitude = stores.latitude,
						loc_mall_name = stores.loc_mall_name,
						loc_mall_location = stores.loc_mall_location,
						nazwaajenta = stores.nazwaajenta,
						dataobowiazywaniaod = stores.dataobowiazywaniaod,
						dataobowiazywaniado = stores.dataobowiazywaniado,
						ulica = podzielonyAdres[1],
						miasto = podzielonyAdres[2],
						is_active = 1,
						kodsklepu = stores.kodpsklepu,
						grupasklepu = stores.grupasklepu,
						nip = stores.nip,
						regon = stores.regon,
						adresrejajenta = stores.adresrejajneta,
						adreskorajenta = stores.adreskorajneta,
						typeid = 1} />
				
					<cfset var nowySklep = model("store_store").dodajNowySklepIUzytkownika(daneSklepu) />
					<!---<cfset var kopiujRegaly = model("store_store").kopiujRegaly(projekt = stores.projekt, sklep = stores.sklep, ajent = stores.ajent) />--->
					
					
				<cfelse>
					<!--- Aktualizacja danych o sklepie --->
					
					<cfset var podzielonyAdres = ListToArray(stores.adressklepu) />
					<cfset var result = model("store_store").updateByKey(
						key = sklep.id, 
						sklep = "#NumberFormat(stores.sklep, "000009")#",
						adressklepu = stores.adressklepu, 
						ulica = podzielonyAdres[1],
						miasto = podzielonyAdres[2],
						loc_mall_name = stores.loc_mall_name,
						loc_mall_location = stores.loc_mall_location,
						ajent = stores.ajent,
						nazwaajenta = stores.nazwaajenta,
						dataobowiazywaniaod = stores.dataobowiazywaniaod,
						m2_sale_hall = stores.m2_sale_hall,
						m2_all = stores.m2_all,
						longitude = stores.longitude,
						latitude = stores.latitude,
						kodpsklepu = stores.kodpsklepu,
						grupasklepu = stores.grupasklepu,
						nip = stores.nip,
						regon = stores.regon,
						adresrejajenta = stores.adresrejajneta,
						adreskorajenta = stores.adreskorajneta) />
					
				</cfif>
				
				<cfset var storeUser = model("user").getUser(login = stores.projekt, logo = stores.ajent) />
				<cfif storeUser.RecordCount EQ 0>
					<cfset var daneUzytkownika = {projekt = stores.projekt,
						sklep = "#NumberFormat(stores.sklep, "000009")#",
						ajent = "#NumberFormat(stores.ajent, "000009")#",
						email = stores.email,
						adressklepu = stores.adressklepu,
						telefon = Trim(stores.telefon),
						telefonkom = Trim(stores.telefonkom),
						m2_sale_hall = stores.m2_sale_hall,
						m2_all = stores.m2_all,
						longitude = stores.longitude,
						latitude = stores.latitude,
						loc_mall_name = stores.loc_mall_name,
						loc_mall_location = stores.loc_mall_location,
						nazwaajenta = stores.nazwaajenta,
						dataobowiazywaniaod = stores.dataobowiazywaniaod,
						dataobowiazywaniado = stores.dataobowiazywaniado,
						ulica = podzielonyAdres[1],
						miasto = podzielonyAdres[2],
						is_active = 1,
						kodsklepu = stores.kodpsklepu,
						grupasklepu = stores.grupasklepu,
						nip = stores.nip,
						regon = stores.regon,
						adresrejajenta = stores.adresrejajneta,
						adreskorajenta = stores.adreskorajneta,
						typeid = 1} />
						
					<cfset var nowyUzytkownik = model("user").addUser(daneUzytkownika) />
					
				</cfif>
				
			</cfif>
			<cfset indeks++ />
		</cfloop>

		<cfset stopTime = getTickCount()-startTime /> <!--- Kończę liczyć czas --->
		
		<cfmail 
			to="admin@monkey.xyz,merchandising@monkey.xyz"
			from="INTRANET <intranet@monkey.xyz>"
			replyto="intranet@monkey.xyz"
			subject="Import sklepów z Asseco"
			type="html"> 
					
			<cfoutput>
				<h2>Import sklepów</h2>
				Milisekundy: #stopTime# ms <br/>
				Sekundy: #stopTime/1000# <br />
				Dodane sklepy: #dodaneSklepy# <br />
			</cfoutput> 
			
		</cfmail>

		<cfset renderNothing() />
		
	</cffunction>
	
	<cffunction name="przygotujTabelePokryciaSklepow" output="false" access="public" hint="">
		
		<cfset startTime = getTickCount() /> <!--- Zaczynam liczyć czas --->

		<cfset var pokrycie = model("store_store").przygotowanieTabelPokryciaProduktow() />
		
		<cfset stopTime = getTickCount()-startTime /> <!--- Kończę liczyć czas --->
		
		<cfmail 
			to="admin@monkey.xyz"
			from="INTRANET <intranet@monkey.xyz>"
			replyto="intranet@monkey.xyz"
			subject="Budowanie tabel pokrycia sklepów"
			type="html"> 
					
			<cfoutput>
				<h2>Budowanie tabel pokrycia sklepów</h2>
				Milisekundy: #stopTime# ms <br/>
				Sekundy: #stopTime/1000# <br />
			</cfoutput> 
			
		</cfmail>
		
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="importujAFaktury" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		
		<cfset var a = createObject("component", "cfc.afaktury").init(pathIn = "/in", pathArch = "/arch", host="10.99.40.1", login="faktury_root", password="faktury_root", localPathIn="/var/www/intranet/afaktury", dsn="intranet", dsnAbs="asseco") />
		
		<cfset a.importDoIntranetu() />
		
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="usunAFaktury" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		
		<cfset a = createObject("component", "cfc.afaktury").init(dsn="intranet") />
		<cfset fakturyDoUsuniecia = a.listaDoUsuniecia() />
		
		<cfset licznik = 1 />
		
		<cfthread action="run" name="usunAfakture#licznik#" priority="HIGH" >
			
			<cfloop query="fakturyDoUsuniecia">
				<cfset dokumentId = fakturyDoUsuniecia.ID />
				
				<cftry>
					
					<!---<cfif licznik eq 1>--->
						<cfset var result = a.usunDokument(dokument=dokumentId, uzytkownik='0') />
					<!---</cfif>--->
					
					<cfcatch type="any">
						<cfmail to="admin@monkey.xyz" from="INTRANET <intranet@monkey.xyz>" replyto="intranet@monkey.xyz" type="html" subject="Błąd usunięcia faktur afaktury.pl">
							<cfoutput>
								<h1>Wystąpił błąd przy usunięciu afaktury.pl</h1>
								<cfdump var="#cfcatch#" />
							</cfoutput>
						</cfmail>
					</cfcatch>
					
				</cftry>
				<cfset licznik++ />
			</cfloop>
			
		</cfthread>
		
		
		<cfmail to="admin@monkey.xyz" from="INTRANET <intranet@monkey.xyz>" replyto="intranet@monkey.xyz" type="html" subject="Raport usunięcie afaktury.pl">
			<cfoutput>
				<h1>Raport usunięcia afaktury.pl</h1>
				<table>
					<thead>
						<tr>
							<th>ID</th>
							<th>Numer dokumentu</th>
							<th>Data importu</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="fakturyDoUsuniecia">
							<tr>
								<td>#id#</td>
								<td>#documentname#</td>
								<td>#DateFormat(documentcreated, "yyyy/mm/dd")#</td>
							</tr>
						</cfloop>
					</tbody>
					<tfoot>
						<tr>
							<th colspan="2">Ilość dokumentów</th>
							<td>#fakturyDoUsuniecia.recordCount#</td>
						</tr>
					</tfoot>
				</table>
			</cfoutput>
		</cfmail>
		
		<cfset renderNothing() />
	</cffunction>
	
	<!---
	
	<cffunction name="przygotujRaportPokrycia" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />

		<cfset var sklepy = model("store_store").pobierzListeSklepow() />
		<cfset var kolumny = model("store_store").indeksyNaSklepie(defKolumn=true) />

		<cfset var local = {} />
		<cfset local.ColumnNames = ['product_id', 'upc', 'sklep', 'prestock', 'ilosc_sku_na_sklepie'] />
		<cfset local.ColumnCount = arrayLen(local.ColumnNames) />
		<cfset local.Buffer = createObject( "java", "java.lang.StringBuffer" ).init() />
		<cfset local.NewLine = ( Chr(13) & Chr(10) ) />
		
		<!---
		<cfloop index="local.ColumnName" list="#kolumny.ColumnList#" delimiters=",">
			<cfset arrayAppend(local.ColumnNames, Trim(local.ColumnName)) />
		</cfloop>
	
		<cfset local.ColumnCount = arrayLen(local.ColumnNames) />
		<cfset local.Buffer = createObject( "java", "java.lang.StringBuffer" ).init() />
		<cfset local.NewLine = ( Chr(13) & Chr(10) ) />
			
		<cfset local.RowData = [] />
		<cfloop index="local.ColumnName" from="1" to="#local.ColumnCount#" step="1">
			<cfset local.RowData[local.ColumnName] = """#local.ColumnNames[local.ColumnName]#""" /> 
		</cfloop>
	
		<cfset local.Buffer.Append( JavaCast( "string", arrayToList( local.RowData, "," ) & local.NewLine ) ) />
		
		<cfset fName = "files/raport_pokrycia_produktow/RaportPokryciaSieci[#DateFormat(Now(), "yyyy-mm-dd")#].csv" />
		<cfset fSrc = expandPath( fName ) />
		
		<cfif not fileExists( fSrc )>
			<cfset fileWrite( fSrc, "" ) />
		</cfif>
		--->
		
		<cfset fName = "files/raport_pokrycia_produktow/RaportPokryciaSieci[#DateFormat(Now(), "yyyy-mm-dd")#].csv" />
		<cfset fSrc = expandPath( fName ) />
		
		<cfif not fileExists( fSrc )>
			<cfset fileWrite( fSrc, "" ) />
		</cfif>
		<cfset fileObj = FileOpen( fSrc, "append" ) />
		
		<!---
		<cfset FileWrite( fileObj, local.Buffer.toString() ) />
		<cfset local.Buffer.setLength(0) />
		--->
		
		<cfloop query="sklepy">
			<cfset var raportPokrycia = model("store_store").indeksyNaSklepie(sklep=sklepy.projekt) />
			
			<cfloop query="raportPokrycia"> 
				<cfset local.RowData = [] />
		
				<cfloop index="local.ColumnIndex" from="1" to="#local.ColumnCount#" step="1">
					<cfset local.RowData[local.ColumnIndex] = """#Replace( raportPokrycia[ local.ColumnNames[ local.ColumnIndex ] ][ raportPokrycia.CurrentRow ], """", """""", "all" )#""" />
				</cfloop>
		
				<cfset local.Buffer.Append( JavaCast( "string", arrayToList( local.RowData, "," ) & local.NewLine ) ) />
		
			</cfloop>
			
			<cfset FileWrite( fileObj, local.Buffer.toString() ) />
			<cfset local.Buffer.setLength(0) />
			
			<!---
			<cfset fName = "files/raport_pokrycia_tmp/#sklepy.projekt#[#DateFormat(Now(), "yyyy-mm-dd")#].csv" />
			<cfset fSrc = expandPath(fName) />
			<cfset fileWrite(fSrc, local.Buffer.toString()) />
			--->
	
		</cfloop>
		
		<cfset fileClose( fileObj ) />
			
		<cfzip action="zip" file="#fSrc#.zip" overwrite="yes" >
			<cfzipparam source="#fSrc#" />
		</cfzip>
		
		<cfset fileDelete( fSrc ) />
		
		<!---
		<cfset fName = "files/raport_pokrycia_produktow/RaportPokryciaSieci[#DateFormat(Now(), "yyyy-mm-dd")#].csv" />
		<cfset fSrc = expandPath(fName) />
		<cfset fileWrite(fSrc, local.Buffer.toString()) />
		--->
		
		<cfset renderNothing() />
	</cffunction>
	--->
	
	<cffunction name="przygotujRaportPrestockSieci" output="false" access="public" hint="">
		<cfset indeksy = model("store_store").pobierzIndeksyZPlanogramow() />
	</cffunction>
	
	<!---
	<cffunction name="pakujRaportPokrycia" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		<cfdirectory action="list" directory="#expandPath( "files/raport_pokrycia_produktow/" )#" name="raportySieci" filter="*.csv" type="all" />
		
		<cfloop query="raportySieci">
			
			<cfzip action="zip" file="#raportySieci.directory#/#raportySieci.name#.zip" overwrite="yes">
				<cfzipparam source="#raportySieci.directory#/#raportySieci.name#" />
			</cfzip>
			
			<cffile action="delete" file="#raportySieci.directory#/#raportySieci.name#" />
			
		</cfloop>
		
		<cfset renderNothing() />
	</cffunction>
	--->
	
	<!---<cffunction name="sendStockEmails">
		
		
	</cffunction>--->
	
	<cffunction name="sendEmails" output="false" access="public" hint="">
	
		<cfset emails = model("Email").findAllEmails() />
		
		<cfloop query="emails">
			
			<cfset attachments = model("Email").findAllEmailAttachments(emailid=emails.id) />
			
			<cfif emails.template eq ''>
				
				<cfinclude template="../views/emails/default.cfm" />
				
			<cfelse>
				
				<cfinclude template="../views/emails/#emails.template#.cfm" />
				
			</cfif>
			
			<cfset email = model("Email").findByKey(emails.id).update(senddate=Now()) />
		</cfloop>
		
		<!---<cfset variable = emails />
		<cfset renderWith(data="variable",template="/dump",layout=false) />--->
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="importujProjektySklepow" output="false" access="public" hint="">
		
		<cfset application.cfc.asseco.setDatasource(datasource="asseco") />
		<cfset stores = application.cfc.asseco.pobierzProjekt("1\PROJ\B1%") />
		
		<cfset result = ArrayNew(1) />
		
		<cfloop query="stores">
			
			<cfset _miejsce = ListToArray(stores.miejscerealizacji, ",") />
			<cfset ArrayAppend(result, _miejsce) />
			<cfset _postcode = Trim(Right(_miejsce[1],6)) />
			<cfset _adress = Trim(Left(_miejsce[1], Len(_miejsce[1])-6)) />
			
			<cfset locations = model("Course_location").findOne(where="projekt='#stores.projekt#'") />
			
			<cfif IsObject(locations)>
				<cfset locations.update(adress=_adress, city=Trim(_miejsce[2]), postcode=_postcode) />
				<cfset locations.save() />
			<cfelse>
				<cfset loc = model("Course_location").create(projekt=stores.projekt, adress=_adress, city=Trim(_miejsce[2]), postcode=_postcode) />
			</cfif>
			
		</cfloop>
		
		<cfset variable = stores />
		<cfset renderWith(data="variable",template="/dump",layout=false) />
		
	</cffunction>
	
	<cffunction name="akceptujZaksiegowaneFaktury" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		
		<cfset startTime = getTickCount() /> <!--- Zaczynam liczyć czas --->
			
		<cfset var zaksiegowaneFv = queryNew("documentname") />
		<cfset var niezaksiegowaneFv = queryNew("documentname") />
		
		<cfset var fv = model("workflow").pobierzFakturyNaEtapieKsiegowosci() />
		<cftry>
		<cfloop query="fv">
			
			<!--- Uruchamiam procedur pobierającą linijki dowodu --->
			<cfset var linijki = model("workflow").pobierzMpkProjektZAbs(numerDok = numer_faktury, nrZew = numer_faktury_zewnetrzny, IDDokumentu = documentid, IDObiegu = workflowid, netto = replaceNoCase(netto, ',', '.', 'ALL'), brutto = replaceNoCase(brutto, ',', '.', 'ALL')) />
			<cfset var linijkiIntranet = model("workflow").pobierzMpkProjektZIntranetu(numerDok = numer_faktury, nrZew = numer_faktury_zewnetrzny, IDDokumentu = documentid, IDObiegu = workflowid, netto = replaceNoCase(netto, ',', '.', 'ALL'), brutto = replaceNoCase(brutto, ',', '.', 'ALL')) />
			
			
			<!--- Jeżeli mpki i projekty w abs zgadzają si z tymi w intranecie to ksiguje --->
			<cfif linijki.recordCount neq 0 and linijkiIntranet.recordCount neq 0 and ReplaceNoCase(serializeJSON(linijki), " ", "", "ALL") eq ReplaceNoCase(serializeJSON(linijkiIntranet), " ", "", "ALL")>
				<cfset var ksiegowanie = model("workflow").zaksiegujDokumentWIntranecie(numer_faktury) />
				<cfif ksiegowanie.success is true>
					<cfset queryAddRow(zaksiegowaneFv, 1) />
					<cfset querySetCell(zaksiegowaneFv, "documentname", numer_faktury) />
				<cfelse>
					<cfset queryAddRow(niezaksiegowaneFv, 1) />
					<cfset querySetCell(niezaksiegowaneFv, "documentname", numer_faktury) />
				</cfif>
			<cfelse>
				<cfset queryAddRow(niezaksiegowaneFv, 1) />
				<cfset querySetCell(niezaksiegowaneFv, "documentname", numer_faktury) />
			</cfif>
			
		</cfloop>

		<cfcatch type="any">
			<cfmail from="intranet" subject="błąd ksigowania automatycznego" to="admin@monkey.xyz" type="html" >
				<cfdump var="#cfcatch#" />
			</cfmail>
		</cfcatch>

		</cftry>
		
		<cfset stopTime = getTickCount()-startTime /> <!--- Kończę liczyć czas --->
		
		<cfsavecontent variable="wiadomoscEmail">
			<h3>Zaksiegowane faktury</h3>
			<table>
				<thead>
					<tr>
						<th>Numer dokumentu</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="zaksiegowaneFv">
						<tr>
							<td><cfoutput>#documentname#</cfoutput></td>
						</tr>
					</cfloop>
				</tbody>
				<tfoot>
					<tr>
						<td>Ilość zaksiegowanych faktur: <cfoutput>#zaksiegowaneFv.recordCount#</cfoutput></td>
					</tr>
				</tfoot>
			</table>
				
			<h3>Niezaksiegowane faktury</h3>
			<table>
				<thead>
					<tr>
						<th>Numer dokumentu</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="niezaksiegowaneFv">
						<tr>
							<td><cfoutput>#documentname#</cfoutput></td>
						</tr>
					</cfloop>
				</tbody>
				<tfoot>
					<tr>
						<td>Ilość niezaksiegowanych faktur: <cfoutput>#niezaksiegowaneFv.recordCount#</cfoutput></td>
					</tr>
				</tfoot>
			</table>
			
		</cfsavecontent>
			
		<cfmail to="oszmim@monkey.xyz" cc="intranet@monkey.xyz" from="intranet@monkey.xyz" subject="Automatyczne ksiegowanie" type="html">
			<cfoutput>
				<h2>Automatyczne ksigowanie faktur</h2>
				Milisekundy: #stopTime# <br/>
				Sekundy: #stopTime/1000# <br />
				Minuty: #stopTime/1000/60# <br />
			</cfoutput>
			<br /><br />
			#wiadomoscEmail#
		</cfmail>
		
		<cfset renderNothing() />
	</cffunction>
</cfcomponent>
