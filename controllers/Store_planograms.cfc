<cfcomponent
	extends="Controller">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadJS",only="index",type="before") />
		<cfset filters(through="before",type="before") />
	</cffunction>
	
	<cffunction name="loadJS" output="false" access="public" hint="">
		<cfset APPLICATION.bodyImportFiles &= ",store_planograms" />
		<cfset APPLICATION.ajaxImportFiles &= ",initDatePicker,initCfWindow" />
	</cffunction>
	
	<cffunction name="before" output="false" access="public" hint="">
		<cfset usesLayout(template="/layout") />
	</cffunction>
	
	<!---
		Metoda wyświetlająca zdefiniowane planogramy. Planogramy wyszukuje się 
		poprzez filtr po sklepach, regałach.
	--->
	<cffunction name="index" hint="Metoda wyświetlające zdefiniowane planogramy.">
		
		<cfparam name="shelfid" type="numeric" default="0" />
		<cfparam name="location" type="string" default="" />
		<cfparam name="search" type="string" default="" />
		<cfparam name="storetype_id" type="numeric"	default="0" />
			
		<!--- 
			Sprawdzam, czy istnieje zmienna przekazana w sesji.
			
		--->
		<cfif structKeyExists(session, "store_filter") and structKeyExists(session.store_filter, "shelfid")>
			<cfset shelfid = session.store_filter.shelfid />
		</cfif>
		
		<cfif structKeyExists(session, "store_filter") and structKeyExists(session.store_filter, "location")>
			<cfset location = session.store_filter.location />
		</cfif>
		
		<cfif structKeyExists(session, "store_filter") and structKeyExists(session.store_filter, "search")>
			<cfset search = session.store_filter.search />
		</cfif>
		
		<cfif structKeyExists(session, "store_filter") and structKeyExists(session.store_filter, "storetype_id")>
			<cfset storetype_id = session.store_filter.storetype_id /> 
		</cfif>
		
		<!---
			Sprawdzam, czy przekazano zmienną z formularza.
		--->
		<cfif structKeyExists(params, "sheldif")>
			<cfset shelfid = params.shelfid />
		</cfif>
		
		<cfif structKeyExists(params, "search")>
			<cfset search = params.search />
		</cfif>
		
		<cfif structKeyExists(params, "location")>
			<cfset location = params.location />
		</cfif>
		
		<cfif structKeyExists(params, "storetype_id")>
			<cfset storetype_id = params.storetype_id />
		</cfif>
		
		<!---
			Zapisuje filtr w sesji.
		--->
		<cfset session.store_filter = {
			shelfid			=		shelfid,
			location		=		location,
			search			=		search,
			storetype_id 	=		storetype_id} />
		
		<!---
			Pobieram listę możliwych lokalizacji do wyboru
		--->
		<cfset my_locations = model("store_store").getLocalizations() />
		
		<!---
			Pobieram listę regałów do wyboru.
			Lista typów sklepów
			Lista kategorii regałów
			Lista typów regałów
		--->
		<cfset shelfs = model("store_shelf").getDefinedShelfs() />
		<cfset myStoreTypes = model("store_type").getTypes() />
		<cfset myShelfCategories = model("store_shelfcategory").findAll(order="shelfcategoryname ASC") />
		<cfset myShelfTypes = model("store_shelftype").findAll(order="shelftypename ASC") />
		
		
	</cffunction>
	
	<cffunction
		name="getStoreTypeShelfCategory"
		hint="Pobranie kategorii regałów przypisanych do danego typu sklepów">
			
		<cfset myShelfCategories = model("store_shelf").getStoreShelfCategories(
			storetypeid = params.key) />
			
		<cfset renderWith(data="myShelfCategories",layout=false) />
			
	</cffunction>
	
	<cffunction
		name="getShelfCategoryTypes"
		hint="Pobranie typów regałów przypisanych do danego typu sklepu i kategorii regału">
			
		<cfset myShelfTypes = model("store_shelf").getShelfCategoryTypes(
			storetypeid = params.storetypeid,
			shelfcategoryid = params.key) />
	
		<cfset renderWith(data="myShelfTypes",layout=false) />
			
	</cffunction>
	
	<cffunction
		name="shelfPlanograms"
		hint="Lista planogramów przypisana do danego typu i kategorii regału">
			
		<cfset planograms = model("store_planogram").getShelfPlanograms(
			storetypeid = params.storetypeid,
			shelftypeid = params.shelftypeid,
			shelfcategoryid = params.shelfcategoryid) />
		
		<cfset myPlanograms = arrayNew(1) />
		<cfset index = 1 />
		<cfloop query="planograms">
			<cfset myPlanograms[index] = {
				created = created,
				planogramid = planogramid,
				note = note,
				date_from = date_from,
				xls = xls,
				storetypeid = storetypeid,
				shelftypeid = shelftypeid,
				shelfcategoryid = shelfcategoryid,
				files = model("store_planogram").getPlanogramFiles(planogramid=planogramid)
			} />
			<cfset index++ />
		</cfloop>

		<cfset usesLayout(false) />
			
	</cffunction>
	
	<cffunction
		name="shelfStorePlanograms"
		hint="Lista planogramów przypisana do danego typu i kategorii regału">
			
		<cfset planograms = model("store_planogram").getShelfPlanograms(
			storetypeid = params.storetypeid,
			shelftypeid = params.shelftypeid,
			shelfcategoryid = params.shelfcategoryid,
			limit = 2) />
		
		<cfset myPlanograms = arrayNew(1) />
		<cfset index = 1 />
		<cfloop query="planograms">
			<cfset myPlanograms[index] = {
				created = created,
				planogramid = planogramid,
				note = note,
				date_from = date_from,
				xls = xls,
				storetypeid = storetypeid,
				shelftypeid = shelftypeid,
				shelfcategoryid = shelfcategoryid,
				files = model("store_planogram").getPlanogramFiles(planogramid=planogramid)
			} />
			<cfset index++ />
		</cfloop>
		
		<cfif StructKeyExists(params, "layout") and params.layout eq "true">
			<cfset renderWith(data="myPlanograms",template="shelfplanograms") />
		<cfelse>
			<cfset renderWith(data="myPlanograms",template="shelfplanograms",layout=false) />
		</cfif>
			
	</cffunction>
	
	<cffunction
		name="shelfStores"
		hint="Lista sklepów, które mają przypisany dany regał">
	
		<cfset myStores = model("store_storeshelf").getStoresByShelf(
			shelfid = params.shelfid) />
		
		<cfset renderWith(data="myStores",layout=false) />
	
	</cffunction>
	
	<cffunction name="add" hint="Dodawnaie nowego planogramu do systemu">
		
		<cfif IsDefined("FORM.FIELDNAMES") and IsDefined("FORM.FILE0") and IsDefined("FORM.TOTAL_UNITS_FILE") 
			and Len(FORM.FILE0) GT 0 and Len(FORM.TOTAL_UNITS_FILE) GT 0>
			<!---
				Pierwszym etapem zapisywania planogramu jest dodanie jego definicji
				w tabeli store_planograms. Definicja zawiera kto, kiedy i o czym dodał planogram.
				
				25.02.2014
				Zmieniony jest sposób dodawania planogramu. Zmiany są związane z załączaniem
				dodatkowego pliku zawierającego TOTAL UNITS.
			--->
			<cfset newPlanogram = model("store_planogram").create(
				note = params.note,
				created = Now(),
				userid = session.user.id,
				storetypeid = params.storetypeid,
				shelftypeid = params.shelftypeid,
				shelfcategoryid = params.shelfcategoryid,
				index_count = params.index_count,
				date_from = Mid(params.date_from, 7, 4) & "-" & Mid(params.date_from, 4, 2) & "-" & Mid(params.date_from, 1, 2) ) />
			
			<cfset var uploadFile = createObject("component", "cfc.upload2").init(directory="planograms_totalunits",maxSize=4194304) />
			
			<cfif IsDefined("FORM.FILE0") and Len(FORM.FILE0) GT 0>
				
				<cfset uploadFile.setDirectory("planograms") />
				<cfset myFileResults = uploadFile.uploadFile(fileField="file0") />
				
				<cfif IsDefined("myFileResults.SUCCESS") AND myFileResults.SUCCESS is true>
					<cfset newPlanogramFile = model("store_planogramfile").new() />
					<cfset newPlanogramFile.planogramid = newPlanogram />
					<cfset newPlanogramFile.filesrc = myFileResults.NEWSERVERNAME />
					<cfset newPlanogramFile.filename = myFileResults.CLIENTFILENAME & "." & myFileResults.CLIENTFILEEXT />
					<cfset newPlanogramFile.save(callbacks=false) />
				</cfif>
				
			</cfif>
			
			<cfif IsDefined("FORM.TOTAL_UNITS_FILE") AND Len(FORM.TOTAL_UNITS_FILE) GT 0>
				
				<cfset uploadFile.setDirectory("planograms_totalunits") />
				<cfset myExcelResults = uploadFile.uploadFile(fileField="total_units_file") />
			
				<cfif myExcelResults.SUCCESS is true AND IsDefined("newPlanogramFile.id")>
					<cfset newTotalUnitFile = model("store_planogram_totalunit").createFile(
						planogramid = newPlanogram,
						storetypeid = params.storetypeid,
						shelftypeid = params.shelftypeid,
						shelfcategoryid = params.shelfcategoryid,
						userid = session.user.id,
						filedirectory = myExcelResults.SERVERDIRECTORY,
						file = myExcelResults.NEWSERVERNAME
					) />
					
					<cfspreadsheet action="read" query="qxls" src="#myExcelResults.SERVERDIRECTORY#/#myExcelResults.NEWSERVERNAME#" excludeheaderrow="true" headerrow="1"/>
					
					<cfset totalUnitValue = structNew() />
					<cfset var indeks = 1 />
					<cfloop query="qxls">
						<cfset totalUnitValue = model("store_planogram_totalunit").createFileValue(
							planogramid = newPlanogram,
							storetypeid = params.storetypeid,
							shelftypeid = params.shelftypeid,
							shelfcategoryid = params.shelfcategoryid,
							fileid = newTotalUnitFile.id,
							productid = ToString(qxls.PRODUCT_ID),
							upc = ToString(qxls.UPC),
							totalunits = qxls.TOTAL_UNITS,
							prestock = qxls["PRESTOCK (Formula)"][indeks],
							nazwa_produktu = qxls["Name"][indeks],
							zapas_opt = qxls["ZAPAS_OPT (Formula)"][indeks],
							units_case = qxls["Units_Case"][indeks]) />
						<cfset indeks++ />
					</cfloop>

				</cfif>
			
			</cfif>

			<!--- WYSYŁANIE POWIADOMIEŃ --->
			<!---
				24.07.2013
				Do dodaniu planogramu i zapisaniu wszystkich plików wysyłam powiadomienia
				email do sklepów oraz do KOS i DKiN.
				
				Wysyłanie maili odbywa się w osobnym wątku.
			--->
			<!--- Do odkomentowania po dodaniu wszystkich planogramów --->
			<cfthread action="run" name="sendPlanogramReminder" priority="HIGH" >
				<!--- Wyciągam listę sklepów, która ma dostać maila --->
				<cfset stores = model("store_shelf").getShelfStores(
					shelftypeid = params.shelftypeid,
					shelfcategoryid = params.shelfcategoryid,
					storetypeid = params.storetypeid) />
				
				<!--- Wyciągam listę dodanych planogramów --->
					<cfset planogramFiles = model("store_planogramfile").getPlanogramFiles(newPlanogram) />
				
					<cfloop query="stores">
						<cftry>
							<cfmail to="#projekt#@monkey.xyz" from="INTRANET <intranet@monkey.xyz>" 
									subject="Nowy planogram" type="text/html" charset="utf-8">
							
								Witaj #nazwaajenta#,<br />
								W Intranecie został umieszczony nowy planogram. Aby go zobaczyć proszę zalogować się do Intranetu i przejść do swojego profilu. 
								
								<br /><br />
								Uwaga. Plik z planogramem jest również załączony do wiadomości.
								<br /><br />
								Pozdrawiamy,<br />
								Monkey Group
							
								<cfloop query="planogramFiles">
									<cfmailparam file="#ExpandPath('files/planograms/#filesrc#')#">
								</cfloop>
	
							</cfmail>
				
							<cfcatch type="any" >
								<cfmail to="admin@monkey.xyz" 
									from="INTRANET <intranet@monkey.xyz>" 
									subject="Błąd powiadomienia o nowym planogramie"
									type="text/html"
									charset="utf-8">
										
									<cfdump var="#cfcatch#" />
									
								</cfmail>
							</cfcatch>
						</cftry>
					</cfloop>  
				
			</cfthread>
		</cfif>
		
		<cfset usesLayout(template="/layout_cfwindow") />
	</cffunction>
	
	<!---
		iFrame do ładowania plików do planogramów
	--->
	<cffunction name="iframe" hint="iframe">
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="xlsIframe" output="false" access="public" hint="">
		
		<cfset planogramid = URL.PLANOGRAMID />
		<cfset storetypeid = URL.STORETYPEID />
		<cfset shelftypeid = URL.SHELFTYPEID />
		<cfset shelfcategoryid = URL.SHELFCATEGORYID />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="xls" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES") and Len(FORM.XLSFILE) GT 0>

			<cfset var uploadFile = createObject("component", "cfc.upload2").init(directory="planograms_totalunits",maxSize=768000) />
			<cfset uploadFile.setDirectory("planograms_totalunits") />
			<cfset myExcelResults = uploadFile.uploadFile(fileField="xlsfile") />
			
			<cfif myExcelResults.SUCCESS is true AND IsDefined("FORM.PLANOGRAMID")>
				<cfset newTotalUnitFile = model("store_planogram_totalunit").createFile(
					planogramid = FORM.PLANOGRAMID,
					storetypeid = FORM.STORETYPEID,
					shelftypeid = FORM.SHELFTYPEID,
					shelfcategoryid = FORM.SHELFCATEGORYID,
					userid = session.user.id,
					filedirectory = myExcelResults.SERVERDIRECTORY,
					file = myExcelResults.NEWSERVERNAME
				) />
					
				<cfspreadsheet action="read" query="qxls" src="#myExcelResults.SERVERDIRECTORY#/#myExcelResults.NEWSERVERNAME#" excludeheaderrow="true" headerrow="1"/>
					
				<cfset totalUnitValue = structNew() />
				<cfset var indeks = 1 />
				<cfloop query="qxls">
					<cfset totalUnitValue = model("store_planogram_totalunit").createFileValue(
						planogramid = FORM.PLANOGRAMID,
						storetypeid = FORM.STORETYPEID,
						shelftypeid = FORM.SHELFTYPEID,
						shelfcategoryid = FORM.SHELFCATEGORYID,
						fileid = newTotalUnitFile.id,
						productid = ToString(qxls.PRODUCT_ID),
						upc = ToString(qxls.UPC),
						totalunits = qxls.TOTAL_UNITS,
						prestock = qxls["PRESTOCK (Formula)"][indeks],
						nazwa_produktu = qxls["Name"][indeks],
						zapas_opt = qxls["ZAPAS_OPT (Formula)"][indeks],
						units_case = qxls["Units_Case"][indeks]) />
					<cfset indeks++ />
				</cfloop>

			</cfif>
			
			<cfset planogramid = FORM.PLANOGRAMID />
			<cfset storetypeid = FORM.STORETYPEID />
			<cfset shelftypeid = FORM.SHELFTYPEID />
			<cfset shelfcategoryid = FORM.SHELFCATEGORYID />
		</cfif>
		<cfset usesLayout("/layout_cfwindow") />
	</cffunction>
	
	<cffunction name="actionAdd" hint="Akcja dodawania nowego planogramu do systemu."
		description="Po dodaniu planogramu użytkownik jest przekierowyway na stronę,
				na której następuje przypisanie planogramu do odpowiednich sklepów.
				Po przypisaniu Ajenci są powiadamiani mailowo o nowym dokumenncie.">
		
		<!---
			Pierwszym etapem zapisywania planogramu jest dodanie jego definicji
			w tabeli store_planograms. Definicja zawiera kto, kiedy i o czym dodał planogram.
			
			25.02.2014
			Zmieniony jest sposób dodawania planogramu. Zmiany są związane z załączaniem
			dodatkowego pliku zawierającego TOTAL UNITS.
		--->
		<cfset new_planogram = model("store_planogram").create(
			note = params.note,
			created = Now(),
			userid = session.user.id,
			storetypeid = params.storetypeid,
			shelftypeid = params.shelftypeid,
			shelfcategoryid = params.shelfcategoryid,
			index_count = params.index_count,
			date_from = Mid(params.date_from, 7, 4) & "-" & Mid(params.date_from, 4, 2) & "-" & Mid(params.date_from, 1, 2)
		) />
		
		<!---
			Po zapisaniu definicji planogramu zapisuje wszystkie pliki,
			które było do niego dodane.
		--->
		<cfif structKeyExists(FORM, "planogram_src") and structKeyExists(FORM, "planogram_name")>
			<cfset srcArray = ListToArray(FORM.planogram_src, ",", false) />
			<cfset nameArray = ListToArray(FORM.planogram_name, ",", false) />
			
			<cfset index = 1 />
			<cfloop array="#srcArray#" index="i" >
				<cfset newPlanogramFile = model("store_planogramfile").new() />
				<cfset newPlanogramFile.planogramid = new_planogram />
				<cfset newPlanogramFile.filesrc = i />
				<cfset newPlanogramFile.filename = nameArray[index] />
				<cfset newPlanogramFile.save(callbacks=false) />
				
				<cfset index++ />
			</cfloop>
		</cfif>
		
		<!---
			24.07.2013
			Do dodaniu planogramu i zapisaniu wszystkich plików wysyłam powiadomienia
			email do sklepów oraz do KOS i DKiN.
			
			Wysyłanie maili odbywa się w osobnym wątku.
		--->
		<!--- Do odkomentowania po dodaniu wszystkich planogramów --->
		<cfthread action="run" name="sendPlanogramReminder" priority="HIGH" >
			<!--- Wyciągam listę sklepów, która ma dostać maila --->
			<cfset stores = model("store_shelf").getShelfStores(
				shelftypeid = params.shelftypeid,
				shelfcategoryid = params.shelfcategoryid,
				storetypeid = params.storetypeid) />
			
			<!--- Wyciągam listę dodanych planogramów --->
				<cfset planogramFiles = model("store_planogramfile").getPlanogramFiles(new_planogram) />
			
				<cfloop query="stores">
					<cftry>
						<cfmail to="#projekt#@monkey.xyz" 
							from="INTRANET <intranet@monkey.xyz>" 
							subject="Nowy planogram"
							type="text/html"
							charset="utf-8">
						
							Witaj #nazwaajenta#,<br />
							W Intranecie został umieszczony nowy planogram. Aby go zobaczyć proszę zalogować się do Intranetu i przejść do swojego profilu. 
							
							<br /><br />
							Uwaga. Plik z planogramem jest również załączony do wiadomości.
							<br /><br />
							Pozdrawiamy,<br />
							Monkey Group
						
							<cfloop query="planogramFiles">
								<cfmailparam file="#ExpandPath('files/planograms/#filesrc#')#">
							</cfloop>

						</cfmail>
			
						<cfcatch type="any" >
							<cfmail to="admin@monkey.xyz" 
								from="INTRANET <intranet@monkey.xyz>" 
								subject="Błąd powiadomienia o nowym planogramie"
								type="text/html"
								charset="utf-8">
									
								<cfdump var="#cfcatch#" />
								
							</cfmail>
						</cfcatch>
					</cftry>
				</cfloop>  
			
		</cfthread>
		
		<cfset redirectTo(controller="Store_planograms",action="add",params="storetypeid=#params.storetypeid#&shelftypeid=#params.shelftypeid#&shelfcategoryid=#params.shelfcategoryid#") />
		
	</cffunction>
	
	<cffunction
		name="addFile"
		hint="Zapisanie planogramy w systemie"
		returnformat="JSON" >
			
		<cfset json = {} />
		<cfset my_file = APPLICATION.cfc.upload.SetDirName(dirName="planograms") />
		<cfset my_file = APPLICATION.cfc.upload.upload(file_field="filedata") />
		<cfif isStruct(my_file) AND StructKeyExists(my_file, "SUCCESS")> <!--- Plik został zapisany na serwerze --->
			<cfset json.STATUS = 200 /> 
			<cfset json.MESSAGE = my_file.NEWSERVERNAME />
			<cfset json.FILENAME = my_file.NEWSERVERNAME />
			
		</cfif>
		
		<cfset renderWith(data="json",template="json",layout=false) />
			
	</cffunction>
	
	<!---
		15.02.2013
		Metoda pozwalająca przypisać planogram do odpowiednich sklepów.
		Po przypisaniu planogramu, ajenci dostają maila z informacją, że 
		coś takiego na nich czeka.
	--->
	<cffunction
		name="assignStores"
		hint="Przypisanie sklepów, które mają mieć wgląd w dany planogram">
		
		<!---
			Definiuje filtry, które mają wybrać odpowiednie lokalizacje
		--->
		<cfparam
			name="search"
			type="string" 
			default=" " />
			
		<cfparam
			name="shelfid"
			type="numeric" 
			default="0" />
		
		<cfparam
			name="location"
			type="string"
			default=" " />
		
		<!---
			Sprawdzma, czy filtry zostały przekazane w sesji.
		--->
		<cfif structKeyExists(session, "store_filter") and structKeyExists(session.store_filter, "search")>
			<cfset search = session.store_filter.search />
		</cfif>
		
		<cfif structKeyExists(session, "store_filter") and structKeyExists(session.store_filter, "shelfid")>
			<cfset shelfid = session.store_filter.shelfid />
		</cfif>
		
		<cfif structKeyExists(session, "store_filter") and structKeyExists(session.store_filter, "location")>
			<cfset location = session.store_filter.location />
		</cfif>
		
		<!---
			Sprawdzam, czy parametry zostały przesłane w formularzu.
		--->
		<cfif structKeyExists(params, "search")>
			<cfset search = params.search />
		</cfif>
		
		<cfif structKeyExists(params, "shelfid")>
			<cfset shelfid = params.shelfid />
		</cfif>
		
		<cfif structKeyExists(params, "location")>
			<cfset location = params.location />
		</cfif>
		
		<cfset session.store_filter = {
			location			=		location,
			search				=		search,
			shelfid				=		shelfid
			} />
			
		<cfset my_planogram = model("store_planogram").findByKey(params.key) />
		<cfset my_planogram_files = model("store_planogram").getPlanogramFiles(
			planogramid	=	params.key) />
			
		<!---
			Pobieram listę możliwych lokalizacji do wyboru
		--->
		<cfset my_locations = model("store_store").getLocalizations() />
		
		<!---
			Pobieram listę regałów do wyboru
		--->
		<cfset shelfs = model("store_shelf").getDefinedShelfs() />
		
		<!--- 
			Pobieram listę sklepów, które będą miały przypisany planogram.
		--->
		<cfset stores = model("store_store").getStoreToPlanogram(
			search		=	search,
			shelfid		=	shelfid,
			location	=	location) />
			
	</cffunction>
				
	<cffunction
		name="newFile"
		hint="Metoda generująca wiersz do tabelki zawierający formularz pliku do dodania">
		
		<cfset number = params.key+1 />
		
	</cffunction>
	
	<cffunction
		name="addPlanogram"
		hint="Metoda zapisująca plik z planogramem">
	
		<!---<cfdump var="#params#" />--->
		<!---<cfabort />--->
	
		<cfif Len(params.file)>
				
			<cfset my_file = APPLICATION.cfc.upload.SetDirName(dirName="planograms") />
			<cfset my_file = APPLICATION.cfc.upload.upload(file_field="file") />
				
			<!---
				Jeżeli plik jest zapisany to dodaje odpowiednie wpisy w bazie.
			--->
			<cfif not structIsEmpty(my_file)>
					
				<!---<cfset planogram_file = model("store_planogramfile").new() />
				<cfset planogram_file.filename = my_file.NEWSERVERNAME />
				<cfset planogram_file.finaryfile = my_file.BINARYCONTENT />
				<cfset planogram_file.filesrc = my_file.SERVERDIRECTORY & "/" & my_file.NEWSERVERNAME />
				<cfset planogram_file.planogramid = new_planogram.id />
				<cfset planogram_file.save(callbacks=false) />--->
					
			</cfif>
				
		</cfif>
	
	</cffunction>
	
	<cffunction 
		name="actionAssignStores"
		hint="Zapisanie połączenia planogramu ze sklepami" >
		
		<cfif structKeyExists(params, "storeid")>
			
			<cfset tmp_stores = params.storeid />
			
			<cfloop collection="#tmp_stores#" item="i" >
				
				<cfset assignment = model("store_storeplanogram").new() />
				<cfset assignment.planogramid = params.planogramid />
				<cfset assignment.storeid = i />
				<cfset assignment.save(callbacks=false) />
				
			</cfloop>
			
		</cfif>
		
		<cfset redirectTo(controller="Store_planograms",action="index",success="Planogram został prawidłowo przypisany do sklepów.") />
		
	</cffunction>
	
	<cffunction
		name="getFiles"
		hint="Pobranie listy plików przypisanych do planogramu">
	
		<cfset my_planogram_files = model("store_planogram").getPlanogramFiles(
			planogramid	=	params.key) />
	
	</cffunction>
	
	<cffunction name="reportAllStores" output="false" access="public" hint="">
		
		<cfset report = model("store_planogram").reportAllStores() />
		
		<cfsavecontent variable="strExcelData" >
		<cfprocessingdirective pageencoding="utf-8" />
			<table>
				<tr>
					<cfloop list="#ArrayToList(report.getColumnNames())#" index="col" >
						<th><cfoutput>#col#</cfoutput></th>
					</cfloop>
				</tr>
				<cfloop query="report">
					<tr>
						<cfloop list="#ArrayToList(report.getColumnNames())#" index="col">
							<td><cfoutput>#report[col][currentrow]#</cfoutput></td>
						</cfloop>
					</tr>
				</cfloop>
			</table>
		</cfsavecontent>
		
		<cfheader
			name="Content-Disposition"
			value="attachment; filename=EXPORT-wszystkie_sklepy.xls"
			charset="utf-8" />
		
		<cfcontent
			type="application/msexcel"
			variable="#ToBinary(ToBase64(strExcelData.Trim()))#" />
		
	</cffunction>
	
	<cffunction name="reportSingleStore" output="false" access="public" hint="Lista regałów dla pojedyńczego sklepu">
		<cfset store = model("store_store").findByKey(params.key) />
		<cfset report = model("store_planogram").reportSingleStore(params.key) />
		
		<cfsavecontent variable="strExcelData" >
		<cfprocessingdirective pageencoding="utf-8" />
			<table>
				<tr>
					<cfloop list="#ArrayToList(report.getColumnNames())#" index="col" >
						<th><cfoutput>#col#</cfoutput></th>
					</cfloop>
				</tr>
				<cfloop query="report">
					<tr>
						<cfloop list="#ArrayToList(report.getColumnNames())#" index="col">
							<td><cfoutput>#report[col][currentrow]#</cfoutput></td>
						</cfloop>
					</tr>
				</cfloop>
			</table>
		</cfsavecontent>
		
		<cfheader
			name="Content-Disposition"
			value="attachment; filename=EXPORT-#store.projekt#.xls"
			charset="utf-8" />
		
		<cfcontent
			type="application/msexcel"
			variable="#ToBinary(ToBase64(strExcelData.Trim()))#" />
	</cffunction>
	
	<cffunction name="removeShelfStore" output="false" access="public" hint="">
		<cfset json = {
			STATUS = "ERROR",
			MESSAGE = "Sklep nie został usunięty"} />
		
		<cfif IsDefined("params.key")>
			<cfset removeShelfStore = model("store_storeshelf").removeShelfStore(params.key) />
			
			<cfset json = {
				STATUS = "OK",
				MESSAGE = "Sklep został usunięty"} />
				
		</cfif>
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction name="removeShelfPlanogram" output="false" access="public" hint="">
		<cfset json = {
			STATUS = "ERROR",
			MESSAGE = "Planogram nie został usunięty"} />
		
		<cfif IsDefined("url.key")>
			
			<cfset removeShelfPlanogram = model("store_planogram").removeShelfPlanogram(url.key, session.user.id) />
			
			<cfset json = {
				STATUS = "OK",
				MESSAGE = "Planogram został usunięty"} />
			
		</cfif>
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
</cfcomponent>