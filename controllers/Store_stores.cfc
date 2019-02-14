<cfcomponent extends="Controller" output="false" hint="">

	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadJS",only="index") />
		<cfset filters(through="before",type="before") />
	</cffunction>
	
	<cffunction name="loadJS" output="false" access="public" hint="">
		<cfset application.ajaxImportFiles &= ",initStoreMmarket" />
		<cfset APPLICATION.bodyImportFiles &= ",store_stores,storeFloorplan" />
	</cffunction>
	
	<cffunction name="before" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>

	<cffunction name="index" output="false" access="public" hint="Lista sklepów" description="Metoda prezentująca listę zdefiniowanych w systemie sklepów">
	
		<!---
			Definiuje składowe filtru
		--->
		<cfparam name="location" type="string" default="0" />
		<cfparam name="shelfid" type="numeric" default="0" />
		<cfparam name="storetype_id" type="numeric" default="0" />
		<cfparam name="searchVal" type="string" default="" />
		<cfparam name="page" type="numeric" default="1" />
		<cfparam name="elements" type="numeric" default="25" />		

		<!---
			Sprawdzam, czy istnieją dane zapisane w sesji.
		--->
		<cfif structKeyExists(session, "store_filter") and structKeyExists(session.store_filter, "location")>
			<cfset location = session.store_filter.location />
		</cfif>

		<cfif structKeyExists(session, "store_filter") and structKeyExists(session.store_filter, "search")>
			<cfset searchVal = session.store_filter.search />
		</cfif>

		<cfif structKeyExists(session, "store_filter") and structKeyExists(session.store_filter, "page")>
			<cfset page = session.store_filter.page />
		</cfif>

		<cfif structKeyExists(session, "store_filter") and structKeyExists(session.store_filter, "elements")>
			<cfset elements = session.store_filter.elements />
		</cfif>

		<cfif structKeyExists(session, "store_filter") and structKeyExists(session.store_filter, "shelfid")>
			<cfset shelfid = session.store_filter.shelfid />
		</cfif>
		
		<cfif structKeyExists(session, "store_filter") and structKeyExists(session.store_filter, "storetype_id")>
			<cfset storetype_id = session.store_filter.storetype_id />
		</cfif>
		
		<cfif structKeyExists(session, "store_filter") and structKeyExists(session.store_filter, "typeid")>
			<cfset typeid = session.store_filter.typeid />
		</cfif>

		<!---
			Sprawdzam, czy przesłano dane w formularzu.
		--->
		<cfif structKeyExists(params, "location")>
			<cfset location = params.location />
		</cfif>

		<cfif structKeyExists(params, "storesearch")>
			<cfset searchVal = params.storesearch />
		</cfif>

		<cfif structKeyExists(params, "page")>
			<cfset page = params.page />
		</cfif>

		<cfif structKeyExists(params, "elements")>
			<cfset elements = params.elements />
		</cfif>

		<cfif structKeyExists(params, "shelfid")>
			<cfset shelfid = params.shelfid />
		</cfif>
		
		<cfif structKeyExists(params, "storetype_id")>
			<cfset storetype_id = params.storetype_id />
		</cfif>
		
		<cfif structKeyExists(params, "typeid")>
			<cfset typeid = params.typeid />
		</cfif>

		<!---
			Zapisuje opcje filtrowania w sesji.
		--->
		<cfset session.store_filter = {
			location			=		location,
			search				=		searchVal,
			page				=		page,
			elements			=		elements,
			shelfid				=		shelfid,
			storetype_id		=		storetype_id
			} />

		<!---
			Pobieram paginowaną listę sklepów.
		--->
		<cfset stores = model("store_store").getStores(
			search			=		searchVal,
			location		=		location,
			page			=		page,
			elements		=		elements,
			shelfid			=		shelfid,
			storetype_id		=		storetype_id
			) />

		<cfset stores_count = model("store_store").getStoresCount(
			search			=		searchVal,
			location		=		location,
			shelfid			=		shelfid,
			storetype_id		=		storetype_id) />

		<!---
			Pobieram listę możliwych lokalizacji do wyboru
		--->
		<cfset my_localizations = model("store_store").getLocalizations() />

		<!---
			Pobieram listę regałów do wyboru
		--->
		<cfset shelfs = model("store_shelf").getDefinedShelfs(
			all = true) />
			
		<cfset myStoreTypes = model("store_type").getTypes() />
		<cfset myStorePartners = model("tree_groupuser").getUsersByGroupName("KOS") />
		<cfset instruction_types = model("instruction_type").pobierzTypy() />

	</cffunction>
	
	<cffunction 
		name="updateStoreType"
		hint="Aktualizacja typu sklepu" >
		
		<cfset json = false />
		
		<cfif structKeyExists(params, "name") AND structKeyExists(params, "value")>
			
			<cfset storeTypeId = ListToArray(params.name, "-", false) />
			<cfset json = model("store_store").updateByKey(key=storeTypeId[2],storetype_id=params.value) />
			
		</cfif>
		
		<cfset renderWith(data="json",template="json",layout=false) />
		
	</cffunction>
	
	<cffunction name="view" >
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="root" >
			<cfinvokeargument name="groupname" value="root" />
		</cfinvoke>
		
		<cfif root is true>
				
			<cfif StructKeyExists(params, "key")>
				
				<cfset store = model("store_store").findBykey(key=params.key) />
				
				<cfif IsObject(store)>
					
					<cfif store.latitude neq ''>
						<cfset lat = Replace(store.latitude, '"', '') />
					<cfelse>
						<cfset lat = '' />
					</cfif>
					
					<cfif store.longitude neq ''>
						<cfset lng = Replace(store.longitude, '"', '') />
					<cfelse>
						<cfset lng = '' />
					</cfif>
					
					<cfset ratio = application.cfc.winapp.ratioList3(0, 10, 'ratio', 'desc', store.projekt) />
					
					<cfset sales = application.cfc.winapp.obroty2(store.projekt) />
					
					<!---<cfset eleader = application.cfc.eleader.pobierzWynikiAOS('s') />--->
					
					<!---<cfif IsObject(sales)>--->
						
						<cfset columns = sales.getColumnNames() />
						
						<cfset qSales = QueryNew("mm, yy, mmyy, val", "VarChar, Integer, Integer, Double") /> 
						<cfset QueryAddRow(qSales, ArrayLen(columns)-2) />
						<cfset c=0 />
						
						<cfloop array="#columns#" index="col">
							<cfif col neq 'LOC' and col neq 'ADRES'>
								<cfset c++ />
								
								<cfset _mm = LCase(Left(col, Len(col)-4)) />
								
								<cfswitch expression="#_mm#">
									<cfcase value="styczen">
										<cfset mm = '01' />
									</cfcase>
									<cfcase value="luty">
										<cfset mm = '02' />
									</cfcase>
									<cfcase value="marzec">
										<cfset mm = '03' />
									</cfcase>
									<cfcase value="kwiecien">
										<cfset mm = '04' />
									</cfcase>
									<cfcase value="maj">
										<cfset mm = '05' />
									</cfcase>
									<cfcase value="czerwiec">
										<cfset mm = '06' />
									</cfcase>
									<cfcase value="lipiec">
										<cfset mm = '07' />
									</cfcase>
									<cfcase value="sierpien">
										<cfset mm = '08' />
									</cfcase>
									<cfcase value="wrzesien">
										<cfset mm = '09' />
									</cfcase>
									<cfcase value="pazdziernik">
										<cfset mm = '10' />
									</cfcase>
									<cfcase value="listopad">
										<cfset mm = '11' />
									</cfcase>
									<cfcase value="grudzien">
										<cfset mm = '12' />
									</cfcase>
								</cfswitch>
								
								<cfset yy = Right(col, 4) />
								
								<cfset sum = 0.0 />
								
								<cfloop index="i" from="1" to="#sales.RecordCount#">
									<cfif sales[col][i] neq ''>
										<cfset sum = sum + LSParseNumber(Replace(sales[col][i], ',', '.')) />
									</cfif>
								</cfloop>
								
								
								<!---<cfif sales[col][1] eq ''>
									<cfset val = 0.00 />
								<cfelse>
									<cfset val = Replace(sales[col][1], ',', '.') />
								</cfif>--->
								
								<cfset QuerySetCell(qSales, "mm", _mm, c) />
								<cfset QuerySetCell(qSales, "yy", yy, c) />
								<cfset QuerySetCell(qSales, "mmyy", yy&mm, c) />
								<cfset QuerySetCell(qSales, "val", sum, c) />
								
							</cfif>
						</cfloop>
						
					<!---</cfif>--->
				<cfelse>
					
					<cfset redirectTo(controller="Users", action="view", key=session.user.id) />
					
				</cfif>
			
			<cfelse>
				
				<cflocation url="http://intranet.monkey.xyz" addToken="no" statuscode="301" />
					
			</cfif>
			
			<cfset usesLayout(template="/layout_googlemap.cfm") />
			
		<cfelse>
			
			<!---<cfset renderPage(template="/autherror") />--->
			<cflocation url="http://intranet.monkey.xyz" addToken="no" statuscode="301" />
		
		</cfif>
		
	</cffunction>
	
	<cffunction
		name="hello"
		hint="Metoda wysyłająca powitalnego maila do Ajentów."
		description="Metoda, która wysyła powitalnego maila do Ajentów. Mail zawiera podstawowe
				informacje, jak korzystać z Intranetu." >

		<cfset my_users = model("user").findAll(where="isstore=1") />
		<cfset my_mail = model("email").hello(
			user		=		my_users) />

		<cfset redirectTo(controller="users",action="view",key=session.userid) />

	</cffunction>

	<!---
		13.02.2013
		Metody do obsługi sklepów dla Marketingu.

		getStore pobiera dane o sklepie, które są potrzebne dla Centrali.
		Jest wgląd z mikrośrodki trwałe oraz regały w sklepie.
	--->
	<cffunction
		name="getStore"
		hint="Pobranie informacji o sklepie"
		description="Metoda pobierająca informacje o sklepie potrzebne dla Centrali">

		<!---
			Pobieram ilości protokołów zdefiniowanych przez Ajenta.
			Protokoły są pobierany po logo z Asseco.
		--->
		<cfset my_store = model("store_store").findByKey(params.key) />
		<cfset my_protocols = model("store_store").getStoreProtocols(
			logo		=		my_store.ajent) />

		<!---
			Pobieram listę regałów przypisanych do sklepu.
			Regały są pobieranie nie po numerze logo z Asseco a po id sklepu
			w Intranecie.
		--->
		<cfset my_shelfs = model("store_store").getStoreShelfs(
			storeid		=		my_store.id) />
		
		<cfset myPlanograms = model("store_store").getStorePlanograms(my_store.id) />

		<!---
			Pobieram listę obiektów, które zostały przypisane do danego sklepu.
		--->
		<!---<cfset my_objects = model("store_store").getStoreObjects(
			storeid		=		my_store.id) />--->

		<cfset usesLayout(false) />

	</cffunction>

	<cffunction name="search" output="false" access="public" hint="Wyszukiwanie sklepów zdefiniowanych w Intranecie">
			
		<cfif not StructKeyExists(params, "storetype_id")>
			<cfset params.storetype_id = 0 />
		</cfif>
		
		<cfif not StructKeyExists(params, "limit")>
			<cfset params.limit = 5000 />
		</cfif>

		<cfset stores_query = model("store_store").searchStores(
			search = params.search,
			storetypeid = params.storetype_id,
			limit = params.limit) />
		<cfset stores = model("store_store").QueryToStruct(Query=stores_query) />
		<cfset usesLayout(false) />
	</cffunction>

	<!---<cffunction
		name="getStoreInstructions"
		hint="Pobranie instrukcji przypisanych do sklepu/ajenta">

		<cfset myinstructions = model("instruction_document").getInstructions(where="partner_prowadzacy_sklep=1",limit="limit 12") />

	</cffunction>--->
	
	<!---
		14.06.2013
		Widget prezentujący ilość wydrukowanych stron w przeciągu 
		ostatnich 30 dni.
		
		Dane są przeznaczone dla Ajentów.
	--->
	<cffunction
		name="getStorePrinterWidget"
		hint="Pobranie raportu z uliością wydruków.">

		<cfset printers = APPLICATION.cfc.printers.init().getPrinterByProject(
			projekt = session.user.login) />
			
		<cfset printerStatus = APPLICATION.cfc.printers.getPrinterStatus(
			projekt = session.user.login) />
			
		<cfset renderWith(data="printers,printerStatus",layout=false) />
	
	</cffunction>
	
	<cffunction name="edit" output="false" access="public" hint="Edycja danych sklepu/pps">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			
			<cfif not IsDefined("FORM.CONDITIONS")>
				<cfset flashInsert(error="Musisz zaakceptować regulamin") />
			<cfelse> <!--- Jeżeli regulamin jest zaakceptowany --->
				<cfset myStore = model("store_store").getStoreByProject(session.user.login) />
				
				<cfif Len("FORM.TELEFONKOM")>
					<cfset toUpdate = model("store_store").updateAll( 
					telefonkom = FORM.TELEFONKOM,
					where = "id = #myStore.id#") />
				</cfif>
				
				<cfif Len("FORM.TELEFONKOM")>
					<cfset toUpdate = model("store_store").updateAll( 
						telefon = FORM.TELEFON,
						where = "id = #myStore.id#") />
				</cfif>
				 
				<cfset flashInsert(success="Dane zostały zapisane prawidłowo") />
			</cfif>
			
		</cfif>
		
		<cfset store = model("store_store").getStoreByProject(session.user.login) />
		<cfset renderPage(layout=false)>
	</cffunction>
	
	<cffunction name="iframe" output="false" access="public" hint="">
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="addFloorplan" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES") >
			
			<cfset var newFloorplan = structNew() />
			<cfset my_file = APPLICATION.cfc.upload.SetDirName(dirName="floorplans") />
			<cfset my_file = APPLICATION.cfc.upload.upload(file_field="filedata") />
			
			<cfif isStruct(my_file) AND StructKeyExists(my_file, "SUCCESS")> <!--- Plik został zapisany na serwerze --->
				
				<cfset newFloorplan.filename = my_file.NEWSERVERNAME />
				<cfset newFloorplan.filesrc = my_file.NEWSERVERNAME />
				<cfset newFloorplan.created = Now() />
				<cfset newFloorplan.storeid = FORM.STOREID />
				<cfset newFloorplan.userid = session.user.id />
			
			</cfif>
			
			<cfif not structIsEmpty(newFloorplan)>
				<cfset savedFloorplan = model("store_floorplan").create(newFloorplan) />
			</cfif>
			
		</cfif>
		
		<cfset storeid = params.key />
		<cfset floorplans = model("store_floorplan").getFloorPlans(params.key) />
		<cfset usesLayout(template="/layout_cfwindow") />
	</cffunction>
	
	<cffunction 
		name="updateStorePartner"
		hint="Aktualizacja partnera dla sklepu (aktualizacja KOS)" >
		
		<cfset json = false />
		
		<cfif structKeyExists(params, "name") AND structKeyExists(params, "value")>
			
			<cfset storeTypeId = ListToArray(params.name, "-", false) />
			<cfset json = model("store_store").updateByKey(key=storeTypeId[2],partnerid=params.value) />
			
		</cfif>
		
		<cfset renderWith(data="json",template="json",layout=false) />
		
	</cffunction>
	
	<cffunction name="updateStoreTypeId" output="false" access="public" hint="Zmiana typu sklepu. Na podstawie typu widoczne są odpowiednie WAP. Jest to związane z modelem centralizacji">
		<cfset json = false />
		<cfif structKeyExists(params, "name") and structKeyExists(params, "value")>
			<cfset var typeId = ListToArray(params.name, "-", false) />
			<cfset json = model("store_store").updateByKey(key=typeId[2],typeid=params.value) />
		</cfif>
		
		<cfset renderWith(data="json",template="json",layout=false) />
	</cffunction>
	
	<cffunction name="mmarket" output="false" access="public" hint="">
		<cfparam name="projekt" type="string" default="" />
		
		<cfif IsDefined("session.storeFilter.mmarket.projekt")>
			<cfset projekt = session.storeFilter.mmarket.projekt />
		</cfif>
		
		<cfif IsDefined("FORM.PROJEKT")>
			<cfset projekt = FORM.PROJEKT />
		</cfif>
		
		<cfset session.storeFilter.mmarket = {
			projekt = projekt
		} />
		
		<cfset wersje = model("store_mmarket").najnowszeWersje(projekt) />
		<cfset typyAplikacji = model("store_mmarket").pobierzTypyAplikacji() />
		
		<!---<cfif IsDefined("URL.t")>
			<cfset usesLayout(false) />
		</cfif>--->
	</cffunction>
	
	<cffunction name="wersjeMmarket" output="false" access="public" hint="">
		
		<cfset hosty = model("store_mmarket").pobierzHosty(idMmarket = URL.idMmarket) />
		<cfset aplikacje = model("store_mmarket").pobierzAplikacje(idMmarket = URL.idMmarket) />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="przypiszPartnerowZPliku" output="false" access="public" hint="">
		<cfset sklepy = 0 />
		<cfif isDefined("FORM.FIELDNAMES")>
			<cfspreadsheet action="read" src="#FORM.SRC#" query="plikImportu" headerrow="1" excludeheaderrow="true" />
			<cfset sklepy = model("store_store").aktualizujKosNaSklepach(query=plikImportu) />
		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
	
</cfcomponent>