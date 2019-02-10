<cfcomponent
	extends="Controller">

	<cffunction
		name="init">
		<cfset super.init() />
		<cfset filters(through="before",type="before") />
	</cffunction>

	<cffunction
		name="before">

		<cfset usesLayout(template="/layout") />

	</cffunction>

	<!---
		13.02.2013
		Metoda pozwalająca na zarządzanie regałami w sklepie.
		Marketing może definiować typy regałów, kategorie i przypisywać je
		do sklepu.
	--->
	<cffunction name="index" output="false" access="public" hint="Metoda zarządzająca regałami w sklepie">

		<!---
			Kategorie regałów
		--->
		<cfset shelf_categories = model("store_shelfcategory").findAll(order="shelfcategoryname ASC") />

		<!---
			Typy regałów
		--->
		<cfset shelf_types = model("store_shelftype").findAll(order="shelftypename ASC") />

		<cfset myStoreTypes = model("store_type").getTypes() />

		<!---
			Lista zdefiniowanych regałów
		--->
		<cfparam name="page" default="1" />
		<cfparam name="elements" default="20" />

		<cfif StructKeyExists(session, "shelfs") AND StructKeyExists(session.shelfs, "page")>
			<cfset page = session.shelfs.page />
		</cfif>

		<cfif StructKeyExists(session, "shelfs") AND StructKeyExists(session.shelfs, "elements")>
			<cfset elements = session.shelfs.elements />
		</cfif>

		<cfif StructKeyExists(params, "page")>
			<cfset page = params.page />
		</cfif>

		<cfif StructKeyExists(params, "elements")>
			<cfset elements = params.elements />
		</cfif>

		<cfset session.shelfs = {
			page = page,
			elements = elements } />

		<cfset shelfs = model("store_shelf").getDefinedShelfs(page = page, elements = elements) />
		<cfset shelfsCount = model("store_shelf").getDefinedShelfsCount() />
		<cfset stores = model("store_store").searchStores() />

	</cffunction>

	<cffunction
		name="getShelfs"
		hint="Zwrócenie tabelki z listą zdefiniowanych regałów"
		description="Metoda jest wykorzystywana do generowania paginowanej
				tabelki z regałami" >

		<cfparam
			name="page"
			default="1" />

		<cfparam
			name="elements"
			default="20" />

		<cfif StructKeyExists(session, "shelfs") AND StructKeyExists(session.shelfs, "page")>
			<cfset page = session.shelfs.page />
		</cfif>

		<cfif StructKeyExists(session, "shelfs") AND StructKeyExists(session.shelfs, "elements")>
			<cfset elements = session.shelfs.elements />
		</cfif>

		<cfif StructKeyExists(params, "page")>
			<cfset page = params.page />
		</cfif>

		<cfif StructKeyExists(params, "elements")>
			<cfset elements = params.elements />
		</cfif>

		<cfset session.shelfs = {
			page = page,
			elements = elements } />

		<cfset shelfs = model("store_shelf").getDefinedShelfs(
			page = page,
			elements = elements) />

		<cfset shelfsCount = model("store_shelf").getDefinedShelfsCount() />

		<cfset usesLayout(false) />

	</cffunction>

	<!---
		14.02.2013
		Przypisanie regału do odpowiednich sklepów.
	--->
	<cffunction
		name="assignToStores"
		hint="Metoda przypisująca regał do odpowiednich sklepów">

		<!---
			Aby przypisać wszystkie regały do sklepu muszę przejść w pętli
			przez wszystkie regały a następnie sklepy.
		--->
		<cfif structKeyExists(params, "shelfid") and structKeyExists(params, "storeid")>

			<cfset tmp_shelfs = params.shelfid />
			<cfset tmp_stores = params.storeid />

			<cfloop collection="#tmp_shelfs#" item="i" >
				<cfloop collection="#tmp_stores#" item="j" >
					<cfif not model("store_storeshelf").ifExists(
						shelfid = i,
						storeid = j)>
						
						<cfset new_store_shelf = model("store_storeshelf").new() />
						<cfset new_store_shelf.shelfid = i />
						<cfset new_store_shelf.storeid = j />
						<cfset new_store_shelf.storeshelfvisible = 1 />
						<cfset new_store_shelf.save(callbacks=false) />
					
					</cfif>
				</cfloop>
			</cfloop>

		</cfif>

		<cfset redirectTo(back="true") />

	</cffunction>

	<!---
		Metoda pobierająca listę sklepów, które mają przypisany dany regał.
	--->
	<cffunction
		name="getStores"
		hint="Metoda listująca sklepy, które posiadają dany regał">

		<cfset stores = model("store_storeshelf").getStoresByShelf(
			shelfid		=	params.key) />

	</cffunction>

	<!---
		Zapisanie nowej kategorii regałów.
	--->
	<cffunction
		name="addCategory"
		hint="Metoda zapisująca nową kategorię regałów">

		<cfset new_category = model("store_shelfcategory").new() />
		<cfset new_category.shelfcategoryname = params.shelfcategoryname />
		<cfset new_category.userid = session.userid />
		<cfset new_category.save(callbacks=false) />

		<cfset redirectTo(controller="Store_shelfs",action="newCategory") />

	</cffunction>

	<!---
		Okienko dodawania nowej kategorii.
	--->
	<cffunction
		name="newCategory"
		hint="Okienko dodawania nowej kategorii">

		<cfset usesLayout(false) />

	</cffunction>

	<!---
		Akcja zapisywania nowego typu regału
	--->
	<cffunction
		name="addType"
		hint="Metoda zapisująca nowy typ regałów">

		<cfset new_type = model("store_shelftype").new() />
		<cfset new_type.shelftypename = params.w & " H" & params.h />
		<!---<cfset new_type.number_of = params.number_of />--->
		<cfset new_type.userid = session.userid />
		<cfset new_type.save(callbacks=false) />

		<cfset redirectTo(controller="Store_shelfs",action="newType") />

	</cffunction>

	<!---
		Okienko dodawania nowego typu regału.
	--->
	<cffunction
		name="newType"
		hint="Okienko dodawania nowego typu regału" >

		<cfset usesLayout(false) />

	</cffunction>

	<!---
		Dodawanie nowego regału. Regał jest połączeniem kategorii z typem.
	--->
	<cffunction
		name="addShelf"
		hint="Metoda dodająca nowy regał.">

		<cfset new_shelf = model("store_shelf").new() />
		<cfset new_shelf.shelftypeid = params.shelftypeid />
		<cfset new_shelf.shelfcategoryid = params.shelfcategoryid />
		<cfset new_shelf.storetypeid = params.storetypeid />
		<cfset new_shelf.userid = session.userid />
		<cfset new_shelf.number_of = Replace(params.number_of, ",", ".", "all" ) />
		<cfset new_shelf.save(callbacks=false) />

		<cfset redirectTo(controller="Store_shelfs",action="newShelf") />

	</cffunction>

	<cffunction
		name="newShelf"
		hint="Formularz dodawania nowego regału do systemu" >

		<cfset myStoreTypes = model("store_type").getTypes() />
		<cfset myShelfCategories = model("store_shelfcategory").findAll(order="shelfcategoryname ASC") />
		<cfset myShelfTypes = model("store_shelftype").findAll(order="shelftypename ASC") />

		<cfset usesLayout(false) />

	</cffunction>

	<cffunction
		name="filterShelfs"
		hint="Filtr po regałach">

		<cfset myShelfs = model("store_shelf").filterShelfs(
			storetypeid = params.storetypeid,
			shelftypeid = params.shelftypeid,
			shelfcategoryid = params.shelfcategoryid) />

		<cfset json = QueryToStruct(Query=myShelfs) />
		<cfset renderWith(data="json",template="json",layout=false) />

	</cffunction>
	
	<cffunction
		name="validateNewShelf"
		hint="Walidacja przed dodaniem nowego regału. Jest sprawdzane, czy taki
			regał już istnieje czy jeszcze nie">
	
		<cfset myShelf = model("store_shelf").count(
			storetypeid = FORM.storetypeid,
			shelftypeid = FORM.shelftypeid,
			shelfcategoryid = FORM.shelfcategoryid) />
			
		<cfif myShelf.c NEQ 0>
			
			<cfset json = {
				STATUS = "false",
				MESSAGE = "Istnieje już taki regał.",
				CLS = "darkRed"} />
				
		<cfelse>
			
			<cfset json = {
				STATUS = "true",
				MESSAGE = "Nie ma w systemie takiego regału.",
				CLS = ""} />
			
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	
	</cffunction>
	
	<cffunction
		name="validateNewShelfCategory"
		hint="Walidacja przed dodaniem nowej kategorii regały. Jeżeli nie ma
			jeszcze tej kategorii to ją dodaję. Jak jest to nic nie robię.">
	
		<cfset myCategory = model("store_shelf").countCategories(
			categoryname = FORM.categoryname) />
			
		<cfif myCategory.c NEQ 0>
			
			<cfset json = {
				STATUS = "false",
				MESSAGE = "Istnieje już taka kategoria.",
				CLS = "darkRed"} />
				
		<cfelse>
			
			<cfset json = {
				STATUS = "true",
				MESSAGE = "Nie ma w systemie takiej kategorii.",
				CLS = ""} />
			
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	
	</cffunction>
	
	<cffunction
		name="validateNewShelfType"
		hint="Walidacja przed dodaniem nowego typu. Jeżeli typ już istnieje
			to nie mozna go dodać ponownie">
	
		<cfset myType = model("store_shelf").countTypes(
			shelftypename = FORM.w & " H" & FORM.h) />
			
		<cfif myType.c NEQ 0>
			
			<cfset json = {
				STATUS = "false",
				MESSAGE = "Istnieje już taki typ.",
				CLS = "darkRed"} />
				
		<cfelse>
			
			<cfset json = {
				STATUS = "true",
				MESSAGE = "Nie ma w systemie takiego typu.",
				CLS = ""} />
			
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	
	</cffunction>
	
	<cffunction name="removeShelf" output="false" access="public">
		<cfset toRemove = model("store_shelf").remove(params.key) />
		<cfset json = {
			STATUS = "true",
			MESSAGE = "Usunięto"} />
			
		<!---<cfset redirectTo(back=true) />--->
		<cfset renderWith(data="json",template="json",layout=false) />
	</cffunction>

</cfcomponent>