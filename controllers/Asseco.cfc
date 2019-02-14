<cfcomponent displayname="Asseco" extends="Controller">

	<cffunction name="init">
 		<cfset super.init() />	 
		<cfset provides("json,html")>
		<cfset filters(through="loadJS",type="before",only="ListaMpkProjekt") />
		<cfset filters(through="loadLayout",type="before") />
	</cffunction>
	
	<cffunction name="loadJS"> 
		<cfset APPLICATION.ajaxImportFiles &= ",assecoInit" />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="" >
		<cfset usesLayout(template="/layout") />
	</cffunction>

	<!--- getContractors --->
	<!--- Metoda zwracająca listę kontrahentów. --->
	<cffunction
		name="getContractors"
		displayname="getContractors"
		hint="Zwracanie kontrahentów z bazy Asseco"
		description="Metoda zwracająca listę kontrahentów z bazy Asseco w formacie JSON">

		<cfif IsDefined("FORM.LOGO")>
			<cfset json = model("Contractor").getContractors(logo="#params.logo#") />
		<cfelse>
			<cfset json = model("Contractor").getContractors(search="#params.searchvalue#") />
		</cfif>
		
		<cfset renderWith(data="json",hideDebugInformation=true,template="json",layout=false) />

	</cffunction>
	
	<cffunction name="pobierzKontrahentaZIntranetu" output="false" access="public" hint="">
		<cfset json = "" />
		<cfif IsDefined("FORM.searchvalue")>
			<cfset json = model("contractor").kontrachentZIntranetu(FORM.searchvalue) />
			<cfset json = QueryToStruct(Query=json) />
		</cfif>
		
		<cfif IsDefined("URL.searchvalue")>
			<cfset json = model("contractor").kontrachentZIntranetu(URL.searchvalue) />
			<cfset json = QueryToStruct(Query=json) />
		</cfif>
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction name="pobierzKontrahenta" output="false" access="public" hint="">
		<cfset json = "" />
		<cfset var abs = createObject("component", "cfc.models.AssecoGateway").init(get('loc').datasource.asseco) />
		<cfif IsDefined("FORM.searchvalue")>
			
			<cfset json = abs.szukajKontrahenta(text = FORM.SEARCHVALUE) />
			<cfset json = QueryToStruct(Query=json) />
		</cfif>
		
		<cfif IsDefined("URL.searchvalue")>
			<cfset json = abs.szukajKontrahenta(text = URL.SEARCHVALUE) />
			<cfset json = QueryToStruct(Query=json) />
		</cfif>
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>

	<!--- getMpks --->
	<!--- Metoda zwracająca listę mpków. --->
	<cffunction
		name="getMpks"
		displayname="getMpks"
		hint="Zwracanie listy MPK"
		description="Metoda zwracająca listę MPKów z Asseco">

		<cfset mpks = model("mpk").getMpks() />
		<cfset renderWith(data=mpks,hideDebugInformation=true,layout=false) />

	</cffunction>

	<!--- getMpks --->
	<!--- Metoda zwracająca listę mpków. --->
	<cffunction
		name="getProjects"
		displayname="getProjects"
		hint="Zwracanie listy projektów"
		description="Metoda zwracająca listę projektów z Asseco">

		<cfset projects = model("project").getProjects() />
		<cfset renderWith(data=projects,hideDebugInformation=true,layout=false) />

	</cffunction>

	<!--- getIndexes --->
	<!--- Pobieranie indeksów z bazy Asseco --->
	<cffunction
		name="getIndexes"
		displayname="getIndexes"
		hint="Pobranie listy indeksów"
		description="Metoda pobierająca listę 10 indeksów pasujących do wzorca">

		<cfset indexes = model("index").getIndexesDetails(search = "#params.search#") />
		<cfset renderWith(data=indexes,hideDebugInformation=true,layout=false) />

	</cffunction>
	
	<cffunction
		name="getIndexesDetails"
		displayname="getIndexesDetails"
		hint="Pobranie listy indeksów"
		description="Metoda pobierająca listę 10 indeksów pasujących do wzorca">

		<cfset json = model("index").getIndexesDetails(search = "#params.search#") />
		<cfset json = QueryToStruct(Query=json) />
		<cfset renderWith(data=json,layout=false, template="/json") />

	</cffunction>
	
	<cffunction
		name="getAllIndexesDetails"
		displayname="getAllIndexesDetails"
		hint="Pobranie listy indeksów"
		description="Metoda pobierająca listę 10 indeksów pasujących do wzorca">

		<cfset json = model("index").getAllIndexesDetails(search = "#params.search#") />
		<cfset json = QueryToStruct(Query=json) />
		<cfset renderWith(data=json,layout=false, template="/json") />

	</cffunction>

	<!--- getDecreeNote --->
	<!--- Pobieranie linijek dowodu --->
	<cffunction
		name="getDecreeNote"
		hint="Pobieranie notki dekretacyjnej z Asseco"
		description="Pobieranie notki dekretacyjnej z Asseco. Jeśli nie ma rekordów wyświetlany jestk stosowny komunikat. Jeśli są rekordy generuję plik PDF z notką dekretacyjną">

		<cfset decree = model("workflow").getNote(company_code="",karta_korespondencji="#params.key#") />
		<cfset kartakorespondencji = params.key />
		<cfset workflowsearch = model("viewWorkflowSearch").findAll(where="numer_faktury='#params.key#'") />
		<cfset renderWith(data="decree,kartakorespondencji,workflowsearch",layout=false) />

	</cffunction>

	<cffunction
		name="getPartners"
		hint="Pobranie partnerów z bazy Asseco">

		<cfset APPLICATION.cfc.asseco.setDatasource(datasource="asseco") />
		<cfset partners = APPLICATION.cfc.asseco.getPartners() />
		
		<!---<cfdump var="#partners#" />
		<cfabort />--->
		
		<!--- Sprawdzam, czy istnieje partner o podanym LOGO --->
		<cfloop query="partners">

			<!--- Sprawdzam, czy istnieje wpis w tabeli z partnerami --->
			<cfset mypartner = model("partner").count(where="logo='#logo#' AND is_active = 1 AND nip='#nip#'") />
			<!---<cfset mypartner = model("partner").findOne(where="logo='#logo#'") />--->

			<cfif mypartner EQ 0>
				<!---<cfdump var="#partners['nazwa2'][partners.currentRow]#" label="użytkownik"/>
				<cfabort />--->
				<!---<cfset mynewpartner = model("partner").New() />
				<cfset mynewpartner.datapozyskania = datapozyskania />
				<cfset mynewpartner.email = email />
				<cfset mynewpartner.fax = fax />
				<cfset mynewpartner.gps_coordinates = gps_coordinates />
				<cfset mynewpartner.kodpocztowy = kodpocztowy />
				<cfset mynewpartner.logo = logo />
				<cfset mynewpartner.miejscowosc = miejscowosc />
				<cfset mynewpaerner.nazwa1 = nazwa1 />
				<cfset mynewpartner.nazwa2 = nazwa2 />
				<cfset mynewpartner.nip = nip />
				<cfset mynewpartner.nrdomu = nrdomu />
				<cfset mynewpartner.nrlokali = nrlokalu />
				<cfset mynewpartner.rolakontrahenta = rolakontrahenta />
				<cfset mynewpartner.statuskli = statuskli />
				<cfset mynewpartner.telefon = telefon />
				<cfset mynewpartner.telefonkom = telefonkom />
				<cfset mynewpartner.ulica = ulica />
				<cfset mynewpartner.save(callbacks=false) />--->

			</cfif>

			<cfset myuser = model("user").findOne(where="logo='#logo#' AND login='#Trim(EMail)#' AND active=1") />

			<cfif not IsStruct(myuser) and Len(partners.EMail) and partners.logo EQ '002774'>

					<!---<cfdump var="#partners['nazwa2'][partners.currentRow]#" label="użytkownik"/>--->
					<!---<cfabort />--->
		
					<!--- Generowanie losowego hasła --->
					<cfset randompassword = randomText(length=8) />

					<cfset newuser = model("user").New() />
					<cfset newuser.created_date = Now() />
					<cfset newuser.active = 1 />
					<cfset newuser.login = email />
					<cfset newuser.password = Encrypt(randompassword, get('loc').intranet.securitysalt) />
					<cfset newuser.givenname = nazwa1 />
					<cfset newuser.mail = email />
					<cfset newuser.smsauth = 1 />
					<cfset newuser.logo = logo />
					<cfset newuser.save(callbacks=false) />

					<cfset mail = model("email").partnerNotification(user=newuser) />

			</cfif>

		</cfloop>

	</cffunction>

	<cffunction name="getStores" hint="Pobranie listy sklepów z Asseco i zaimportowanie ich do Intranetu">

		<cfsetting requestTimeout="3600" />
	
		<cfset application.cfc.asseco.setDatasource(datasource="asseco") />
		<cfset stores = application.cfc.asseco.getStores() />
		
		<!---<cfdump var="#stores#" />
		<cfabort />--->
		
		<cfset var indeks = 1 />
		<cfloop query="stores">
			<cfif Len(stores.projekt) GT 0 and Len(stores.sklep) GT 0 and Len(stores.ajent) GT 0>
				<cfset var sklep = model("store_store").getStore(projekt = stores.projekt, sklep = stores.sklep, ajent = stores.ajent) />
				<!---<cfif stores.projekt IS "B14046">
				<cfdump var="#sklep#" />
				<cfdump var="#stores.projekt[indeks]#" label="projekt" />
					<cfdump var="#stores.sklep[indeks]#" label="sklep" />
					<cfdump var="#stores.ajent[indeks]#" label="ajent" />
					<cfdump var="|||||" />
					<cfabort />
				</cfif>--->
					
				<cfif sklep.RecordCount EQ 0>
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

		<cfabort />

		<cfset redirectTo(controller="store_stores",action="index",success="Sklepy zostały pomyślnie dodane do Intranetu.") />

	</cffunction>
	
	<cffunction
		name="widgetPotwierdzenieSalda"
		hint="Widget prezentujący tabelkę z potwierdzeniem salda dla Ajenta">
				
		<!---
			Jeżeli dane są przesłane to pobieram wzystkie dane.
		--->
		<cfset daneFirmy = APPLICATION.cfc.asseco.potwierdzenieSaldaDaneFirmy() />
		<cfset daneKontrahenta = APPLICATION.cfc.asseco.potwierdzenieSaldaDaneKontrahenta(
				logo = session.user.logo,
				projekt = session.user.login
				<!---projekt = 'C12044',
				logo = '001398'--->
			) />
			
		<cfset saldo = APPLICATION.cfc.asseco.potwierdzenieSalda(
				naDzien = DateFormat(Now(), "yyyymmdd"),
				<!---projekt = 'C12044',
				logo = '001398'--->
				logo = session.user.logo,
				projekt = session.user.login
			) /> 
				
		<cfset renderWith(data="daneFirmy,daneKontrahenta,saldo",layout=false) />

	</cffunction>
	
	<cffunction name="eksportPotwierdzenieSalda" output="false" access="public" hint="" >
	
		<cfset saldo = APPLICATION.cfc.asseco.potwierdzenieSalda(
			naDzien = DateFormat(Now(), "yyyymmdd"),
			<!---projekt = 'C12044',
			logo = '001398'--->
			logo = session.user.logo,
			projekt = session.user.login
		) /> 
	
		<cfswitch expression="#params.typ#">
			<!--- eksport do Excela --->
			<cfcase value="xls" >
				
				<!--- Generowanie pliku excela --->
				<cfsavecontent variable="strXmlData">
					<cfoutput>
					<!---
						Define this document as both an XML doucment and a
						Microsoft Excel document.
					--->
					<?xml version="1.0"?>
					<?mso-application progid="Excel.Sheet"?>
					
					<!---
						This is the Workbook root element. This element
						stores characteristics and properties of the
						workbook, such as the namespaces used in
						SpreadsheetML.
					--->
					<Workbook
						xmlns="urn:schemas-microsoft-com:office:spreadsheet"
						xmlns:o="urn:schemas-microsoft-com:office:office"
						xmlns:x="urn:schemas-microsoft-com:office:excel"
						xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
						xmlns:html="http://www.w3.org/TR/REC-html40">
						
						<DocumentProperties
							xmlns="urn:schemas-microsoft-com:office:office">
							<Author>TD</Author>
							<Company>Monkey Group</Company>
						</DocumentProperties>
						
						<Styles>
 
							<!--- Basic format used by all cells. --->
							<Style ss:ID="Default" ss:Name="Normal">
								<Alignment ss:Vertical="Top"/>
								<Borders/>
								<Font/>
								<Interior/>
								<NumberFormat/>
								<Protection/>
							</Style>
 
							<!---
								This is the movie rating style. We are going to
								format the number so that it goes to one
								decimal place.
							--->
							<Style ss:ID="Rating">
								<NumberFormat ss:Format="0.00" />
							</Style>
 
							<!---
								This is the date of the movie viewing. It is
								going to be a short date in the format of
								d-mmm-yyyy (ex. 15-Mar-2007).
							--->
							<Style ss:ID="ShortDate">
								<NumberFormat ss:Format="[ENG][$-409]d\-mmm\-yyyy;@" />
							</Style>

						</Styles>
						
						<Worksheet ss:Name="Obieg dokumentów">
							<Table
								ss:ExpandedColumnCount="#ListLen( saldo.ColumnList )#"
								ss:ExpandedRowCount="#(saldo.RecordCount + 1)#"
								x:FullColumns="1"
								x:FullRows="1">
									
								<Row>
									<Cell>
										<Data ss:Type="String">Lp</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">Nasze</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">Wasze</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">Data</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">Numer faktury</Data>
									</Cell>
								</Row>
								
								<cfset lp = 1 />
								<cfloop query="saldo">
									<Row>
										<Cell>
											<Data ss:Type="String">#lp#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="String">#nasza_kwota#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="String">#wasza_kwota#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="String">#DateFormat(dstart, 'dd-mm-yyyy')#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="String">#symroz#</Data>
										</Cell>
									</Row>
									<cfset lp = lp + 1 />
								</cfloop>

							</Table>
						</Worksheet>
						
					</Workbook>
					</cfoutput>
				</cfsavecontent>
				
				<!---
					Define the way in which the browser should interpret
					the content that we are about to stream.
				--->
				<cfheader
					name="content-disposition"
					value="attachment; filename=Zestawienie_naleznosci_#DateFormat(Now(), 'dd_mm_yyyy')#.xls" />
 
				<!---
					When streaming the Excel XML data, trim the data and
					replace all the inter-tag white space. No need to stream
					any more content than we have to.
				--->
				<cfcontent
					type="application/msexcel"
					variable="#ToBinary( ToBase64( strXmlData.Trim().ReplaceAll( '>\s+', '>' ).ReplaceAll( '\s+<', '<' ) ) )#" />
			</cfcase>
			
			<!--- eksport do pliku pdf --->
			<cfcase value="pdf" >
				
			</cfcase>
		</cfswitch>
	
		<cfset renderNothing() />
	
	</cffunction>
	
	<!---
		5.07.2013
		Generowanie tabelek z listą MPKów i Projektów do wglądu przez 
		uzytkownika. Widoki pozwalają na filtrowanie wyników.
	--->
	<cffunction
		name="ListaMpkProjekt"
		hint="Widok z listą MPKów i Projektów">
		
	</cffunction>
	
	<cffunction
		name="pobierzMpk"
		hint="Pobieranie mpków w formacie json">
		
		<cfset json = APPLICATION.cfc.asseco.init(datasource="asseco").pobierzMpk(search = params.search) />
		<cfset json = QueryToStruct(Query=json) />
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
	<cffunction
		name="pobierzProjekt"
		hint="Pobranie projektów w formacie json">
		
		<cfset json = APPLICATION.cfc.asseco.init(datasource="asseco").pobierzProjekt(search = params.search) />
		<cfset json = QueryToStruct(Query=json) />
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
	<cffunction name="listaEan" output="false" access="public" hint="Lista indeksów z kodami EAN dla DKiN">
		<cfif IsDefined("params.wyszukiwarkaean")>
			<cfset json = model("index").getIndexesDetails(params.wyszukiwarkaean) />
			<cfset json = QueryToStruct(Query=json) />
			<cfset renderWith(data="json",template="/json",layout=false) />
		</cfif>
	</cffunction>
	
	<!---
		Przygotowanie pliku XML dla Asseco
	--->
	<cffunction name="xmlSklepy" output="false" access="public" hint="">
		<cfset var sklepy = model("asseco").sklepy(projekt="B13045") />
		<cfsavecontent variable="xml" >
			<cfoutput>
				<?xml version="1.0"?>
				<monkeygroup data="#DateFormat(Now(), 'yyyy-mm-dd')# #TimeFormat(Now(), 'HH:mm:ss')#">
				<cfloop query="sklepy">
					<SklepDef>
						<Logo>#sklep#</Logo>
						<Projekt>#projekt#</Projekt>
						<Pps>#ajent#</Pps>
					</SklepDef>
					
					<Regaly>
						<cfset var regaly = model("asseco").regalyNaSklepie(id) />
						<cfloop query="regaly">
							<RegalDef>
								<IDRegalu>#id#</IDRegalu>
								<IDTypRegalu>#shelftypeid#</IDTypRegalu>
								<IDKategoriaRegalu>#shelfcategoryid#</IDKategoriaRegalu>
								<IDTypSklepu>#storetypeid#</IDTypSklepu>
								<cfset var tu = model("asseco").sumTotalUnits(
									storetypeid = storetypeid,
									shelftypeid = shelftypeid,
									shelfcategoryid = shelfcategoryid) />
								<Produkty>
									<cfloop query="tu">
										<Produkt>
											<Ean>#upc#</Ean>
											<Indeks>#product_id#</Indeks>
											<TotalUnits>#sum_tu#</TotalUnits>
											<PlanogramOd>#DateFormat(date_from, "yyyy-mm-dd")#</PlanogramOd>
										</Produkt>
									</cfloop>
								</Produkty>
							</RegalDef>
						</cfloop>
					</Regaly>
				</cfloop>
				</monkeygroup>
			</cfoutput>
		</cfsavecontent>
		
		<cfheader
			name="content-disposition"
			value="attachment; filename=Sklep_#DateFormat(Now(), 'dd_mm_yyyy')#.xml" />
		<cfcontent
			type="text/xml"
			variable="#ToBinary( ToBase64( xml.Trim().ReplaceAll( '>\s+', '>' ).ReplaceAll( '\s+<', '<' ) ) )#" />
			
	</cffunction>
	
	<cffunction name="xmlRegaly" output="false" access="public" hint="">
		<cfset var regaly = model("asseco").regaly() />
		<cfset var typySklepow = model("asseco").typySklepow() />
		<cfset var typyRegalow = model("asseco").typyRegalow() />
		<cfset var kategorieRegalow = model("asseco").kategorieRegalow() />
		
		<cfsavecontent variable="xml" >
			<cfoutput>
				<?xml version="1.0"?>
				<monkeygroup data="#DateFormat(Now(), 'yyyy-mm-dd')# #TimeFormat(Now(), 'HH:mm:ss')#">
					<TypRegalu>
						<cfloop query="typyRegalow">
							<TypRegaluDef>
								<IDTypu>#id#</IDTypu>
								<NazwaTypu>#shelftypename#</NazwaTypu>
							</TypRegaluDef>
						</cfloop>
					</TypRegalu>
					<KategoriaRegalu>
						<cfloop query="kategorieRegalow">
							<KategoriaRegaluDef>
								<IDKategorii>#id#</IDKategorii>
								<NazwaKategorii>#shelfcategoryname#</NazwaKategorii>
							</KategoriaRegaluDef>
						</cfloop>
					</KategoriaRegalu>
					<TypSklepu>
						<cfloop query="typySklepow">
							<TypSklepuDef>
								<IDTypuSklepu>#id#</IDTypuSklepu>
								<NazwaTypuSklepu>#store_type_name#</NazwaTypuSklepu>
							</TypSklepuDef>
						</cfloop>
					</TypSklepu>
					<Regaly>
						<cfloop query="regaly">
							<Regal>
								<IDRegalu>#id#</IDRegalu>
								<IDTypuRegalu>#shelftypeid#</IDTypuRegalu>
								<IDKategoriiRegalu>#shelfcategoryid#</IDKategoriiRegalu>
								<IDTypuSklepu>#storetypeid#</IDTypuSklepu>
							</Regal>
						</cfloop>
					</Regaly>
				</monkeygroup>
			</cfoutput>
		</cfsavecontent>
		
		<cfheader
			name="content-disposition"
			value="attachment; filename=Regaly_#DateFormat(Now(), 'dd_mm_yyyy')#.xml" />
		<cfcontent
			type="text/xml"
			variable="#ToBinary( ToBase64( xml.Trim().ReplaceAll( '>\s+', '>' ).ReplaceAll( '\s+<', '<' ) ) )#" />
			
	</cffunction>
	
	<cffunction name="eksportRegalowDoAsseco" output="false" access="public" hint="">
		<cfset var a = createObject("component", "cfc.assecoConnector").init(
			assecoConnectorDsn = "assecoConnector",
			intranetDsn = "intranet",
			assecoDsn = "asseco") />
		<cfset var r = a.pobierzRegaly() />
		<cfset i = a.wyslijRegaly(r) />
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="eksportRegalowNaSklepieDoAsseco" output="false" access="public" hint="">
		<cfsetting requesttimeout="5400" />
		
		<cfset var a = createObject("component", "cfc.assecoConnector").init(
			assecoConnectorDsn = "assecoConnector",
			intranetDsn = "intranet",
			assecoDsn = "asseco") />
		
		<cfset var s = a.pobierzSklepy() />
		<cfset var i = a.wyslijRegalyNaSklepach(s) />
		
		<cfdump var="#i#" />
		<cfabort />
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="eksportTowarowNaRegalachDoAsseco" output="false" access="public" hint="">
		<cfset var a = createObject("component", "cfc.assecoConnector").init(
			assecoConnectorDsn = "assecoConnector",
			intranetDsn = "intranet",
			assecoDsn = "asseco") />
		
		<cfset var p = a.pobierzPlanogramyZTu() />
		<cfset var p2r = a.wyslijProduktyNaRegalach(p) />
		
		<cfdump var="#p2r#" />
		<cfabort />
		<cfset renderNothing() />
	</cffunction>

</cfcomponent>