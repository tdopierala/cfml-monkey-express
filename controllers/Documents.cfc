<!---
Komponent odpowiedzialny za dokumenty znajdujące się w Intranecie.
Początkowo będą wprowadzane tylko faktury do elektronicznego obiegu dokumentów.

Komponent pozwala na dodanie nowego dokumentu i zapisanie go w bazie z polu typu LONGBLOB.
--->
<cfcomponent extends="Controller" hint="">

	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="before",type="before") />
	</cffunction>
	
	<cffunction name="before" output="false" access="public" hint="">
		<cfset usesLayout(template="/layout") />
	</cffunction>

	<!---
		Lista wszystkich dokumentów w serwisie.
		Lista jest paginowana po 20 elementów na stronie.
	--->
	<cffunction
		name="index"
		hint="Lista wszystkich dokumentów w obiegu">

		<cfif !IsDefined("params.page")>

			<cfset params.page = 1>

		</cfif>

		<cfset documents = model("document").getDocuments(page=params.page,perPage=20)>

	</cffunction>

	<cffunction
		name="add"
		hint="Formularz dodawania nowego dokumentu do systemu.
			Formularz został przygotowany tak, aby dodawać faktury.">

		<cftry>
		<cfset document = model("document").new()>
		<cfset documentattributes = model("documentAttribute").findAll(where="documentattributevisible=1",include="attribute") />
		<cfset users = model("workflowStepStatusUser").findAll(where="workflowstepstatusid=1",include="user")>

		<cfset invoicenumber = model("workflowSetting").findOne(where="workflowsettingname='invoicenumber'") />
		<cfset nextNumber = invoicenumber.workflowsettingvalue />
		
		<cfcatch type="any">
			<cfdump var="#cfcatch#" />
			<cfabort />
		</cfcatch>
		</cftry>
	</cffunction>

	<!---
	actionAdd
	---------------------------------------------------------------------------------------------------------------
	Dodawanie dokumentu do obiegu jest newralgiczną funkcjonalnością.
	Jej nieprawidłowe działanie spowoduje błędy w zapisywanych danych.

	24.01.2012
	Wszystkie zapytania do bazy danych są dodane w blokach try-catch aby uniknąć błędów aplikacji.

	Kroki dodawania nowego dokumentu:
	- Stworzenie definicji dokumentu z datą jego dodania
	- Stworzenie miniaturki pliku PDF
	- Wyciągnięcie tekstu z dokumentu PDF
	- Dodanie instancji dokumentu
	- Dodanie dokumentu automatycznie tworzy obieg dokumentów i dodaje pierwszy wpis do obiegu
	- Do tabeli z historią kroków dokumentu jest wpisana pierwsza wartość
	(użytkownik a dostał od użytkownika b dokument c o dacie d)

	25.01.2012
	Dodawanie dokumenty lekko się zmieniło. Teraz odbywa się w 2 krokach. Pierwszy to wybranie pliku z fakturą i
	załadowanie jej na serwer. Ta metoda jest wykonywana Ajaxowo.
	Nowe kroki zapisywania dokumentu:
	- Sprawdzenie czy na dysku istnieją przesłane pliki (pdf i miniaturka)
	- Wyciągam tekst z dokumentu pdf
	- Czytam dokument binarnie
	- Czytam miniaturkę binarnie
	- Zapisuje definicje dokumentu
	- Zapisuje instancje dokumentu
	- Zapisuje atrybuty dokumentu
	- Tworze pierwszy krok obiegu dokumentów

	27.01.2012
	Zmienione zostało dodawanie dokumentu do obiegu. Nowe kroki:
	- Sprawdzenie, czy istnieje plik na dysku.
	- Sprawdzenie, czy istnieje miniaturka
	- Dodanie definicji obiegu dokumentów
	- Dodanie instancji dokumentu

	12.03.2012
	Dodane zostało zapisywanie Kontrahenta w bazie Intranetowej.
	Kontrahenci są pobierani z Asseco i podstawowe dane są umieszczane w formularzu dodawania dokumentu do obiegu.
	Przy zapisywaniu dokumentu system sprawdza, czy taki Kontrahent jest już dodany (unikalny numer NIP). Jeśli kontrahent istnieje to
	zapisuje klucz obcy. Jeśli Kontrahenta nie ma to dodaje go do bazy i wtedy zapisuje klucz obcy.
	Nowe kroki:
	- Sprawdzam, czy istnieje Kontrahent o podanym NIPie
	- Jeśli kontrahenta nie ma to dodaje go i wyciągam jego ID
	- Dodaje powiązanie dokumentu z Kontrahentem

	--->
	<cffunction name="actionAdd" hint="Dodawanie nowego dokumentu. Metoda zapisuje wszystko w bazie i przenosi do pierwszego
										etapu obiegu dokumentu - formularza wysyłania powiadomienia do użytkownika.
										Jeśli jest przesłany dokument w formacie PDF do jest on OCRowany i zapisywany
										w bazie. Dodatkowo jest robiona miniaturka pierwszej strony i też jest zapisana
										w bazie.">
		
		<cfset var dokumentDAO = createObject("component", "cfc.models.DokumentDAO").init(get('loc').datasource.intranet) />
		<cfset var kontrahenciGateway = createObject("component", "cfc.models.KontrahenciGateway").init(get("loc").datasource.intranet) />
		<cfset var kontrahentDAO = createObject("component", "cfc.models.KontrahentDAO").init(get("loc").datasource.intranet) />
		
		<cfset var kontrahent = kontrahenciGateway.pobierzKontrahentaPoLogo(params.contractor.logo) /> <!--- Kontrahent na fakturze --->
		<cfset kontrahentDAO.read(kontrahent) />
		
		<cfif not Len( kontrahent.getLogo() )> <!--- Jeżeli kontrahent nie jest zdefiniowany to nie mam jego LOGO --->
			<cfscript>
				var pobierzKontrahenta = params.contractor;
				
				if ( Len( pobierzKontrahenta.dzielnica ) )
					kontrahent.setDzielnica(pobierzKontrahenta.dzielnica);
				else
					kontrahent.setDzielnica("");
					
				kontrahent.setInternalid(pobierzKontrahenta.internalid);
				kontrahent.setKli_kontrahenciid(pobierzKontrahenta.kli_kontrahenciid);
				kontrahent.setKodpocztowy(pobierzKontrahenta.kodpocztowy);
				kontrahent.setLogo(pobierzKontrahenta.logo);
				kontrahent.setMiejscowosc(pobierzKontrahenta.miejscowosc);
				kontrahent.setNazwa1(pobierzKontrahenta.nazwa1);
				kontrahent.setNazwa2(pobierzKontrahenta.nazwa2);
				kontrahent.setNip(pobierzKontrahenta.nip);
				kontrahent.setNrdomu(pobierzKontrahenta.nrdomu);
				kontrahent.setNrlokalu(pobierzKontrahenta.nrlokalu);
				kontrahent.setRegon(pobierzKontrahenta.regon);
				kontrahent.setTypulicy(pobierzKontrahenta.typulicy);
				kontrahent.setUlica(pobierzKontrahenta.ulica);
				kontrahent.setStr_logo(pobierzKontrahenta.str_logo);
			</cfscript>
			
			<cfset kontrahentDAO.create(kontrahent) />
		</cfif>
		
		<cfif isDefined( "params.documentinstance.file" ) AND Len( params.documentinstance.file ) and Len( kontrahent.getLogo() )> <!--- Plik został zapisany na dysku. Teraz mogę go przenieść do odpowiedniego katalogu --->
			
			<!--- Tworzę katalog dla faktur z danego miasiąca --->
			<cfif not directoryExists( ExpandPath( "faktury/#DateFormat(Now(), 'yyyy')#/#DateFormat(Now(), 'mm')#" ) )>
				<cfset directoryCreate( expandPath( "faktury/#DateFormat(Now(), 'yyyy')#/#DateFormat(Now(), 'mm')#" ) ) />
			</cfif>
			
			<!--- Tworzę katalog dla tymczasowych faktur --->
			<cfif not directoryExists( ExpandPath( "faktury_tmp" ) )>
				<cfset directoryCreate( expandPath( "faktury_tmp" ) ) />
			</cfif>
			
			<!--- Przenosze plik do tymczasowej lokalizacji --->
			<cffile action="move" destination="#ExpandPath( 'faktury_tmp/#params.documentinstance.file#' )#" source="#ExpandPath( 'files/#params.documentinstance.file#' )#" />
			
			<!--- OCR pliku PDF z fakturą --->
			<cfpdf action="extracttext" source="#ExpandPath( 'faktury_tmp/#params.documentinstance.file#' )#" pages="*" honourspaces="false" type="string" name="ocrFaktury" />
			
			<cflock scope="Application" timeout="30" >
				<!--- Generuje kolejny numer faktury --->
				<cfset var numerFaktury = "P/#Year(Now())#/#DateFormat(Now(),'mm')#/#NumberFormat(Application.workflowDocumentNumber, '00009')#" />
				<cfset var nazwaPliku = replace(numerFaktury, "/", "_", "ALL") />
				
				<cfset Application.workflowDocumentNumber = Application.workflowDocumentNumber + 1 />
				<cfset var nowyLicznikFaktur = model("workflowSetting").aktualizujNumerFaktury() />
				
			</cflock>
			
			<cffile action="move" destination="#ExpandPath( 'faktury/#DateFormat(Now(), 'yyyy')#/#DateFormat(Now(), 'mm')#/#nazwaPliku#.pdf' )#" source="#ExpandPath( 'faktury_tmp/#params.documentinstance.file#' )#" />
			
			<cfset var delegacja = 0 />
			<cfif StructKeyExists(params, "delegation")>
				<cfset delegacja = 1 />
			</cfif>
			
			<cfset var dokument = createObject("component", "cfc.models.Dokument") />
			<cfscript>
				dokument.setDocumentname(numerFaktury);
				dokument.setDocumentcreated(Now());
				dokument.setUserid(session.user.id);
				dokument.setContractorid(kontrahent.getId());
				dokument.setDelegation(delegacja);
				dokument.setHrdocumentvisible(1);
				dokument.setTypeid(0);
				dokument.setCategoryid(0);
				dokument.setArchiveid(0);
				dokument.setPaid(0);
				dokument.setSys("");
				dokument.setToDelete(0);
				dokument.setDocument_ocr(reReplace(ocrFaktury, '[[:space:]]', '', 'ALL'));
				dokument.setDocument_file_name("faktury/#DateFormat(Now(), 'yyyy')#/#DateFormat(Now(), 'mm')#/#nazwaPliku#.pdf");
				dokument.setDocument_src("faktury/#DateFormat(Now(), 'yyyy')#/#DateFormat(Now(), 'mm')#");
				dokument.setNoDocumentInstances(4);
			</cfscript>
			
			<cfset var nowyDokument = dokumentDAO.create(dokument) />
			
			<cfif nowyDokument.success is true>
				
				<cfset var atrybutDokumentuDAO = createObject("component", "cfc.models.AtrybutDokumentuDAO").init(get('loc').datasource.intranet) />
				
				<!--- Tutaj dodaję atrybuty dokumentu --->
				<cfloop collection="#params.documentinstanceattribute#" item="i" >
					<cfif #params.documentinstanceattribute[i]# eq 100>
						
						<cfset var ad = createObject("component", "cfc.models.AtrybutDokumentu") />
						<cfscript>
							ad.setDocumentattributeid(params.documentinstanceattribute[i]);
							ad.setDocumentid(dokument.getId());
							ad.setDocumentattributetextvalue(dokument.getDocumentname());
							ad.setAttributeid(i);
							ad.setDocumentinstanceid(-1);
						</cfscript>
						<cfset atrybutDokumentuDAO.create(ad) />
						
					<cfelse>
						
						<!--- Jeśli atrybutem jest pole tekstowe --->
						<cfif (#params.documentinstanceattributetype[i]# is 1) or
								(#params.documentinstanceattributetype[i]# is 2) or
								(#params.documentinstanceattributetype[i]# is 4)>
							
							<cfset var ad = createObject("component", "cfc.models.AtrybutDokumentu") />
							<cfscript>
								ad.setDocumentid(dokument.getId());
								ad.setAttributeid(i);
								ad.setDocumentattributeid(params.documentinstanceattribute[i]);
								ad.setDocumentattributetextvalue(params.documentinstanceattributevalue[i]);
								ad.setDocumentinstanceid(-1);
							</cfscript>
							<cfset atrybutDokumentuDAO.create(ad) />
	
						</cfif>
								
					</cfif>
				</cfloop>
				<!--- /Tutaj dodaję atrybuty dokumentu --->
					
				<!--- Tutaj rozpoczynam obieg dokumentu --->
				<!--- Tworzę workflow dokumentu i przekierowuje na stronę dodawania nowego dokumentu --->
				<cfset workflow = model("workflow").new() />
				<cfset workflow.userid = session.userid />
				<cfset workflow.documentid = dokument.getId() />
				<cfset workflow.workflowcreated = dokument.getDocumentcreated() />
				<cfset workflow.save()>

				<!--- Tworzę pierwszy krok obiegu dokumentów --->
				<cfset loc.token = CreateUUID() /> <!--- unikalny token dokumentu --->
				<cfset workflowstep = model("workflowStep").new() />
				<cfset workflowstep.workflowstepcreated = dokument.getDocumentcreated() />
				<cfset workflowstep.userid = params.workflow.userid />
				<cfset workflowstep.workflowstatusid = 1 /> <!--- w trakcie --->
				<cfset workflowstep.workflowstepstatusid = 1 /> <!--- opisywanie --->
				<cfset workflowstep.workflowid = workflow.id />
				<cfset workflowstep.documentid = dokument.getId() />
				<cfset workflowstep.token = loc.token />
				<cfset workflowstep.save() />
				<!--- /Tutaj rozpoczynam obieg dokumentu --->
				
				<cfset redirectTo(controller="Documents",action="add",success="Twój numer faktury to #dokument.getDocumentname()#") />
				
			<cfelse>
				<cffile action="delete" file="#ExpandPath( 'faktury/#DateFormat(Now(), 'yyyy')#/#DateFormat(Now(), 'mm')#/#nazwaPliku#.pdf' )#" />
				<cfset redirectTo(controller="Documents",action="add",error="Wystąpił problem z dodaniem dokumentu do obiegu.") />
			</cfif>
			
		<cfelse>
			<cfset redirectTo(controller="Documents",action="add",error="Wystąpił problem z dodaniem dokumentu do obiegu.") />
		</cfif>

		<!---
		
		<!---
		Sprawdzam czy istnieje faktura o takim numerze

		12.06.2012
		Opcja została usunięta. Teraz numer faktury jest widoczny dopiero po jej dodaniu do systemu.
		--->
		<!---
		<cfset invoicenumber = model("documentAttributeValue").count(where="documentattributetextvalue='#params.documentinstanceattributevalue[100]#'") />

		<cfif invoicenumber neq 0>

			<cfset redirectTo(controller="Documents",action="add",error="Istnieje już dokument o wskazanym numerze Intranetowym. Proszę spróbować ponownie.") />

		</cfif>
		--->
		<!--- Koniec sprawdzania, czy istnieje faktura o takim numerze --->

		<!--- Nawet jeśli plik nie został wybrany, to sprawdzam czy istnieje Kontrahent w bazie --->

<!--- 		<cfdump var="#params#" /> --->
<!--- 		<cfabort /> --->

		
		<cfset contractor = model("contractor").findOne(where="nip='#params.contractor.nip#' AND internalid=#params.contractor.internalid# AND nazwa1 = '#params.contractor.nazwa1#'") />

		<cfif not IsObject(contractor)> <!--- Jeśli taki Kontrahent nie istnieje to go dodaje --->
			<cfset contractor = model("contractor").create(params.contractor) />
		</cfif>

		<!--- Koniec sprawdzania, czy istnieje Kontrahent --->

		<!--- Sprawdzam czy plik został zapisany na dysku --->
		<cfif Len(params.documentinstance.file)>

			<!--- Struktura przechowująca instancje dokumentu --->
			<cfset loc.documentinstance = {} />

			<!--- Pobieram binaria pliku pdf --->
			<!---<cfset loc.documentinstance.documentcontent = FileToBinary(source=ExpandPath("files/#params.documentinstance.file#")) />--->

			<cfset loc.documentinstance.documentfilename = params.documentinstance.file/>

			<!--- Sprawdzam, czy została już utworzona miniaturka pliku --->
			<cfif (Len(params.documentinstance.thumbnail) AND (FileExists(ExpandPath("files/documents/#params.documentinstance.thumbnail#"))))>
				<!---<cfset loc.documentinstance.documentthumbnail = FIleToBinary(source=ExpandPath("files/documents/#params.documentinstance.thumbnail#")) />--->
				<!---<cfset loc.documentinstance.documentthumbnailname = "#params.documentinstance.thumbnail#" />--->
			<!--- Jeśli nie ma pliku miniaturki to tworzę ją i zwracam binaria --->
			<cfelse>

				<cfset pdfsource = default=ExpandPath('files/') />
				<cfset pdfsource &= params.documentinstance.file />

				<cfset thumbnailsource = default=ExpandPath('files/documents') />
				<cfset loc.prefix = "intranet_#TimeFormat(Now(), 'Hmmssl')#_">

				<!---<cfpdf
					action = "thumbnail"
					source = "#pdfsource#"
					format = "png"
					overwrite = "yes"
					pages = "1"
					resolution= "high"
					imagePrefix = "#loc.prefix#"
					destination = "#thumbnailsource#"
					overridepage ="yes">--->

				<!---<cfset loc.documentinstance.documentthumbnail = FileToBinary(source=ExpandPath("files/documents/#loc.prefix#_page_1.png"))/>--->
				<!---<cfset loc.documentinstance.documentthumbnailname = "#loc.prefix#_page_1.png" />--->

			</cfif> <!--- Koniec sprawdzania i tworzenia miniaturki pliku --->

			<!--- czytam tekst z pliku PDF aby zapisać o w bazie --->
			<cfpdf action = "extracttext" source = "#ExpandPath('files/#params.documentinstance.file#')#" pages = "*" honourspaces = "false" type = "string" name = "ocr" />

			<cfset loc.documentinstance.documentcontentocr = ocr /> <!--- Czytanie teksty z pliku pdf --->

			<!--- Tworzę definicje dokumentu --->
			<cfset document = model("document").new() />
			<cfset document.documentcreated = Now() />
			<cfset document.userid = session.userid />
			<cfset document.noDocumentInstances = 2 />
			<cfset document.contractorid = contractor.id /> <!--- Identyfikator kontrahenta --->

			<cfif StructKeyExists(params, "delegation")><!--- Jeżeli zaznaczono opcję "Faktura do delegacji" --->
				<cfset document.delegation = 1 />
			<cfelse>
				<cfset document.delegation = 0 />
			</cfif>

			<cfset document.save() />

			<!--- Tworzę instancje dokumentu --->
			<cfset documentinstance = model("documentInstance").new() />
			<cfset documentinstance.documentid = document.id />
			<!---<cfset documentinstance.documentcontent = loc.documentinstance.documentcontent />--->
			<cfset documentinstance.documentcontentocr = loc.documentinstance.documentcontentocr />
			<!---<cfset documentinstance.documentthumbnail = loc.documentinstance.documentthumbnail />--->
			<cfset documentinstance.documentfilename = loc.documentinstance.documentfilename />
			<cfset documentinstance.save() />

			<!--- 
				Sprawdzam, czy istnieje instancja dokumentu. Jak jej nie ma 
				to wyrzucam do strony dodawania faktury.
			--->
			<cfif not IsDefined("documentinstance") OR not isStruct(documentinstance) or not IsDefined("documentinstance.id")>
				<cfset redirectTo(controller="documents",action="add",params="errortype=3") />
			</cfif> 
			
			<!---<cfquery name="aktualizacjaNumeruFaktury" datasource="#get('loc').datasource.intranet#">
				start transaction;
					update documents set documentname = <cfqueryparam value="#Application.workflowDocumentNumber#" cfsqltype="cf_sql_varchar" />
					where id = <cfqueryparam value="#document.id#" cfsqltype="cf_sql_integer" />;
				commit;
			</cfquery>--->
			
			<!---<cflock timeout="30" scope="Application" type="exclusive">--->
			<cfloop collection="#params.documentinstanceattribute#" item="i" >
				<cfif #params.documentinstanceattribute[i]# eq 100>
					<cflock timeout="30" scope="Application" type="exclusive">
					
						<cfset loc.documentname = "P/#Year(Now())#/#DateFormat(Now(),'mm')#/#NumberFormat(Application.workflowDocumentNumber, '00009')#" />
						<cfset documentattributevalue = model("documentAttributeValue").new()>
						<cfset documentattributevalue.documentid = document.id>
						<cfset documentattributevalue.attributeid = i>
						<cfset documentattributevalue.documentattributeid = params.documentinstanceattribute[i]>
						<cfset documentattributevalue.documentattributetextvalue = loc.documentname />
						<cfset documentattributevalue.documentinstanceid = documentinstance.id>
						<cfset documentattributevalue.save()>
						
						<!--- Tak się nie robi... To trzeba przenieść do modelu. Nie może być SQLi w kontrolerach. Od tego są modele!!! --->
						<cfset var nazwaPliku = replace(loc.documentname, "/", "_", "ALL") />
						<cfquery name="aktualizacjaNumeruFaktury" datasource="#get('loc').datasource.intranet#">
							start transaction;
								update documents set 
									documentname = <cfqueryparam value="#loc.documentname#" cfsqltype="cf_sql_varchar" />,
									document_file_name = <cfqueryparam value="faktury/#DateFormat(Now(), 'yyyy')#/#DateFormat(Now(), 'mm')#/#nazwaPliku#.pdf" cfsqltype="cf_sql_varchar" />,
									document_src = <cfqueryparam value="faktury/#DateFormat(Now(), 'yyyy')#/#DateFormat(Now(), 'mm')#" cfsqltype="cf_sql_varchar" />,
									document_ocr = <cfqueryparam value="#reReplace(ocrFaktury, '[[:space:]]', '', 'ALL')#" cfsqltype="cf_sql_varchar" />
								where id = <cfqueryparam value="#document.id#" cfsqltype="cf_sql_integer" />;
							commit;
						</cfquery>
						<cfset Application.workflowDocumentNumber = Application.workflowDocumentNumber + 1 />
						<cfset nowyLicznikFaktur = model("workflowSetting").aktualizujNumerFaktury() />
						
						<!--- Tutaj będzie przeniesienie pliku faktury i aktualizacja tabeli documents o ścieżkę do pliki i nazwę pliku --->
						
						<cffile action="move" destination="#ExpandPath( 'faktury/#DateFormat(Now(), 'yyyy')#/#DateFormat(Now(), 'mm')#/#nazwaPliku#.pdf' )#" source="#ExpandPath( 'faktury_tmp/#params.documentinstance.file#' )#" />
						
						<!--- Tutaj będzie przeniesienie pliku faktury --->
					</cflock>
					
				<cfelse>
					
					<!--- Jeśli atrybutem jest pole tekstowe --->
					<cfif (#params.documentinstanceattributetype[i]# is 1) or
							(#params.documentinstanceattributetype[i]# is 2) or
							(#params.documentinstanceattributetype[i]# is 4)>

						<cfset documentattributevalue = model("documentAttributeValue").new()>
						<cfset documentattributevalue.documentid = document.id>
						<cfset documentattributevalue.attributeid = i>
						<cfset documentattributevalue.documentattributeid = params.documentinstanceattribute[i]>
						<cfset documentattributevalue.documentattributetextvalue = params.documentinstanceattributevalue[i]>
						<cfset documentattributevalue.documentinstanceid = documentinstance.id>
						<cfset documentattributevalue.save()>

					</cfif>
							
				</cfif>
			</cfloop>
			
			<!---</cflock>--->

				
				<!---
				<cfset numerFaktury = "P/#Year(Now())#/#DateFormat(Now(),'mm')#/#NumberFormat(Application.workflowDocumentNumber, '00009')#" />
				<cfset Application.workflowDocumentNumber = Application.workflowDocumentNumber + 1 />
				<cfset var aktualizacjaNumeruFaktury = "" />
				<cfquery name="aktualizacjaNumeruFaktury" datasource="#get('loc').datasource.intranet#">
					start transaction;
						update workflowsettings set workflowsettingvalue = <cfqueryparam value="#Application.workflowDocumentNumber#" cfsqltype="cf_sql_varchar" />
						where workflowsettingname = <cfqueryparam value="invoice_document_counter" cfsqltype="cf_sql_varchar" />;
						
						update documents set documentname = <cfqueryparam value="#numerFaktury#" cfsqltype="cf_sql_varchar" />
						where id = <cfqueryparam value="#document.id#" cfsqltype="cf_sql_integer" />;
					commit;
				</cfquery>
				--->
			
			<!--- Przechodzę przez wszystkie atrybuty dokumentu --->
			<!---
			<cflock name="dodawanieFaktury#TimeFormat(Now(), 'HHmmssl')#" type="exclusive" timeout="10" >
				
			<cfloop collection="#params.documentinstanceattribute#" item="i">

				<!---
				12.06.2012
				Jeśli atrybutem jest numer faktury to generuje go sam
				--->
				<cfif #params.documentinstanceattribute[i]# eq 100>
					
					<cfset invoicenumber = model("workflowSetting").pobierzNumerFaktury() />
					<!---<cfset invoicenumber = model("workflowSetting").findOne(where="workflowsettingname='invoicenumber'") />--->
					
					<cfset loc.documentname = "P/#Year(Now())#/#DateFormat(Now(),'mm')#/#NumberFormat(invoicenumber.nrfakt, '00009')#" />

					<cfset documentattributevalue = model("documentAttributeValue").new()>
					<cfset documentattributevalue.documentid = document.id>
					<cfset documentattributevalue.attributeid = i>
					<cfset documentattributevalue.documentattributeid = params.documentinstanceattribute[i]>
					<cfset documentattributevalue.documentattributetextvalue = loc.documentname />
					<cfset documentattributevalue.documentinstanceid = documentinstance.id>
					<cfset documentattributevalue.save()>

				<cfelse>

					<!--- Jeśli atrybutem jest pole tekstowe --->
					<cfif (#params.documentinstanceattributetype[i]# is 1) or
							(#params.documentinstanceattributetype[i]# is 2) or
							(#params.documentinstanceattributetype[i]# is 4)>

						<cfset documentattributevalue = model("documentAttributeValue").new()>
						<cfset documentattributevalue.documentid = document.id>
						<cfset documentattributevalue.attributeid = i>
						<cfset documentattributevalue.documentattributeid = params.documentinstanceattribute[i]>
						<cfset documentattributevalue.documentattributetextvalue = params.documentinstanceattributevalue[i]>
						<cfset documentattributevalue.documentinstanceid = documentinstance.id>
						<cfset documentattributevalue.save()>

					</cfif>

				</cfif>

			</cfloop>
			
			</cflock>
			--->

			<!---
				Usuwam niepotrzebne pliki z dysku serwera

				15.05.2013
				Pliki są jednak potrzebne aby system nie musiał ich
				generować ponownie. Przy otwarciu dokumentu.
			--->
			<!---<cffile
				action = "delete"
				file = "#ExpandPath('files/#params.documentinstance.file#')#" />--->

			<!---
				15.05.2013
				Miniaturkę też zostawie aby nie tworzyć jej ponownie.
			--->
			<!---<cffile
				action = "delete"
				file = "#ExpandPath('files/documents/#loc.documentinstance.documentthumbnailname#')#" />--->

			<!--- Tworzę workflow dokumentu i przekierowuje na stronę dodawania nowego dokumentu --->
			<cfset workflow = model("workflow").new() />
			<cfset workflow.userid = session.userid />
			<cfset workflow.documentid = document.id />
			<cfset workflow.workflowcreated = Now() />
			<cfset workflow.save()>

			<!--- Tworzę pierwszy krok obiegu dokumentów --->
			<cfset loc.token = CreateUUID() /> <!--- unikalny token dokumentu --->
			<cfset workflowstep = model("workflowStep").new() />
			<cfset workflowstep.workflowstepcreated = Now() />
			<cfset workflowstep.userid = params.workflow.userid />
			<cfset workflowstep.workflowstatusid = 1 /> <!--- w trakcie --->
			<cfset workflowstep.workflowstepstatusid = 1 /> <!--- opisywanie --->
			<cfset workflowstep.workflowid = workflow.id />
			<cfset workflowstep.documentid = document.id />
			<cfset workflowstep.token = loc.token />
			<cfset workflowstep.save() />

			<!--- Dodaję wpis do tabeli w mailami do wysłania --->
			<cfset workflowtosendmail = model("workflowtosendmail").new() />
			<cfset workflowtosendmail.userid = params.workflow.userid />
			<cfset workflowtosendmail.workflowid = workflow.id />
			<cfset workflowtosendmail.workflowstepstatusid = workflowstep.workflowstepstatusid />
			<cfset workflowtosendmail.workflowtosendmailcreated = Now() />
			<cfset workflowtosendmail.workflowstepid = workflowstep.id />
			<cfset workflowtosendmail.workflowtosendmailtoken = loc.token />
			<cfset workflowtosendmail.save() />

			<cfset redirectTo(controller="Documents",action="add",success="Twój numer faktury to #loc.documentname#") />

		<cfelse>

			<cfset redirectTo(controller="Documents",action="add",error="Wystąpił problem z dodaniem dokumentu do obiegu.") />

		</cfif> <!--- Koniec obrabiania przesłanego na serwer pliku --->
		
		--->
	</cffunction>

	<!---
	view
	---------------------------------------------------------------------------------------------------------------
	Metoda pokazująca podgląd dokumentu.
	Widok pokazuje wszystkie informacje, które były wpisane w formularzu dodawania dokumentu.
	Argumentem przesyłanym do funkcjo w URLu jest ID obiegu dokumentów. Na tej podstawie wyciągany jest
	ID samego dokumentu.
	--->

	<cffunction name="view" hint="Podgląd dokumentu o podanym ID">

		<cfset workflow = model("workflow").findAll(where="id=#params.key#",select="documentid,id") />
		<cfset document = model("document").findOne(select="contractorid",where="id=#workflow.documentid#") />

		<cfset workflowstep = model("workflowStep").findAll(where="workflowid=#params.key# AND workflowstatusid=1 AND userid=#session.userid#",include="workflow,workflowStepStatus,document(documentInstance)")>

		<cfset documentattributes = model("documentAttributeValue").findAll(select="documentid,attributename,documentattributetextvalue,attributeid",include="attribute,documentAttribute",where="documentid=#workflow.documentid# AND documentattributevisible=1")>

		<!--- Notatka merytoryczna faktury --->
		<cfset workflowstepdecreenote = model("workflowStep").findAll(select="workflowstepnote",where="workflowid=#params.key# AND workflowstepstatusid=1 AND workflowstepended is not null",order="workflowstepcreated desc",maxRows=1) />

		<!--- Pobieranie Kontrahenta, który wystawił fakturę --->
		<cfset contractor = model("contractor").findOne(where="id=#document.contractorid#") />

		<cfset workflowstepdescription = model("workflowStepDescription").findAll(where="workflowid=#params.key#",include="project,mpk")/>

		<cfif IsAjax()>

			<cfset renderWith(data="documentattributes,workflowstep,workflowstepdecreenote,contractor,workflowstepdescription",layout=false) />

		</cfif>

	</cffunction>

	<!---
		25.01.2013
		Zoptymalizowałem sposób pobierania plików PDF. Jeżeli plik istnieje na dysku,
		pobieram plik z dysku. Jak pliku nie ma, zapisuje go na dysku i zwracam PDF.
	--->
	<cffunction name="getDocument" output="false" access="public" hint="Pobieram dokument z obiegu.">
		<cfsetting requesttimeout="30" />
		
		<cfset var dokumentDAO = createObject("component", "cfc.models.DokumentDAO").init(get('loc').datasource.intranet) />
		<cfset var dokument = createObject("component", "cfc.models.Dokument") />
		<cfset dokument.setId(params.key) />
		
		<cfset dokumentDAO.read(dokument) />
		
		<cfif Len( dokument.getSys() ) and dokument.getSys() EQ 'AUT' >
			
			<cflocation url="#dokument.getDocument_file_name()#" addtoken="false" />
			
		<cfelse>
			
			<cfif fileExists( ExpandPath( dokument.getDocument_file_name() ) ) >
				<cflocation url="#dokument.getDocument_file_name()#" addtoken="false" />
			<cfelse>
				
				<cflocation url="index.cfm?controller=documents&action=brak-dokumentu&idDokumentu=#params.key#" addtoken="false" />
				
			</cfif>
				
		</cfif>

	</cffunction>
	
	<cffunction name="brakDokumentu" output="false" access="public" hint="">
		<cfset var dokumentDAO = createObject("component", "cfc.models.DokumentDAO").init(get('loc').datasource.intranet) />
		<cfset dokument = createObject("component", "cfc.models.Dokument") />
		<cfset dokument.setId(URL.idDokumentu) />
		<cfset dokumentDAO.read(dokument) />
	</cffunction>


	<!---
		29.04.2013
		Metoda używana wewnątrz komponentu (metoda prywatna). Zadaniem metody
		jest zwrócenie pliku w wersji binarnej, aby można było go później
		zapisać w bazie.
	--->
	<cffunction
		name="FileToBinary"
		hint="Zwrócenie pliku w formie binarnej."
		returnType="binary"
		access="private" >

		<cfargument name="source" type="string" default="/"/>

			<cfif FileExists(arguments.source)>

				<cffile
					action = "readBinary"
					file = "#arguments.source#"
					variable = "blob">

				<cfreturn blob />

			</cfif>

			<cfreturn false />

	</cffunction>

	<cffunction
		name="invoiceToDelegation"
		hint="Lista faktur do delegacji"
		description="Lista faktur do delegacji. Metoda sprawdza pole delegation w tabeli documents. Opcja jest dostępna dla grupy Dep. personalny">

		<cfset invoices = model("triggerWorkflowStepList").findAll(where="delegation=1 AND hr_documentvisible=1") /> <!--- Pobieram wszystkie faktury, które są fakturami do delegacji --->

	</cffunction>

	<cffunction
		name="hrHideInvoice"
		hint="Ukrycie faktury delegacyjnej na liście faktur widocznych przez Departament Personalny"
		returnFormat="json"
		returnType="any">

		<cfset message = structNew() />
		<cfset delegationinvoice = model('triggerWorkflowStepList').findOne(where="documentid=#params.key# AND delegation=1") />

		<cfif IsObject(delegationinvoice)>

			<cfset delegationinvoice.update(hr_documentvisible=delegationinvoice.hr_documentvisible-1) />
			<cfset message['message'] = 'ok' />
			<cfset message['id'] = delegationinvoice.documentid />

		<cfelse>

			<cfset message['message'] = 'Wystąpił błąd' />

		</cfif>

		<cfset renderWith(message) />

	</cffunction>

	<!---
		28.01.2013
		Edycja atrybutów opisujących dokument w obiegu.
		Aby automatycznie aktualizowały się tabele
		cron_invoicereports i trigger_workflowsearch konieczne było dodanie odpowiedniego
		triggera w bazie.
	--->
	<cffunction name="edit" hint="Edycja dokumentu, który jest w obiegu." description="Metoda pozwalająca na edycję atrybutów dokumentu, który znajduje się w obiegu.">

		<cfset document_attributes = model('document').getDocumentAttributes(documentid = params.key) />

		<cfset documentid = params.key />
		<cfset renderWith(data="document_attributes,documentid",layout=false) />

	</cffunction>

	<cffunction
		name="actionEdit"
		hint="Zapisanie formularza opisującego dokument w obiegu.">

		<cftry>
			
			<cfset rankingGamoni = model("document").rankingBledow(params.key) />

			<cfloop collection="#params.documentattributevalue#" item="i">

				<cfset my_document_attr_val = model("documentAttributeValue").findByKey(i) />
				<cfset my_document_attr_val.documentattributetextvalue = params.documentattributevalue[i] />
				<cfset my_document_attr_val.save(callbacks=false) />

			</cfloop>

			<cfset my_workflow = model("workflow").findOne(where="documentid=#params.key#") />

			<cfset redirectTo(controller="Documents",action="edit",key=params.key) />

			<cfcatch type="any" >
				<cfset redirectTo(controller="Users",action="logIn",error=cfcatch.message) />
			</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="saveTemplate"
		hint="Zapisanie szablonu dokumentu">

		<!---
			30.01.2013
			Definiuje nowy szablon opisywania faktur.
		--->
		<cfset my_template = model("invoice_template").New() />
		<cfset my_template.userid 					=		session.userid />
		<cfset my_template.invoice_template_name 	=		params.template_name />
		<cfset my_template.invoice_template_description = 	params.template_data.workflow.workflowstepnote />
		<cfset my_template.save(callbacks=false) />

		<!---
			Mając zapisaną definicje szablonu z opisem faktury, zapisuje
			kolejne pozycje opisujące dokument.
		--->

		<!---
			Przechodzę w pętli przez wszystkie elementy opiujące
			fakturę (tabelka mpk, projekt).
		--->
		<cfif structKeyExists(params.template_data, "workflow") and
				structKeyExists(params.template_data.workflow, "table") >

			<cfset invoice_table = params.template_data.workflow.table />

			<!---
				Główna pętla zapisująca kolejne wiersze szablonu
			--->
			<cfloop collection="#invoice_table#" item="i" >

				<cfset loc.descriptionrow = {} />

				<!---
					Skoro tabelka jest przesłana to pobieram pobieram identyfikatory
					mpków i projektów. Jeżeli nie ma jakiegoś mpku i projektu w
					lokalnej bazie intranetu to od razu go dodaje.
				--->

				<!--- Dodaje/aktualizuje MPKi i Projekty --->
				<cfset tmp = invoice_table[i] />
				<cfset tmpproject = ListToArray(tmp.project, "-") /> <!--- W pierwszym indeksie tabeli znajduje się nazwa projektu --->

				<!---
					Aby móc zaktualizować projekt w bazie muszę zdekodować
					jego nazwę i opis.
					W pierwszym wierszu mam p_nazwa, w drugim p_opis.
				--->
				<cfset tmpproject_desc = ListToArray(tmpproject[2], ";") />

				<cfset tmpmpk = ListToArray(tmp.mpk, "-") /> <!--- W pierwszym indeksie znajduje się numer mpk --->

				<!--- Wyszukuje projekt po nazwie z tabeli projects w intranecie --->
				<cfset project = model("project").findOne(where="projekt='#tmpproject[1]#' AND p_nazwa like '%#Trim(tmpproject_desc[1])#%' AND p_opis like '%#Trim(tmpproject_desc[2])#%'") /> <!--- Projekt --->

				<cfset mpk = model("mpk").findOne(where="mpk='#tmpmpk[1]#'") /> <!--- MPK --->

				<cfif not IsStruct(project)> <!--- Jeśli projektu nie ma to go dodaje --->
					<cfset singleproject = model("project").getSingleProject(search="#tmpproject[1]#") />
					<cfset singleproject.rows[1].p_opis = singleproject.rows[1].opis />
					<cfset singleproject.rows[1].p_nazwa = singleproject.rows[1].nazwa />
					<cfset newsingleproject = model("project").create(singleproject.rows[1]) /> <!--- Tutaj mają być trzymane dane nowego projektu --->

					<!---
						Zapisuje pojedyńczy wiersz projektu
					--->
					<cfset loc.descriptionrow.projectid		=	newsingleproject.id />
					<cfset loc.descriptionrow.projekt		=	newsingleproject.projekt />
					<cfset loc.descriptionrow.p_nazwa		=	newsingleproject.p_nazwa />
					<cfset loc.descriptionrow.p_opis		=	newsingleproject.p_opis />
					<cfset loc.descriptionrow.miejscerealizacji	=	newsingleproject.miejscerealizacji />

				<cfelse> <!--- Jeśli jest projekt to pobieram jego ID --->

					<cfset loc.descriptionrow.projectid		=	project.id />
					<cfset loc.descriptionrow.projekt		=	project.projekt />
					<cfset loc.descriptionrow.p_nazwa		=	project.p_nazwa />
					<cfset loc.descriptionrow.p_opis		=	project.p_opis />
					<cfset loc.descriptionrow.miejscerealizacji	=	project.miejscerealizacji />

				</cfif>

				<cfif not IsStruct(mpk)> <!--- Jeśli mpku nie ma to go dodaje --->
					<cfset singlempk = model("mpk").getSingleMpk(search="#tmpmpk[1]#") />
					<cfset singlempk.rows[1].m_opis = singlempk.rows[1].opis />
					<cfset singlempk.rows[1].m_nazwa = singlempk.rows[1].nazwa />
					<cfset newsinglempk = model("mpk").create(singlempk.rows[1]) /> <!--- Tutaj mają być trzymane dane nowego projektu --->

					<!---
						Zapisuje pojedynczy wiersz mpku.
					--->
					<cfset loc.descriptionrow.mpkid		=	newsinglempk.id />
					<cfset loc.descriptionrow.m_nazwa	=	newsinglempk.m_nazwa />
					<cfset loc.descriptionrow.mpk		=	newsinglempk.mpk />

				<cfelse> <!--- Jeśli jest mpk to pobieram jego ID --->

					<cfset loc.descriptionrow.mpkid		=	mpk.id />
					<cfset loc.descriptionrow.m_nazwa	=	mpk.m_nazwa />
					<cfset loc.descriptionrow.mpk		=	mpk.mpk />

				</cfif>
				<!--- Koniec dodawania/aktualizacji --->

				<!---
					Tutaj odbywa się właściwe zapisanie wiersza szablonu
				--->

				<cfset loc.descriptionrow.price = tmp.price />
				<cfset loc.descriptionrow.invoicetemplateid = my_template.id />
				<cfset my_templace_description = model("invoice_template_document_description").create(loc.descriptionrow) />

			</cfloop>
			<!---
				Koniec głównej pętli zapisującej kolejne wiersze szablonu
			--->

		</cfif>

	</cffunction>

	<cffunction
		name="getUserTemplates"
		hint="Metod pobierająca listę aktualnych szablonów użytkownika.">

		<cfset my_templates = model("invoice_template").getUserTemplates(userid = session.userid) />

	</cffunction>

	<cffunction
		name="getTemplate"
		hint="Pobranie wszystkich pól szablonu i zwrócenie JSON">

		<cfset my_template = model("invoice_template_document_description").findAll(where="invoicetemplateid=#params.key#") />

		<cfset tmp = model("invoice_template_document_description").QueryToStruct(Query=my_template) />

		<cfset decree_note = model("invoice_template").findByKey(params.key) />
		<cfset template = structNew() />
		<cfset template = {
			templateid = params.key,
			decree_note = decree_note.invoice_template_description } />

		<cfset structAppend(tmp, template) />

		<cfset renderWith(data=tmp,layout=false) />

	</cffunction>

	<cffunction
		name="updateUserTemplate"
		hint="Aktualizacja szablonu użytkownika">

		<!---
			Pobieram szablon aby zaktualizować w nim opis.
		--->
		<cfset my_template = model('invoice_template').findByKey(params.template_id) />
		<cfset my_template.invoice_template_description = params.template_data.workflow.workflowstepnote />
		<cfset my_template.save(callbacks=false) />

		<!---
			Teraz usuwam wszystkie linijki aktualnego szablonu aby później dodać je raz jeszcze.
		--->
		<cfset my_template_descriptions = model("invoice_template_document_description").deleteAll(where="invoicetemplateid=#my_template.id#",instantiate=false) />

		<!---
			Teraz dodaje wszystkie opisy.
		--->
		<!---
			Przechodzę w pętli przez wszystkie elementy opiujące
			fakturę (tabelka mpk, projekt).
		--->
		<cfif structKeyExists(params.template_data, "workflow") and
				structKeyExists(params.template_data.workflow, "table") >

			<cfset invoice_table = params.template_data.workflow.table />

			<!---
				Główna pętla zapisująca kolejne wiersze szablonu
			--->
			<cfloop collection="#invoice_table#" item="i" >

				<cfset loc.descriptionrow = {} />

				<!---
					Skoro tabelka jest przesłana to pobieram pobieram identyfikatory
					mpków i projektów. Jeżeli nie ma jakiegoś mpku i projektu w
					lokalnej bazie intranetu to od razu go dodaje.
				--->

				<!--- Dodaje/aktualizuje MPKi i Projekty --->
				<cfset tmp = invoice_table[i] />
				<cfset tmpproject = ListToArray(tmp.project, "-") /> <!--- W pierwszym indeksie tabeli znajduje się nazwa projektu --->

				<!---
					Aby móc zaktualizować projekt w bazie muszę zdekodować
					jego nazwę i opis.
					W pierwszym wierszu mam p_nazwa, w drugim p_opis.
				--->
				<cfset tmpproject_desc = ListToArray(tmpproject[2], ";") />

				<cfset tmpmpk = ListToArray(tmp.mpk, "-") /> <!--- W pierwszym indeksie znajduje się numer mpk --->

				<!--- Wyszukuje projekt po nazwie z tabeli projects w intranecie --->
				<cfset project = model("project").findOne(where="projekt='#tmpproject[1]#' AND p_nazwa like '%#Trim(tmpproject_desc[1])#%' AND p_opis like '%#Trim(tmpproject_desc[2])#%'") /> <!--- Projekt --->

				<cfset mpk = model("mpk").findOne(where="mpk='#tmpmpk[1]#'") /> <!--- MPK --->

				<cfif not IsStruct(project)> <!--- Jeśli projektu nie ma to go dodaje --->
					<cfset singleproject = model("project").getSingleProject(search="#tmpproject[1]#") />
					<cfset singleproject.rows[1].p_opis = singleproject.rows[1].opis />
					<cfset singleproject.rows[1].p_nazwa = singleproject.rows[1].nazwa />
					<cfset newsingleproject = model("project").create(singleproject.rows[1]) /> <!--- Tutaj mają być trzymane dane nowego projektu --->

					<!---
						Zapisuje pojedyńczy wiersz projektu
					--->
					<cfset loc.descriptionrow.projectid		=	newsingleproject.id />
					<cfset loc.descriptionrow.projekt		=	newsingleproject.projekt />
					<cfset loc.descriptionrow.p_nazwa		=	newsingleproject.p_nazwa />
					<cfset loc.descriptionrow.p_opis		=	newsingleproject.p_opis />
					<cfset loc.descriptionrow.miejscerealizacji	=	newsingleproject.miejscerealizacji />

				<cfelse> <!--- Jeśli jest projekt to pobieram jego ID --->

					<cfset loc.descriptionrow.projectid		=	project.id />
					<cfset loc.descriptionrow.projekt		=	project.projekt />
					<cfset loc.descriptionrow.p_nazwa		=	project.p_nazwa />
					<cfset loc.descriptionrow.p_opis		=	project.p_opis />
					<cfset loc.descriptionrow.miejscerealizacji	=	project.miejscerealizacji />

				</cfif>

				<cfif not IsStruct(mpk)> <!--- Jeśli mpku nie ma to go dodaje --->
					<cfset singlempk = model("mpk").getSingleMpk(search="#tmpmpk[1]#") />
					<cfset singlempk.rows[1].m_opis = singlempk.rows[1].opis />
					<cfset singlempk.rows[1].m_nazwa = singlempk.rows[1].nazwa />
					<cfset newsinglempk = model("mpk").create(singlempk.rows[1]) /> <!--- Tutaj mają być trzymane dane nowego projektu --->

					<!---
						Zapisuje pojedynczy wiersz mpku.
					--->
					<cfset loc.descriptionrow.mpkid		=	newsinglempk.id />
					<cfset loc.descriptionrow.m_nazwa	=	newsinglempk.m_nazwa />
					<cfset loc.descriptionrow.mpk		=	newsinglempk.mpk />

				<cfelse> <!--- Jeśli jest mpk to pobieram jego ID --->

					<cfset loc.descriptionrow.mpkid		=	mpk.id />
					<cfset loc.descriptionrow.m_nazwa	=	mpk.m_nazwa />
					<cfset loc.descriptionrow.mpk		=	mpk.mpk />

				</cfif>
				<!--- Koniec dodawania/aktualizacji --->

				<!---
					Tutaj odbywa się właściwe zapisanie wiersza szablonu
				--->

				<cfset loc.descriptionrow.price = tmp.price />
				<cfset loc.descriptionrow.invoicetemplateid = my_template.id />
				<cfset my_templace_description = model("invoice_template_document_description").create(loc.descriptionrow) />

			</cfloop>

		</cfif>

	</cffunction>

	<cffunction
		name="deleteTemplate"
		hint="Usunięcie szablonu faktury">

		<cfset my_template = model("invoice_template").deleteAll(where="id=#params.key#") />
		<cfset my_template_details = model("invoice_template_document_description").deleteAll(where="invoicetemplateid=#params.key#") />

	</cffunction>

	<cffunction name="setDocumentCategory" hint="Ustawienie typu dokumentu">

		<cfset json = model("document").updateAll(
			categoryid = params.categoryid,
			where="id=#params.documentid#") />

		<cfset renderWith(data="json",template="json",layout=false) />

	</cffunction>
	
	<cffunction name="changeContractor" output="false" access="public" hint="">
		<cfset dokument = "" />
		<cfif IsDefined("URL.documentid")>
			<cfset dokument = model("workflow").pobierzInformacjeOFakturze(URL.documentid) />
		</cfif>
		
		<cfif IsDefined("FORM.FIELDNAMES") and IsDefined("FORM.IDKONTRAHENTA")>
			<cfset var kontrahenciGateway = createObject("component", "cfc.models.KontrahenciGateway").init(get("loc").datasource.intranet) />
			<cfset var kontrahent = kontrahenciGateway.pobierzKontrahentaPoLogo(FORM.LOGOKONTRAHENTA) />

			<cfif not Len( kontrahent.getLogo() )> <!--- Jeżeli kontrahent nie jest zdefiniowany to nie mam jego LOGO --->
				<cfset var abs = createObject("component", "cfc.models.AssecoGateway").init(get("loc").datasource.asseco) />
				<cfset var pobierzKontrahenta = abs.szukajKontrahenta(text = FORM.LOGOKONTRAHENTA) />
				<cfset var kontrahentDAO = createObject("component", "cfc.models.KontrahentDAO").init(get("loc").datasource.intranet) />
				
				<cfscript>
					
					if ( Len( pobierzKontrahenta.dzielnica ) )
						kontrahent.setDzielnica(pobierzKontrahenta.dzielnica);
					else
						kontrahent.setDzielnica("");
						
					kontrahent.setInternalid(pobierzKontrahenta.internalid);
					kontrahent.setKli_kontrahenciid(pobierzKontrahenta.kli_kontrahenciid);
					kontrahent.setKodpocztowy(pobierzKontrahenta.kodpocztowy);
					kontrahent.setLogo(pobierzKontrahenta.logo);
					kontrahent.setMiejscowosc(pobierzKontrahenta.miejscowosc);
					kontrahent.setNazwa1(pobierzKontrahenta.nazwa1);
					kontrahent.setNazwa2(pobierzKontrahenta.nazwa2);
					kontrahent.setNip(pobierzKontrahenta.nip);
					kontrahent.setNrdomu(pobierzKontrahenta.nrdomu);
					kontrahent.setNrlokalu(pobierzKontrahenta.nrlokalu);
					kontrahent.setRegon(pobierzKontrahenta.regon);
					kontrahent.setTypulicy(pobierzKontrahenta.typulicy);
					kontrahent.setUlica(pobierzKontrahenta.ulica);
					kontrahent.setStr_logo(pobierzKontrahenta.logo);
				</cfscript>
				
				<cfset kontrahentDAO.create(kontrahent) />
			</cfif>
			
			<cfset dokument = model("document").zmienKontrahenta(documentid=FORM.DOCUMENTID,contractorid=kontrahent.getId()) />
		</cfif>
		
		<cfset renderWith(data="dokument",layout=false) />
	</cffunction>
	
	<cffunction name="documentAttachment" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			
			<cfif structKeyExists(FORM, "file") and len(FORM.file)>
				<cfset myFile = APPLICATION.cfc.upload.SetDirName(dirName="attachments") />
				<cfset myFile = APPLICATION.cfc.upload.upload(file_field="file") />
	
				<cfset newDoc = model("document_attachment").new() />
				<cfset newDoc.file_src = myFile.NEWSERVERNAME />
				<cfset newDoc.userid = session.user.id />
				<cfset newDoc.documentid = FORM.documentid />
				<cfset newDoc.komentarz = FORM.komentarz />
				<cfset newDoc.data_dodania = Now() />
				<cfset newDoc.created = Now() />
				<cfset newDoc.save(callbacks=false) />
				
			</cfif>
		</cfif>
		
		<cfset pliki = model("document_attachment").pobierzPliki(URL.documentid) />
		
		<cfset documentid = URL.documentid />
		<cfset usesLayout(false) />
		<!---<cfset usesLayout(template="/layout_cfwindow") />--->
		
	</cffunction>
	
	<cffunction name="documentAttachmentPreview" output="false" access="public" hint="">
		<cfif IsDefined("URL.fileid")>
			<cfset var plik = model("document_attachment").pobierzPlikPoId(URL.fileid) />
			<!---
				Aby pokazać zawartość pliku Excela w okienku, musze najpierw
				sprawdzić, czy jest to plik Excela. Sprawdzanie odbywa się
				poprzez porównanie rozszerzenia.
			--->
			<cfif findNoCase(".xls", plik.file_src) NEQ 0>
				<cfspreadsheet action="read" src="#expandPath('files/attachments/#plik.file_src#')#" query="excelQueryData" /> 
			</cfif>
			
			
		</cfif>
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="iframe" output="false" access="public" hint="">
		<cfset documentid = URL.documentid />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="documentAttachmentForm" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			
			<cfif structKeyExists(FORM, "file") and len(FORM.file)>
				<cfset myFile = APPLICATION.cfc.upload.SetDirName(dirName="attachments") />
				<cfset myFile = APPLICATION.cfc.upload.upload(file_field="file") />
	
				<cfset newDoc = model("document_attachment").new() />
				<cfset newDoc.file_src = myFile.NEWSERVERNAME />
				<cfset newDoc.userid = session.user.id />
				<cfset newDoc.documentid = FORM.documentid />
				<cfset newDoc.komentarz = FORM.komentarz />
				<cfset newDoc.data_dodania = Now() />
				<cfset newDoc.created = Now() />
				<cfset newDoc.save(callbacks=false) />
				
			</cfif>
		</cfif>
		
		<cfset documentid = URL.documentid />
		<cfset usesLayout(template="/layout_cfwindow") />
		
	</cffunction>
	
	<cffunction name="moveToArchive" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			
			<!--- 
				W tabeli workflows w kolumnie to_archive wstawiam 1.
				Na podstawie danych w tej tabelce cyklicznie raz na dobę przenoszę 
				faktury do tabel z przedrostkiem arch_ 
			--->
			<cfset komunikat = model("document_archive").dodajKomunikat(documentid=FORM.documentid,userid=session.user.id,reason=FORM.reason) />
			
			<cfset results = structNew() />
			<cfset results.success = doArchiwum = model("document").przeniesDoArchiwum(FORM.documentid) />
			<cfset results.message = "Faktura została przeniesiona do archiwum" />
			
		</cfif>
		
		<cfset documentid = URL.documentid />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="szukajWArchiwum" output="false" access="public" hint="">
		<cfset json = "" />
		<cfif IsDefined("FORM.SEARCHVALUE")>
			<cfset json = model("document_archive").szukajWArchiwum(FORM.SEARCHVALUE) />
			<cfset json = QueryToStruct(Query=json) />
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
	<cffunction name="markDocumentAsPaid" output="false" access="public" hint="">
		<cfset json = "" />
		<cfif IsDefined("FORM.DOCUMENTID")>
			<cfset json = model("document").markAsPaid(FORM.DOCUMENTID) />
		</cfif>
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>

</cfcomponent>