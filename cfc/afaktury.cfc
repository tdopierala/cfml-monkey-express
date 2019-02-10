<cfcomponent displayname="afaktury" output="false" hint="" accessors="true" >
	
	<cfproperty name="login" type="string" default="faktury_root" />
	<cfproperty name="password" type="string" default="faktury_root" />
	<cfproperty name="port" type="numeric" default="21" />
	<cfproperty name="host" type="string" default="..." />
	
	<cfproperty name="pathIn" type="string" default="in" />
	<cfproperty name="pathArch" type="string" default="arch" />
	
	<cfproperty name="connection" type="any" default="" />
	<cfproperty name="status" type="struct" default={} />
	
	<cfproperty name="localPathIn" type="string" default="/var/www/intranet/afaktury" />
	<cfproperty name="localPathArch" type="string" default="/var/www/intranet/afaktury_arch" />
	<cfproperty name="dsn" type="string" default="intranet" />
	<cfproperty name="dsnMssql" type="string" default="MSIntranet" />
	<cfproperty name="dsnAbs" type="string" default="asseco" />
	
	<cfscript>
		variables = {
			status = {},
			connection = ""
		};
	</cfscript>
	
	<cffunction name="init" output="false" access="public" hint="" returntype="afaktury">
		<cfloop item="local.property" collection="#arguments#">
			<cfif structKeyExists(this, "set#local.property#")>
				<cfinvoke component="#this#" method="set#local.property#">
					<cfinvokeargument name="#local.property#" value="#arguments[local.property]#" />
				</cfinvoke>
			</cfif>
		</cfloop>
		<cfreturn this />
	</cffunction>
	
	<!--- 
		Funkcje do obsługi FTP
	---> 
	<cffunction name="ftpConnect" output="false" access="public" hint="" returntype="afaktury">
		
		<cfftp action="open" username="#getLogin()#" connection="variables.connection" password="#getPassword()#" server="#getHost()#"
			stopOnError="Yes" timeout="3600" passive="true" />
		
		<cfscript>
			setStatus(cfftp);
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="ftpClose" output="false" access="public" hint="" returntype="afaktury">
				
		<cfftp action="close" connection="variables.connection" stopOnError="Yes" />
		
		<cfscript>
			setStatus({});
			setConnection({});
		</cfscript>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="ftpListDirectory" output="false" access="public" hint="" returntype="query">
		<cfargument name="dir" type="string" required="false" />
		
		<cfsetting requesttimeout="3600" />
		
		<cfif not isStruct(variables.connection) or
			structIsEmpty(variables.connection) >
		
			<cfscript>
				ftpConnect();
			</cfscript>
		
		</cfif>
		
		<cfset var dirQuery = "" />
		
		<cfif isDefined("arguments.dir")>
			
			<cfftp action="LISTDIR" stopOnError="Yes" name="dirQuery" directory = "#arguments.dir#" connection = "variables.connection" timeout="3600" passive="true" />
			
		<cfelse>
			
			<cfftp action="getcurrentdir" connection="variables.connection" timeout="3600" />
			<cfftp action="LISTDIR" stopOnError="Yes" name="dirQuery" directory = "#cfftp.ReturnValue#" connection="variables.connection" timeout="3600" />
			
		</cfif>
		
		<cfscript>
			setStatus(cfftp);
		</cfscript>
	
		<cfreturn dirQuery />
	</cffunction>
	
	<cffunction name="ftpChangeDirectory" output="false" access="public" hint="" returntype="afaktury">
		<cfargument name="dir" type="string" required="false" default="/" />
		
		<cfif not isStruct(variables.connection) or structIsEmpty(variables.connection) >
			<cfscript>
				ftpConnect();
			</cfscript>
		</cfif>
		
		<cfftp action="existsdir" directory="#arguments.dir#" connection="variables.connection" timeout="3600" />
 
		<cfif cfftp.ReturnValue EQ "NO">
			<cfftp connection="variables.connection" action="createDir" directory="#arguments.dir#" failIfExists="false" timeout="3600" />
		</cfif>
		
		<cfftp action="changedir" directory="#arguments.dir#" connection="variables.connection" stoponerror="false" timeout="3600" />
		
		<cfscript>
			setStatus(cfftp);
		</cfscript>
		
		<cfreturn this />
		
	</cffunction>
	
	<cffunction name="ftpGetFile" output="false" access="public" hint="" returntype="afaktury">
		<cfargument name="fileName" type="string" required="true" />
		<cfargument name="path" type="string" required="false" default="ftp" />
		
		<cfsetting requesttimeout="3600" />
		
		<cfif not isStruct(variables.connection) or structIsEmpty(variables.connection) >
			<cfscript>
				ftpConnect();
			</cfscript>
		</cfif>
		
		<cfset var ftpResult = "" />
		
		<cfftp action="getcurrentdir" connection="variables.connection" timeout="3600" />
		<cfftp action="getfile" username="#getLogin()#" connection="variables.connection" password="#getPassword()#" server="#getHost()#"
			   failIfExists="false" stoponerror="true" timeout="3600" passive="true"

			   remotefile="#cfftp.ReturnValue#/#arguments.fileName#"
			   localfile="#expandPath('#arguments.path#')#/#arguments.fileName#" />
		
		<cfscript>
			setStatus(cfftp);
		</cfscript>
			
		<cfreturn this />
	</cffunction>
	
	<cffunction name="ftpBakFile" output="false" access="public" hint="" returntype="afaktury">
		<cfargument name="fileName" type="string" required="true" />
		
		<cfif not isStruct(variables.connection) or structIsEmpty(variables.connection) >
			<cfscript>
				ftpConnect();
			</cfscript>
		</cfif>
		
		<cfif structKeyExists(variables.status, "Succeeded") AND getStatus().Succeeded EQ "YES">
			
			<cfftp action="getcurrentdir" connection="variables.connection" />
			<cfftp action="rename" existing="#cfftp.ReturnValue#/#arguments.fileName#" new="#cfftp.ReturnValue#/#arguments.fileName#.bak" 
				username="#getLogin()#" connection="variables.connection" password="#getPassword()#" server="#getHost()#" stoponerror="false" />
			
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="ftpArchFile" output="false" access="public" hint="" returntype="afaktury">
		<cfargument name="fileName" type="string" required="true" />
		
		<cfif not isStruct(variables.connection) or structIsEmpty(variables.connection) >
			<cfscript>
				ftpConnect();
			</cfscript>
		</cfif>
		
		<cfif structKeyExists(variables.status, "Succeeded") AND getStatus().Succeeded EQ "YES">
			<cfftp action="getcurrentdir" connection="variables.connection" /> 
			<cfftp action="rename" existing="#cfftp.ReturnValue#/#arguments.fileName#" new="#getPathArch()#/#arguments.fileName#" connection="variables.connection" />
		</cfif>
		
		<cfreturn this />
	</cffunction>
	
	<!---
		Funkcje importu faktury do Intranetu
	--->
	<cffunction name="importDoIntranetu" output="false" access="public" hint="" returntype="afaktury">
		
		<cfset var parsowanie = createObject("component", "cfc.parsing").init() />
		<cfset var plikiDoPobrania = ftpChangeDirectory("in").ftpListDirectory() />
		<cfset var dokumentDAO = createObject("component", "cfc.models.DokumentDAO").init(getDsn()) />
		
		<cfset var listaPlikowCsv = "" />
		<cfquery name="listaPlikowCsv" dbtype="query">
			select * from plikiDoPobrania
			where NAME like <cfqueryparam value="%.csv" cfsqltype="cf_sql_varchar" />;
		</cfquery>
		
		<cfloop query="listaPlikowCsv">
			
			<cftry>
			
				<cfset nazwaPliku = listToArray(name, ".") />
				
				<cfftp action="existsfile" remotefile="#getPathIn()#/#nazwaPliku[1]#.pdf" connection="variables.connection" stoponerror="false" />
				<cfset var statusPlikuPdf = cfftp.ReturnValue />
				<cfftp action="existsfile" remotefile="#getPathIn()#/#nazwaPliku[1]#.csv" connection="variables.connection" stoponerror="false" />
				<cfset var statusPlikuCsv = cfftp.ReturnValue />
				
				<cfif statusPlikuPdf is true>
				
					<cfset ftpGetFile(fileName="#nazwaPliku[1]#.pdf", path="afaktury_tmp") />
					<cfset ftpGetFile(fileName="#nazwaPliku[1]#.csv", path="afaktury_tmp") />
					
					<cfset plikCsv = parsowanie.csvToArray(file="/var/www/intranet/afaktury_tmp/#nazwaPliku[1]#.csv",delimiter=",",trim="true") />
				
					<!---
						Zmienne o przechowywania wyników zapytań na bazie.
					--->
					<cfset var kontrahent = "" />
					<cfset var nowyDokument = "" />
					<cfset var nowyDokumentResult = "" />
					<cfset var nowaInstancjaDokumentu = "" />
					<cfset var nowaInstancjaDokumentuResult = "" />
					<cfset var nowyArgumentDokumentu = "" />
					<cfset var danePps = "" />
					<cfset var kontrahentAbs = "" />
					
					<cfquery name="kontrahent" datasource="#getDsn()#" >
						select * from contractors where str_logo = <cfqueryparam value="#plikCsv[1][2]#" cfsqltype="cf_sql_varchar" /> order by id desc limit 1;
					</cfquery>
					
					<cfstoredproc dataSource = "#getDsnAbs()#" procedure = "wusr_sp_intranet_get_contractors" returncode = "yes">
						<cfprocparam type = "in" cfsqltype = "CF_SQL_VARCHAR" value = "%" dbVarName = "@search" />
						<cfprocparam type = "in" cfsqltype = "CF_SQL_VARCHAR" value = "#plikCsv[1][2]#" dbVarName = "@logo" />
						<cfprocresult name="kontrahentAbs" />
					</cfstoredproc>
					
					<!--- Jeżeli nie ma kontrahenta w Intranecie a jest w ABS to dodaje go do Intranetu --->
					<cfif kontrahent.recordCount EQ 0 and kontrahentAbs.recordCount EQ 1>

						<cfset var k = {
							internalid = kontrahentAbs.internalid,
							kli_kontrahenciid = kontrahentAbs.kli_kontrahenciid,
							logo = kontrahentAbs.logo,
							nazwa1 = kontrahentAbs.nazwa1,
							nazwa2 = kontrahentAbs.nazwa2,
							nip = kontrahentAbs.nip,
							regon = kontrahentAbs.regon,
							typulicy = kontrahentAbs.typulicy,
							ulica = kontrahentAbs.ulica,
							nrdomu = kontrahentAbs.nrdomu,
							nrlokalu = kontrahentAbs.nrlokalu,
							kodpocztowy = kontrahentAbs.kodpocztowy,
							dzielnica = kontrahentAbs.dzielnica,
							miejscowosc = kontrahentAbs.miejscowosc,
							kraj = kontrahentAbs.kraj	
						} />
						<cfset kontrahent = dodajKontrahentaDoIntranetu(k) />

					</cfif>

					
					<cfif kontrahent.RecordCount EQ 1>
						<cfset var dataUtworzenia = Now() />
						
						<cfquery name="danePps" datasource="#getDsn()#">
							select * from store_stores where projekt = <cfqueryparam value="#plikCsv[1][1]#" cfsqltype="cf_sql_varchar" />
							and ajent = <cfqueryparam value="#plikCsv[1][2]#" cfsqltype="cf_sql_varchar" />
							and is_active = 1;
						</cfquery>
						
						<!---
							Tworze katalogi na serwerze Intranetowym
						--->
						<cfif not directoryExists(expandPath("afaktury_arch/#DateFormat(dataUtworzenia, 'yyyy/mm')#"))>
							<cfdirectory action="create" directory="#expandPath('afaktury_arch/#DateFormat(dataUtworzenia, 'yyyy/mm')#')#" mode="777" />
						</cfif>
						<!---
						<cfif directoryExists(expandPath("afaktury_error/#DateFormat(dataUtworzenia, 'mm')#"))>
							<cfdirectory action="create" directory="#expandPath('afaktury_error/#DateFormat(dataUtworzenia, 'mm')#')#" mode="777" />
						</cfif>
						--->
						<cfif not directoryExists(expandPath("afaktury/#DateFormat(dataUtworzenia, 'yyyy/mm')#"))>
							<cfdirectory action="create" directory="#expandPath('afaktury/#DateFormat(dataUtworzenia, 'yyyy/mm')#')#" mode="777" />
						</cfif>
						
						<!--- 
							Numer korespondencyjny faktury
						--->
						<cflock timeout="180" scope="Application" type="exclusive" >
							<cfset var numerDokumentu = "P/#Year(Now())#/#DateFormat(Now(),'mm')#/#NumberFormat(Application.workflowDocumentNumber, '00009')#" />
							<cfset Application.workflowDocumentNumber = Application.workflowDocumentNumber + 1 />
							<cfset var aktualizacjaLicznikaFv = "" />
							<cfquery name="aktualizacjaLicznikaFv" datasource="#getDsn()#">
								start transaction;
								update workflowsettings set workflowsettingvalue = <cfqueryparam value="#Application.workflowDocumentNumber#" cfsqltype="cf_sql_varchar" />
								where workflowsettingname = <cfqueryparam value="invoicenumber" cfsqltype="cf_sql_varchar" />;
								commit;
							</cfquery>
						</cflock>
						
						<cfset var plikOcr = "" />
						<cfpdf action="extracttext" source="#expandPath('afaktury_tmp/#nazwaPliku[1]#.pdf')#" pages="*" honourspaces="false" type="string" name="plikOcr" />
						
						<!---
							Dodawanie wpisu do tabeli documents
						--->
						<cfset var dokument = createObject("component", "cfc.models.Dokument") />
						<cfscript>
							dokument.setDocumentname(numerDokumentu);
							dokument.setDocumentcreated(dataUtworzenia);
							dokument.setUserid(-1);
							dokument.setContractorid(kontrahent.id);
							dokument.setDelegation(0);
							dokument.setHrdocumentvisible(1);
							dokument.setTypeid(0);
							dokument.setCategoryid(0);
							dokument.setArchiveid(0);
							dokument.setPaid(0);
							dokument.setSys("AUT");
							dokument.setToDelete(0);
							dokument.setDocument_ocr(reReplace(plikOcr, '[[:space:]]', '', 'ALL'));
							dokument.setDocument_file_name("afaktury/#DateFormat(dataUtworzenia, 'yyyy/mm')#/#nazwaPliku[1]#.pdf");
							dokument.setDocument_src("afaktury/#DateFormat(dataUtworzenia, 'yyyy/mm')#");
							dokument.setNoDocumentInstances(5);
						</cfscript>
						
						<cfset var nowyDokument = dokumentDAO.create(dokument) />
						
						<!---
							Zapisywanie atrybutów faktury
						--->
						<cfquery name="nowyArgumentDokumentu" datasource="#getDsn()#">
							insert into documentattributevalues (documentattributeid, documentid, documentattributetextvalue, attributeid, documentinstanceid)
							values 
							(
								<cfqueryparam value="100" cfsqltype="cf_sql_integer" />, <cfqueryparam value="#dokument.getId()#" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="#numerDokumentu#" cfsqltype="cf_sql_varchar" />, <cfqueryparam value="100" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="-1" cfsqltype="cf_sql_integer" />
							),
							(
								<cfqueryparam value="101" cfsqltype="cf_sql_integer" />, <cfqueryparam value="#dokument.getId()#" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="#plikCsv[1][7]#" cfsqltype="cf_sql_varchar" />, <cfqueryparam value="101" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="-1" cfsqltype="cf_sql_integer" />
							),
							(
								<cfqueryparam value="102" cfsqltype="cf_sql_integer" />, <cfqueryparam value="#dokument.getId()#" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="#plikCsv[1][8]#" cfsqltype="cf_sql_varchar" />, <cfqueryparam value="102" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="-1" cfsqltype="cf_sql_integer" />
							),
							(
								<cfqueryparam value="103" cfsqltype="cf_sql_integer" />, <cfqueryparam value="#dokument.getId()#" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="#plikCsv[1][5]#" cfsqltype="cf_sql_varchar" />, <cfqueryparam value="103" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="-1" cfsqltype="cf_sql_integer" />
							),
							(
								<cfqueryparam value="104" cfsqltype="cf_sql_integer" />, <cfqueryparam value="#dokument.getId()#" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="#plikCsv[1][6]#" cfsqltype="cf_sql_varchar" />, <cfqueryparam value="104" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="-1" cfsqltype="cf_sql_integer" />
							),
							(
								<cfqueryparam value="105" cfsqltype="cf_sql_integer" />, <cfqueryparam value="#dokument.getId()#" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="#DateFormat(DateAdd('d', 14, dataUtworzenia), 'yyyy-mm-dd')#" cfsqltype="cf_sql_varchar" />, <cfqueryparam value="105" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="-1" cfsqltype="cf_sql_integer" />
							),
							(
								<cfqueryparam value="106" cfsqltype="cf_sql_integer" />, <cfqueryparam value="#dokument.getId()#" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="#DateFormat(dataUtworzenia, 'yyyy-mm-dd')#" cfsqltype="cf_sql_varchar" />, <cfqueryparam value="106" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="-1" cfsqltype="cf_sql_integer" />
							),
							(
								<cfqueryparam value="108" cfsqltype="cf_sql_integer" />, <cfqueryparam value="#dokument.getId()#" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="#plikCsv[1][3]#" cfsqltype="cf_sql_varchar" />, <cfqueryparam value="108" cfsqltype="cf_sql_integer" />,
								<cfqueryparam value="-1" cfsqltype="cf_sql_integer" />
							);
						</cfquery>
						
						<!---
							Wysłanie informacji do PPS o imporcie faktury
						--->
						<cfmail to="#plikCsv[1][1]#@mexpress.com" bcc="intranet@m.pl" from="intranet@m.pl" replyto="intranet@m.pl" type="html" subject="Faktura">
							<cfoutput>
								Dzien dobry #danePps.nazwaajenta#,<br />
								Twoja faktura nr #plikCsv[1][3]# na kwote #plikCsv[1][8]# PLN brutto wystawiona w systemie afaktury.pl zostala zaimportowana z dniem dzisiejszym do systemu.<br /><br />
								Pozdrawiamy,<br />
							</cfoutput>
						</cfmail>
						
						<!---
							Przesunięcie pliku pdf z fakturą z katalogu afaktury_tmp/ do afaktury/.
							Przesunięcie plików na ftp do katalogu /arch
						--->
							
						<cffile action="move" source="#expandPath('afaktury_tmp/#nazwaPliku[1]#.pdf')#" destination="#expandPath('afaktury/#DateFormat(dataUtworzenia, 'yyyy/mm')#/#nazwaPliku[1]#.pdf')#" />
						<cffile action="move" source="#expandPath('afaktury_tmp/#nazwaPliku[1]#.csv')#" destination="#expandPath('afaktury_arch/#DateFormat(dataUtworzenia, 'yyyy/mm')#/#nazwaPliku[1]#.csv')#" />
						
						<cfftp action="rename" existing="#getPathIn()#/#nazwaPliku[1]#.pdf" new="#getPathArch()#/#nazwaPliku[1]#.pdf" connection="variables.connection" />
						<cfftp action="rename" existing="#getPathIn()#/#nazwaPliku[1]#.csv" new="#getPathArch()#/#nazwaPliku[1]#.csv" connection="variables.connection" />
						
					<cfelse>
						
						<cffile action="move" source="#expandPath('afaktury_tmp/#nazwaPliku[1]#.pdf')#" destination="#expandPath('afaktury_error/#nazwaPliku[1]#.pdf')#" />
						<cffile action="move" source="#expandPath('afaktury_tmp/#nazwaPliku[1]#.csv')#" destination="#expandPath('afaktury_error/#nazwaPliku[1]#.csv')#" />
							
						<cfftp action="rename" existing="#getPathIn()#/#nazwaPliku[1]#.pdf" new="#getPathArch()#/#nazwaPliku[1]#.pdf.error" connection="variables.connection" />
						<cfftp action="rename" existing="#getPathIn()#/#nazwaPliku[1]#.csv" new="#getPathArch()#/#nazwaPliku[1]#.csv.error" connection="variables.connection" />
						
					</cfif>
				
				<cfelse>
					
					<cfset ftpGetFile(fileName="#nazwaPliku[1]#.csv", path="afaktury_tmp") />
					<cfset plikCsv = parsowanie.csvToArray(file="/var/www/intranet/afaktury_tmp/#nazwaPliku[1]#.csv",delimiter=",",trim="true") />
					
					<cfmail to="admin@m.pl" from="INTRANET <intranet@m.pl>" type="html" subject="Blad importu plikow afaktury.pl" priority="highest" >
						<cfoutput>
							<h1>Blad importu plikow afaktury.pl</h1>
								Wystapil blad podczas importu plikow afaktury.pl<br />
								Nie ma obu plikow (PDF i CSV) dla #nazwaPliku[1]#. Faktura nie zostanie dodana do Intranetu!<br /><br />
								Dane na fakturze: <br />
								<ul>
									<li>Numer sklepu: #plikCsv[1][1]#</li>
									<li>Logo: #plikCsv[1][2]#</li>
									<li>Numer faktury: #plikCsv[1][3]#</li>
									<li>Data wystawienia: #plikCsv[1][5]#</li>
									<li>Data sprzedazy: #plikCsv[1][6]#</li>
									<li>Netto: #plikCsv[1][7]#</li>
									<li>Brutto: #plikCsv[1][8]#</li>
								</ul>
						</cfoutput>
					</cfmail>

					<cfftp action="rename" existing="#getPathIn()#/#nazwaPliku[1]#.csv" new="#getPathArch()#/#nazwaPliku[1]#.csv.error" connection="variables.connection" />
					<cffile action="move" source="#expandPath('afaktury_tmp/#nazwaPliku[1]#.csv')#" destination="#expandPath('afaktury_error/#nazwaPliku[1]#.csv')#" />
					
					<cfthrow message="Brak wszystkich plików" />
					
				</cfif>

				<cfcatch type="any" >
				</cfcatch>

			</cftry>

		</cfloop>
		
		<!---
		<cfdirectory action="list" directory="#getLocalPathIn()#" name="files" filter="*.csv" />
		<cfloop query="files">
			<cfquery name="daneNaFakturze" datasource="#getDsn()#">
				<!---begin transaction;
					bulk insert dbo.afaktury_csv
					from '#getLocalPathIn()#/#name#'
					WITH
					(
						CODEPAGE  = 'ACP',
						FIELDTERMINATOR = ',',
						ROWTERMINATOR = '\n',
						FIRSTROW = 1
					)
				commit;--->
				
				<!---start transaction;
					SET autocommit=0;
					load data local infile '#getLocalPathIn()#/#name#'
					into table document_afaktury_csv
					<!---fields terminated by ',' enclosed by '"'--->
					(nrSklepu, logo, numerFaktury, login, dataWystawienia, dataSprzedazy, kwotaNetto, kwotaBrutto, wersja, aplikacja);
				commit;--->
			</cfquery>
			<!---<cffile action="rename" destination="#getLocalPathArch()#/#name#" source="#getLocalPathIn()#/#name#" />--->
		</cfloop>
		
		<cfset var dane = "" />
		<cfquery name="dane" datasource="#getDsn()#">
			start transaction;
				select * from document_afaktury_csv;
			commit;
		</cfquery>
		
		<cfdump var="#dane#" />
		<cfabort />
		--->
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="usunDokument" output="false" access="public" hint="" returntype="struct">
		<cfargument name="dokument" type="numeric" required="false" />
		<cfargument name="uzytkownik" type="numeric" required="true" />
		
		<cfsetting requesttimeout="3600" />
		
		<cfset var result = structNew() />
		<cfset result.success = true />
		<cfset result.message = "Dokument #arguments.dokument# został usunięty" />
		
		<cfset var usunDokument = "" />
		<cftry>
			
			<cfset var dok = createObject("component", "cfc.models.Dokument").init(id = arguments.dokument) />
			<cfset var dokumentDAO = createObject("component", "cfc.models.DokumentDAO").init(dsn = getDsn()) />
			<cfset dokumentDAO.read(dok) />
			
			<cfset var nazwaPliku = listToArray(dok.getDocument_file_name(), "/") />
			<cfset var plik = nazwaPliku[arrayLen(nazwaPliku)] />
			
			<cfif Len( dok.getDocument_file_name() ) and Len( dok.getDocumentname() ) and fileExists( expandPath( "#dok.getDocument_file_name()#" ) )>
			
				<cfif not directoryExists( ExpandPath( "afaktury_arch/#DateFormat(dok.getDocumentcreated(), 'yyyy')#/#DateFormat(dok.getDocumentcreated(), 'mm')#" ) )>
					<cfset directoryCreate( expandPath( "afaktury_arch/#DateFormat(dok.getDocumentcreated(), 'yyyy')#/#DateFormat(dok.getDocumentcreated(), 'mm')#" ) ) />
				</cfif>
			
			<cffile action="move" destination="#expandPath( 'afaktury_arch/#DateFormat(dok.getDocumentcreated(), 'yyyy')#/#DateFormat(dok.getDocumentcreated(), 'mm')#/#plik#' )#" source="#expandPath( '#dok.getDocument_file_name()#' )#" />
			</cfif> 
			
			<cftransaction action="begin" isolation="read_committed" >

				<cfquery name="usunDokument" datasource="#getDsn()#" timeout="3600">
					
					insert into del_documents select * from documents where id = #arguments.dokument#;
					delete from documents where id = #arguments.dokument#;
					insert into del_history (del_historydate, del_historytable, del_historytablefield, del_historytablekey, del_historyuserid, del_historyip)
					values (NOW(), 'documents', 'id', #arguments.dokument#, #arguments.uzytkownik#, 'local');
					
					insert into del_cron_invoicereports select * from cron_invoicereports where documentid = #arguments.dokument#;
					delete from cron_invoicereports where documentid = #arguments.dokument#;
					insert into del_history (del_historydate, del_historytable, del_historytablefield, del_historytablekey, del_historyuserid, del_historyip)
					values (NOW(), 'cron_invoicereports', 'documentid', #arguments.dokument#, #arguments.uzytkownik#, 'local');
	
					insert into del_trigger_workflowsearch select * from trigger_workflowsearch where documentid = #arguments.dokument#;
					delete from trigger_workflowsearch where documentid = #arguments.dokument#;
					insert into del_history (del_historydate, del_historytable, del_historytablefield, del_historytablekey, del_historyuserid, del_historyip)
					values (NOW(), 'trigger_workflowsearch', 'documentid', #arguments.dokument#, #arguments.uzytkownik#, 'local');
	
					insert into del_trigger_workflowsteplists select * from trigger_workflowsteplists where documentid = #arguments.dokument#;
					delete from trigger_workflowsteplists where documentid = #arguments.dokument#;
					insert into del_history (del_historydate, del_historytable, del_historytablefield, del_historytablekey, del_historyuserid, del_historyip)
					values (NOW(), 'trigger_workflowsteplists', 'documentid', #arguments.dokument#, #arguments.uzytkownik#, 'local');
	
					<!---
					insert into del_documentinstances select * from documentinstances where documentid = #arguments.dokument#;
					delete from documentinstances where documentid = #arguments.dokument#;
					insert into del_history (del_historydate, del_historytable, del_historytablefield, del_historytablekey, del_historyuserid, del_historyip)
					values (NOW(), 'documentinstances', 'documentid', #arguments.dokument#, #arguments.uzytkownik#, 'local');
					--->
	
					insert into del_documentattributevalues select * from documentattributevalues where documentid = #arguments.dokument#;
					delete from documentattributevalues where documentid = #arguments.dokument#;
					insert into del_history (del_historydate, del_historytable, del_historytablefield, del_historytablekey, del_historyuserid, del_historyip)
					values (NOW(), 'documentattributevalues', 'documentid', #arguments.dokument#, #arguments.uzytkownik#, 'local');
				
				</cfquery>
			
			</cftransaction>
			
			<cfcatch type="any">
				<cfset result.success = false />
				<cfset result.message = "Nie mogę usunąć dokumentu #arguments.dokument#: #cfcatch.message#" />

				<cfmail to="admin@m.pl" from="INTRANET <intranet@m.pl>" replyto="intranet@m.pl" type="html" subject="Błąd usunięcia faktury afaktury.pl">
					<cfoutput>
						<h1>Wystąpił błąd przy usuwaniu afaktury.pl</h1>
						<cfdump var="#result#" />
						<cfdump var="#cfcatch#" />
					</cfoutput>
				</cfmail>

			</cfcatch>
		
		</cftry>
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="oznaczDoUsuniecia" output="false" access="public" hint="" returntype="struct">
		<cfargument name="dokument" type="numeric" required="false" />
		<cfargument name="uzytkownik" type="numeric" required="false" />
		
		<cfset var result = structNew() />
		<cfset result.success = true />
		<cfset result.message = "Dokument #arguments.dokument# został oznaczony do usunięcia" />
		
		<cfset var oznaczenieDoUsuniecia = "" />
		<cfset var daneDokumentu = "" />
		
		<cftry>
			
			<cfset var dokumentDAO = createObject("component", "cfc.models.DokumentDAO").init(getDsn()) />
			<cfset var mojDokument = createObject("component", "cfc.models.Dokument").init(id = arguments.dokument) />
			<cfset dokumentDAO.read(mojDokument) />
			
			<cfset mojDokument.setToDelete(1) />
			<cfset var aktualizacja = dokumentDAO.update(mojDokument) />
			
			<!---
			<cfif aktualizacja.success is true>
				<cfif Len( mojDokument.getDocument_file_name() ) GT 0 and fileExists(expandPath( mojDokument.getDocument_file_name() ))>
					<cfset var nowaSciezka = rereplace(mojDokument.getDocument_src(), "afaktury", "afaktury_del", "ALL") />
					<cfset var nowyPlik = rereplace(mojDokument.getDocument_file_name(), "afaktury", "afaktury_del", "ALL") />
					
					<cfif not directoryExists( expandPath( nowaSciezka ) ) >
						<cfdirectory action="create" directory="#expandPath( nowaSciezka )#" />
					</cfif>
					
					<cffile action="move" destination="#expandPath( nowyPlik )#" source="#expandPath( mojDokument.getDocument_file_name() )#" />
				</cfif>
			</cfif>
			--->
			
			<!---
			<cftransaction action="begin" isolation="read_committed" >
				<cfquery name="oznaczenieDoUsuniecia" datasource="#getDsn()#">
					update documents set toDelete = 1 
					where id = <cfqueryparam value="#arguments.dokument#" cfsqltype="cf_sql_integer" />;
				</cfquery>
			</cftransaction>
			
			<cfquery name="daneDokumentu" datasource="#getDsn()#">
				select documentfilename as src from documentinstances 
				where documentid = <cfqueryparam value="#arguments.dokument#" cfsqltype="cf_sql_integer" />; 
			</cfquery>
			
			<cfif Len(daneDokumentu.src) GT 0 and fileExists(expandPath("afaktury/#daneDokumentu.src#"))>
				<cffile action="move" destination="#expandPath('afaktury_del')#/#daneDokumentu.src#" source="#expandPath('afaktury')#/#daneDokumentu.src#" />
			</cfif>
			--->
			<cfcatch type="any">
				<cfset result.success = false />
				<cfset result.message = "Wystąpił błąd przy oznaczeniu dokumentu #arguments.dokument# do usunięcia" />
				
				<cfmail to="admin@m.pl" from="INTRANET <intranet@m.pl>" replyto="intranet@m.pl" type="html" subject="Błąd oznaczenia faktury do usunięcia">
					<cfoutput>
						<h1>Wystąpił błąd przy oznaczeniu faktury do usunięcia</h1>
						<cfdump var="#result#" />
						<cfdump var="#mojDokument#" />
						<cfdump var="#cfcatch#" />
					</cfoutput>
				</cfmail>
				
			</cfcatch>
			
		</cftry> 
		
		<cfreturn result />
	</cffunction>
	
	<cffunction name="listaFakturDoPrzypisania" output="false" access="public" hint="" returntype="query">
		<cfset var listaFaktur = "" />
		<cfquery name="listaFaktur" datasource="#getDsn()#">
			select * from trigger_workflowsearch a
			inner join documents b on a.documentid = b.id
			where b.sys = <cfqueryparam value="AUT" cfsqltype="cf_sql_varchar" />
				and b.userid = <cfqueryparam value="-1" cfsqltype="cf_sql_integer" />
				and b.toDelete = 0;
		</cfquery>
		
		<cfreturn listaFaktur />
	</cffunction>
	
	<cffunction name="listaDoUsuniecia" output="false" access="public" hint="">
		<cfset var lista = "" />
		<cfquery name="lista" datasource="#getDsn()#">
			select * from documents where toDelete = 1;
		</cfquery>
		
		<cfreturn lista />
	</cffunction>
	
	<cffunction name="przypiszFakture" output="false" access="public" hint="" returntype="struct">
		<cfargument name="przypiszDo" type="numeric" required="false" default="2" />
		<cfargument name="ktoPrzypisuje" type="numeric" required="false" default="-1" />
		<cfargument name="dokument" type="numeric" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dokument #arguments.dokument# został przypisany do #arguments.przypiszDo#" />
		
		<cfset var aktualizacjaDokumentu = "" />
		<cfset var inicjacjaObiegu = "" />
		<cfset var inicjacjaObieguResult = "" />
		<cfset var etapObiegu = "" />
		<cfset var dataUtworzenia = Now() />
		
		<cftry>
		
			<cfquery name="aktualizacjaDokumentu" datasource="#getDsn()#">
				update documents set userid = <cfqueryparam value="#arguments.ktoPrzypisuje#" cfsqltype="cf_sql_integer" />
				where id = <cfqueryparam value="#arguments.dokument#" cfsqltype="cf_sql_integer" />;
			</cfquery>
			
			<cfquery name="inicjacjaObiegu" result="inicjacjaObieguResult" datasource="#getDsn()#">
				insert into workflows (workflowcreated, userid, documentid)
				values (
					<cfqueryparam value="#dataUtworzenia#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#arguments.ktoPrzypisuje#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.dokument#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
			 
			<cfquery name="etapObiegu" datasource="#getDsn()#">
				insert into workflowsteps (workflowstepcreated, userid, workflowstatusid, workflowstepstatusid, workflowid, documentid)
				values (
					<cfqueryparam value="#dataUtworzenia#" cfsqltype="cf_sql_timestamp" />,
					<cfqueryparam value="#arguments.przypiszDo#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="1" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="1" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#inicjacjaObieguResult.generatedKey#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#arguments.dokument#" cfsqltype="cf_sql_integer" />
				);
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Błąd przy przypisaniu dokumentu #arguments.dokument# do użytkownika #arguments.przypiszDo#: #cfcatch.message#" />
			</cfcatch>
		
		</cftry>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="czyAut" output="false" access="public" hint="" returntype="boolean">
		<cfargument name="dokument" type="numeric" required="false" />
		
		<cfset var dok = "" />
		<cfquery name="dok" datasource="#getDsn()#">
			select * from documents where id = <cfqueryparam value="#arguments.dokument#" cfsqltype="cf_sql_integer" />; 
		</cfquery>
		
		<cfif dok.sys is "AUT">
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction> 
	
	<cffunction name="czyArchAut" output="false" access="public" hint="" returntype="boolean">
		<cfargument name="dokument" type="numeric" required="false" />
		
		<cfset var dok = "" />
		<cfquery name="dok" datasource="#getDsn()#">
			select * from arch_documents where id = <cfqueryparam value="#arguments.dokument#" cfsqltype="cf_sql_integer" />; 
		</cfquery>
		
		<cfif dok.sys is "AUT">
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction> 
	
	<cffunction name="dodajKontrahentaDoIntranetu" output="false" access="public" hint="" returntype="query">
		<cfargument name="daneKontrahenta" type="struct" required="true" />
		
		<cfset var results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Dodałem nowego kontrahenta" />
		
		<cfset var nowyKontrahent = "" />
		<cfset var nowyKontrahentResult = "" />
		<cfset var nowyKontrahentId = -1 />
		<cfset var kontrahent = "" />
		<cftry>
			<cfquery name="nowyKontrahent" result="nowyKontrahentResult" datasource="#getDsn()#">
				insert into contractors (internalid, kli_kontrahenciid, kodpocztowy, logo, miejscowosc, nazwa1, nazwa2, nip, nrdomu, nrlokalu, regon, typulicy, ulica, str_logo, dzielnica) values (
					<cfqueryparam value="#arguments.daneKontrahenta['internalid']#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.daneKontrahenta['kli_kontrahenciid']#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.daneKontrahenta['kodpocztowy']#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.daneKontrahenta['logo']#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.daneKontrahenta['miejscowosc']#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.daneKontrahenta['nazwa1']#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.daneKontrahenta['nazwa2']#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.daneKontrahenta['nip']#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.daneKontrahenta['nrdomu']#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.daneKontrahenta['nrlokalu']#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.daneKontrahenta['regon']#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.daneKontrahenta['typulicy']#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.daneKontrahenta['ulica']#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.daneKontrahenta['logo']#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#arguments.daneKontrahenta['dzielnica']#" cfsqltype="cf_sql_varchar" />
				);
			</cfquery>
			
			<cfset nowyKontrahentId = nowyKontrahentResult.generatedKey />
			
			<cfquery name="kontrahent" datasource="#getDsn()#">
				select * from contractors where id = <cfqueryparam value="#nowyKontrahentId#" cfsqltype="cf_sql_integer" /> limit 1;
			</cfquery>
			
			<cfcatch type="database">
				<cfset results.success = false />
				<cfset results.message = "Nie mogłem dodać kontrahenta do Intranetu: #cfcatch.message#" />
			</cfcatch>
		</cftry>
		<cfreturn kontrahent />
	</cffunction>
	
</cfcomponent>