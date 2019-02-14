<cfcomponent output="false" displayname="Store_contractors" extends="Controller">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
		<cfset filters(through="loadJs",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="loadJs" output="false" access="public" hint="">
		<cfset APPLICATION.ajaxImportFiles &= ",initStoreContractors" />
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="">
		
	</cffunction>
	
	<cffunction name="contractors" output="false" access="public" hint="">
		<cfparam name="sklep" type="string" default="" />
		<cfparam name="search_contractor" type="string" default="" />
		
		<cfif IsDefined("session.store_contractors.sklep")>
			<cfset sklep = session.store_contractors.sklep />
		</cfif>
		
		<cfif IsDefined("session.store_contractors.szukaj")>
			<cfset search_contractor = session.store_contractors.szukaj />
		</cfif>
		
		<cfif IsDefined("FORM.SEARCH")>
			<cfset sklep = FORM.SEARCH />
		</cfif>
		
		<cfif IsDefined("URL.STORE")>
			<cfset sklep = URL.STORE />
		</cfif>
		
		<cfif IsDefined("FORM.SEARCH_CONTRACTOR")>
			<cfset search_contractor = FORM.SEARCH_CONTRACTOR />
		</cfif>
		
		<cfif IsDefined("sklep") and Len(sklep) EQ 6>
 	 		<cfset dostawcy = model("store_contractor").getStoreContractors(sklep, search_contractor) />
			<!---<cfset sklep = FORM.SEARCH />--->
			
		<!---<cfelseif IsDefined("sklep") and Len(s) EQ 6>
			
			<cfset dostawcy = model("store_contractor").getStoreContractors(URL.STORE) />
			<cfset sklep = URL.STORE />--->
			
		<cfelse>
			<cfset dostawcy = model("store_contractor").getContractors(search_contractor) />
		</cfif>
		
		<cfset session.store_contractors = {
			sklep = sklep,
			szukaj = search_contractor } />
		
		<cfif IsDefined("URL.FORMAT")>
			<cfswitch expression="#URL.FORMAT#" >
				<cfcase value="xls" >
					
					<cfset columnNames = "Nazwa_dostawcy,Miasto, Typ_dostawcy,Godzina_od,Godzina_do,Dni_dostaw,Zwroty,Kontakt" />
					<cfset q = queryNew(columnNames) />
					<cfloop query="dostawcy">
						<cfset queryAddRow(q) />
						<cfset querySetCell(q, "Nazwa_dostawcy", javacast("string", contractor_name)) />
						<cfset querySetCell(q, "Miasto", javacast("string", contractor_city)) />
						<cfset querySetCell(q, "Typ_dostawcy", javacast("string", type_name)) />
						<cfset querySetCell(q, "Godzina_od", "#hour_from#") />
						<cfset querySetCell(q, "Godzina_do", hour_to) />
						<cfset querySetCell(q, "Dni_dostaw", javacast("string", dni_dostaw)) />
						<cfset querySetCell(q, "Zwroty", javacast("string", zwroty_towaru)) />
						<cfset querySetCell(q, "Kontakt", javacast("string", contractor_telephone)) />
					</cfloop>
					
					<cfset fName = "files/store_contractors/#URL.STORE#[#DateFormat(Now(),'yyyy-mm-dd')#].xls" />
					<cfset fn = expandPath(fName) />
					<cfset s = spreadsheetNew() />
					<cfset spreadsheetAddRow(s, columnNames) />
					<cfset spreadsheetAddRows(s, q) />
					<cfset spreadsheetWrite(s, fn, true) />
					
					<cflocation url="#fName#" />
					
				</cfcase>
			</cfswitch>
		</cfif>
		
		<cfset typyDostawcow = model("store_contractor").getContractorTypes() />
	</cffunction>
	
	<cffunction name="addContractor" output="false" access="public" hint="">
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset results = model("store_contractor").createContractor(
				f = FORM
			) />
		</cfif>
		
		<cfset typyDostawcow = model("store_contractor").getContractorTypes() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="getSystemContractor" output="false" access="public" hint="">
		<cfset json = "" />
		<cfif IsDefined("FORM.LOGO")>
			<cfset json = model("store_contractor").getSystemContractor(FORM.LOGO) />
			<cfset json = QueryToStruct(Query=json) />
		</cfif>
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>	
	
	<cffunction name="contractorStores" output="false" access="public" hint="">
		<cfset przypisaneSklepy = model("store_contractor").getContractorStores(URL.CONTRACTORID) />
		<cfset dostawca = model("store_contractor").getContractorById(URL.CONTRACTORID) />
		<cfset contractorid = URL.CONTRACTORID />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="stores" output="false" access="public" hint="">
		<cfparam name="searchVal" type="string" default="" />
		<cfif IsDefined("FORM.SEARCHVAL")>
			<cfset searchVal = FORM.SEARCHVAL />
		</cfif> 
		
		<cfif IsDefined("FORM.FIELDNAMES") and IsDefined("FORM.PROJEKT") and IsDefined("FORM.CONTRACTOR_ID")
			and Len(FORM.PROJEKT) GT 0 and Len(FORM.CONTRACTOR_ID) GT 0>
			<cfloop list="#FORM.PROJEKT#" index="p" >
				<cfset var dostawcaSklepu = model("store_contractor").createStoreContractor(
					contractorid = FORM.CONTRACTOR_ID,
					store = p
				) />
			</cfloop>
		</cfif>
		
		<cfset sklepy = model("store_contractor").getAllStores(searchVal) />
		<cfset contractorid = URL.CONTRACTORID />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="removeStoreContractor" output="false" access="public" hint="">
		<cfset var usun = model("store_contractor").removeStoreContractor(
			contractorid = FORM.DOSTAWCA,
			store = FORM.SKLEP) />
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="removeContractor" output="false" access="public" hint="">
		<cfset var usun = model("store_contractor").removeContractor(FORM.DOSTAWCA) />
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="edit" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset var aktualizacja = model("store_contractor").updateContractor(FORM) />
		</cfif>
		
		<cfset dostawca = model("store_contractor").getContractorById(URL.CONTRACTORID) />
		<cfset typyDostawcow = model("store_contractor").getContractorTypes() />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="storeContractors" output="false" access="public" hint="">
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
			<cfinvokeargument name="groupname" value="Partner prowadzacy sklep" />
		</cfinvoke>
		
		<cfif pps is true>
			<cfset dostawcy = model("store_contractor").getStoreContractors(session.user.login) />
		<cfelse>
			<cfset redirectTo(controller="users",action="view",key=session.user.id) />	
		</cfif>
	</cffunction>
	
	<cffunction name="addIndex" output="false" access="public" hint="" >
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset results = model("store_contractor").createContractorIndex(FORM) />
		</cfif>
		
		<cfset produkty = model("store_contractor").getContractorIndexes(URL.CONTRACTORID) />
		<cfset contractorid = URL.CONTRACTORID />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="contractorIndexes" output="false" access="public" hint="">
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
			<cfinvokeargument name="groupname" value="Partner prowadzacy sklep" />
		</cfinvoke>
		
		<cfif pps is true>
			<cfset produkty = model("store_contractor").getContractorIndexes(
				id = URL.CONTRACTORID,
				store = session.user.login) />
		<cfelse>
			<cfif IsDefined("Url.store") and Len(Url.store) gt 0>
				<cfset produkty = model("store_contractor").getContractorIndexes(
					id = URL.CONTRACTORID,
					store = Url.store) />
			<cfelse>
				<cfset produkty = model("store_contractor").getContractorIndexes(
					id = URL.CONTRACTORID) />
			</cfif>
		</cfif>
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="excludeStoreIndexes" output="false" access="public" hint="">
		<cfset produktyDoWykluczenia = model("store_contractor").getContractorIndexes(URL.CONTRACTORID) />
		
		<cfset dostawca = model("store_contractor").getContractorById(URL.CONTRACTORID) />
		<cfset contractorid = URL.CONTRACTORID />
		<cfset projekt = URL.STORE />
		
		<cfset produktyWykluczone = model("store_contractor").getExcludedIndexes(contractorid = URL.CONTRACTORID, store = URL.STORE) />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="exclude" output="false" access="public" hint="">
		<cfset json = structNew() />
		<cfset var ex = model("store_contractor").exclude(
			contractorid = FORM.CONTRACTORID,
			id = FORM.ID,
			store = FORM.STORE
		) />
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction name="sentContractorsToStore" output="false" access="public" hint="">
		<cfset dostawcy = model("store_contractor").getStoreContractors(URL.STORE) />
		<cfset sklep = model("store_store").getStoreByProject(URL.STORE) />
		
		<!---<cfset uzytkownik = queryNew("givenname,sn,mail") />
		<cfset queryAddRow(uzytkownik) />
		<cfset querySetCell(uzytkownik, "givenname", javacast("string", sklep.nazwaajenta)) />
		<cfset querySetCell(uzytkownik, "sn", "") />
		<cfset querySetCell(uzytkownik, "mail", JavaCast("string", "admin@monkey.xyz")) />--->
			
		<cfset results = structNew() />
		<cfset results.success = true />
		<cfset results.message = "Wysłałem listę dostawców regionalnych" />
		
	</cffunction>
	
	<cffunction name="contractorFiles" output="false" access="public" hint="">
		
		<cfset files = model("store_contractor_file").findAll(where="contractorid=#params.contractorid#") />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="addContractorFile" output="false" access="public" hint="">

		<cfif isDefined("FORM.FIELDNAMES")>
			<cfif not directoryExists(expandPath("files/contractors"))>
				<cfset directoryCreate(expandPath("files/contractors")) />
			</cfif>
			
			<cfset filename = DateFormat(Now(), 'yyyy-mm-dd') & "_" & TimeFormat(Now(), 'HH-mm-ss') & "_" & randomText(length=11) />
			<cfset src = "files/contractors/" & filename />
			<cffile action="upload" fileField="plikMaterialu" destination="#expandPath('files/contractors')#" nameConflict="MakeUnique" result="zapisanyPlik" />
			<cfset filename &= "." & zapisanyPlik["CLIENTFILEEXT"] />
			<cfset src &= "." & zapisanyPlik["CLIENTFILEEXT"] />
			<cffile action="rename" source="#expandPath('files/contractors')#/#zapisanyPlik['SERVERFILE']#" destination="#expandPath(src)#" />
			
			<!---<cfset plikMaterialu = model("promocja_kampania").dodajPlikDoMaterialuKampanii(idKampanii=URL.idKampanii,idMaterialuKampanii=URL.idMaterialuKampanii,idTypuMaterialuReklamowego=URL.idTypuMaterialuReklamowego,userId=session.user.id,srcMaterialu=src) />--->
			<cfset files = model("store_contractor_file").create(filename=FORM.plikMaterialuNazwa, filesrc=filename, contractorid=params.contractorid, createddate=Now(), userid=session.user.id) />
		</cfif>
		
		<!---<cfset usesLayout(false) />--->
		<!---<cfset renderNothing() />--->
		
		<cfset json = files />
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction name="removeContractorFile" output="false" access="public" hint="">

		<!---<cfif isDefined("FORM.FIELDNAMES")>
			<cfif not directoryExists(expandPath("files/contractors"))>
				<cfset directoryCreate(expandPath("files/contractors")) />
			</cfif>
			
			<cfset filename = DateFormat(Now(), 'yyyy-mm-dd') & "_" & TimeFormat(Now(), 'HH-mm-ss') & "_" & randomText(length=11) />
			<cfset src = "files/contractors/" & filename />
			<cffile action="upload" fileField="plikMaterialu" destination="#expandPath('files/contractors')#" nameConflict="MakeUnique" result="zapisanyPlik" />
			<cfset filename &= "." & zapisanyPlik["CLIENTFILEEXT"] />
			<cfset src &= "." & zapisanyPlik["CLIENTFILEEXT"] />
			<cffile action="rename" source="#expandPath('files/contractors')#/#zapisanyPlik['SERVERFILE']#" destination="#expandPath(src)#" />
			
			<!---<cfset plikMaterialu = model("promocja_kampania").dodajPlikDoMaterialuKampanii(idKampanii=URL.idKampanii,idMaterialuKampanii=URL.idMaterialuKampanii,idTypuMaterialuReklamowego=URL.idTypuMaterialuReklamowego,userId=session.user.id,srcMaterialu=src) />--->
			<cfset files = model("store_contractor_file").create(filename=FORM.plikMaterialuNazwa, filesrc=filename, contractorid=params.contractorid, createddate=Now(), userid=session.user.id) />
		</cfif>--->
		
		<cfset files = model("store_contractor_file").findByKey(params.fileid) />
		
		<cfif IsObject(files)>
			<cfset src = ExpandPath('files/contractors/') & files.filesrc />
			<cffile action="delete" file="#src#" />
			
			<cfset files.delete() />
		</cfif>
		
		<!---<cfset usesLayout(false) />--->
		<!---<cfset renderNothing() />--->
		
		<cfset json = files />
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
</cfcomponent>