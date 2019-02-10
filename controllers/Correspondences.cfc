<cfcomponent
	extends="Controller"
	output="false">

	<cffunction
		name="init">

		<cfset super.init() />

	</cffunction>

	<cffunction
		name="index"
		hint="Widok prezentujący tabelkę do wpisania rejestru korespondencji">

		<cfinvoke
			component="controllers.Tree_groupusers"
			method="checkUserTreeGroup"
			returnvariable="priv" >

		<cfinvokeargument
				name="groupname"
				value="Rejestr korespondencji" />

		</cfinvoke>

		<cfif priv is false>
			<cfset redirectTo(controller="Users",action="view",key=session.user.id,message="Nie masz uprawnień do przeglądania tej strony.") />
		</cfif>

		<!---
			05.03.2013
			Buduje filtr do przeszukiwania książki nadawczej.
		--->
		<cfparam
			name="data_od"
			default="#DateFormat(Now(), 'yyyy-mm-dd')#" />

		<cfparam
			name="data_do"
			default="#DateFormat(Now(), 'yyyy-mm-dd')#" />

		<cfparam
			name="adresat"
			default="" />

		<cfparam
			name="correspondence_page"
			default="1" />

		<cfparam
			name="elements"
			default="20" />

		<!---
			Sprawdzam, czy te pola są przechowywane w sesji. Jak tak to wstawiam
			domyślne wartości do zmiennych.
		--->
		<cfif structKeyExists(session, "correspondence_filter") and
			 structKeyExists(session.correspondence_filter, "data_od")>
			 <cfset data_od = session.correspondence_filter.data_od />
		</cfif>

		<cfif structKeyExists(session, "correspondence_filter") and
			structKeyExists(session.correspondence_filter, "data_do")>
			<cfset data_do = session.correspondence_filter.data_do />
		</cfif>

		<cfif structKeyExists(session, "correspondence_filter") and
			structKeyExists(session.correspondence_filter, "adresat")>
			<cfset adresat = session.correspondence_filter.adresat />
		</cfif>

		<cfif structKeyExists(session, "correspondence_filter") and
			structKeyExists(session.correspondence_filter, "correspondence_page")>
			<cfset correspondence_page = session.correspondence_filter.correspondence_page />
		</cfif>

		<!---
			Zapisuje w sesji wszystkie ustawienia filtra.
		--->
		<cfset session.correspondence_filter = {
			data_od = data_od,
			data_do = data_do,
			adresat = adresat,
			page = correspondence_page,
			elements = elements} />

		<cfset session.correspondence_in_filter = {
			categoryid = "",
			typeid = "",
			page = 1,
			elements = 12} />

		<cfset session.correspondence_out_filter = {
			categoryid = "",
			typeid = "",
			page = 1,
			elements = 12,
			data_wyslania = ""} />

		<cfset correspondence = model("correspondence").getList(
			data_od = data_od,
			data_do = data_do,
			adresat = adresat,
			elements = elements,
			page = correspondence_page) />

		<cfset my_types = model("correspondence_type").getTypes() />
		<cfset my_categories = model("correspondence_category").getCategories() />

		<cfset correspondence_in = model("correspondence_in").getCorrespondences() />
		<cfset correspondence_in_count = model("correspondence_in").getCorrespondences(
			count = true) />

		<cfset correspondence_out = model("correspondence_out").getCorrespondences() />
		<cfset correspondence_out_count = model("correspondence_out").getCorrespondences(
			count = true) />

		<!---<cfset my_list = model("correspondence").todayList() />--->

	</cffunction>

	<cffunction
		name="newList"
		hint="Nowa lista korespondencji">

		<!---
			05.03.2013
			Metoda dodająca nową listę korespondencji do systemu.

			Zakładam, że swoistym kluczem w liście jest dzień, w którym została
			sporządzona. Co za tym idzie, dodając nową listę sprawdzam najpierw
			czy nie ma już zdefiniowanej listy na dany dzień. Jeżeli jest to
			pobieram wszystkie weirsze i ją wyświetlam.

			Jeżeli nie ma takije listy to dodaje pusty wiersz co powoduje jej
			rozpoczęcie.

			Numery LP są brane na podstawie ilości wierszy już zapisanych.
		--->
		<!---<cfset list_count = model("correspondence").count(where="Day(correspondencecreated) = #DateFormat(Now(), 'dd')# AND Month(correspondencecreated) = #DateFormat(Now(), 'mm')# AND Year(correspondencecreated) = #DateFormat(Now(), 'yyyy')#") />--->

		<cfset list_count = model("correspondence").todayCount() />

		<cfif list_count.c eq 0>
			<!---
				Jeżeli nie ma jeszcze wierszy to lp ustawiam na 1.
			--->
			<cfset session.correspondence_lp = 1 />

			<!---
				Dodaje pierwszy wpis.
			--->
			<cfset new_list = model("correspondence").New() />
			<cfset new_list.lp = session.correspondence_lp />
			<cfset new_list.correspondencecreated = Now() />
			<cfset new_list.userid = session.userid />
			<cfset new_list.save(callbacks=false) />

			<cfset my_list = model("correspondence").findAll(where="id=#new_list.id#") />

		<cfelse>

			<cfset my_list = model("correspondence").todayList() />
			<cfset session.correspondence_lp = list_count.c />

		</cfif>

	</cffunction>

	<cffunction
		name="addRow"
		hint="Nowy wiersz listy" >

		<!---
			05.03.2013
			Dodaje nowy wiersz do listy korespondencji.
		--->

		<!---
			Tutaj powinienem dodać opcje sprawdzania, czy w sesji jest
			numer kolejnego wiersza.
		--->
		<cfset correspondenceNumber() />

		<cfset new_list = model("correspondence").New() />
		<cfset new_list.lp = session.correspondence_lp />
		<cfset new_list.correspondencecreated = Now() />
		<cfset new_list.userid = session.userid />
		<cfset new_list.save(callbacks=false) />

		<cfset my_list = model("correspondence").findAll(where="id=#new_list.id#") />

	</cffunction>

	<cffunction
		name="correspondenceNumber"
		access="private">

		<!---
			Metoda prywatna sprawdzająca, czy jest zdefiniowane pole w sesji
			z numerem wiersza na liście korespondencji.
		--->
		<cfif not structKeyExists(session, "correspondence_lp")>
			<cfset session.correspondence_lp = 1 />
		<cfelse>
			<cfset session.correspondence_lp++ />
		</cfif>

		<cfreturn true />

	</cffunction>

	<cffunction
		name="updateField"
		hint="Aktualizuje pole opisujące listę">

		<cfset to_update = model("correspondence").updateField(
			id = params.id,
			fieldname = params.field_name,
			fieldvalue = params.field_value) />

	</cffunction>

	<cffunction
		name="printList"
		hint="Drukowanie listy do pliku PDF">

		<!---
			Drukowanie listy do pliku PDF.
			Sprawdzam, czy jest przesłany parametr o formacie pliku.
			Jeżeli taki parametr jest to generuje plik, jak go nie ma to nic
			nie robię.
		--->
		<cfif structKeyExists(params, "format")>

			<cfset my_list = model("correspondence").getList(
				data_od = session.correspondence_filter.data_od,
				data_do = session.correspondence_filter.data_do,
				adresat = session.correspondence_filter.adresat) />

			<cfset renderWith(data="my_list",layout=false) />

		</cfif>

	</cffunction>

	<cffunction
		name="printTodayList"
		hint="Drukuje dzisiejszej listy do pliku PDF">

		<cfif structKeyExists(params, "format")>

			<cfset my_list = model("correspondence").getList(
				data_od = DateFormat(Now(), "yyyy-mm-dd"),
				data_do = DateFormat(Now(), "yyyy-mm-dd")) />

			<cfset renderWith(data="my_list",template="printlist",layout=false) />
		
		<cfelse>
			<cfset renderNothing() />
		</cfif>

	</cffunction>

	<cffunction
		name="autocomplete"
		hint="Autouzupełnianie adresata">

		<cfset autocomplete = model("correspondence").autocomplete(
			search = params.search) />

	</cffunction>

	<cffunction
		name="removeRow"
		hint="Usunięcie wiersza">

		<cfif structKeyExists(params, "key")>

			<cfset my_row = model("correspondence").findByKey(params.key) />
			<cfset my_row.delete() />

		</cfif>

	</cffunction>

	<cffunction
		name="newNormalLetters"
		hint="Lista normalnych listów, nie poleconych">

		<cfparam
			name="data_od"
			default="#Now()#" />

		<cfparam
			name="data_do"
			default="#Now()#" />

		<!---
			Sprawdzam czy zmienne są zapisane w sesji
		--->

		<cfif structKeyExists(session, "letters_filter") and
			structKeyExists(session.letters_filter, "data_od") >

			<cfset data_od = session.letters_filter.data_od />

		</cfif>

		<cfif structKeyExists(session, "letters_filter") and
			structKeyExists(session.letters_filter, "data_do")>

			<cfset data_do = session.letters_filter.data_do />

		</cfif>

		<!---
			Sprawdzam, czy dane nie zostały przesłane w parametrach.
		--->
		<cfif structKeyExists(params, "listy_data_od")>

			<cfset data_od = params.listy_data_od />

		</cfif>

		<cfif structKeyExists(params, "listy_data_do")>

			<cfset data_do = params.listy_data_do />

		</cfif>

		<!---
			Zapisuje dane w sesji
		--->
		<cfset session.letters_filter = {
			data_od = data_od,
			data_do = data_do} />

		<!---
			Sprawdzam, czy jest już dodany wpis z listami na aktualny dzień.
			Jak wpisu nie ma to go tworzę i zwracam pusty wiersz.
			Jak wpisy są to zwracam je.
		--->
		<cfset letters_count = model("correspondence_letter").getLettersCount(
			data_od = data_od,
			data_do = data_do) />

		<!---
			Nie ma zdefiniowanych listów na dany dzień.
			Tworzę pierwszy wpis.
		--->
		<cfif letters_count.c eq 0>

			<cfset new_letter = model("correspondence_letter").new() />
			<cfset new_letter.created = Now() />
			<cfset new_letter.userid = session.userid />
			<cfset new_letter.save() />

			<cfset my_list = model("correspondence_letter").findAll(where="id=#new_letter.id#") />

		<cfelse>

			<cfset my_list = model("correspondence_letter").getLetters(
				data_od = data_od,
				data_do = data_do) />

		</cfif>

		<cfset my_types = model("correspondence_type").getTypes() />

		<cfif isPost() and isAjax()>

			<cfset renderWith(data="my_list,my_types",layout=false,template="ajax_search") />

		</cfif>

	</cffunction>

	<cffunction
		name="addLetterRow"
		hint="Dodaje nowy wiersz opisujący zwykłe listy">

		<cfset new_letter = model("correspondence_letter").new() />
		<cfset new_letter.created = Now() />
		<cfset new_letter.userid = session.userid />
		<cfset new_letter.save() />

		<cfset my_types = model("correspondence_type").getTypes() />

	</cffunction>

	<cffunction
		name="removeLetterRow"
		hint="Usunięcie wiersza opisującego zwykłą korespondencję">

		<cfset my_letter = model("correspondence_letter").findByKey(params.key) />
		<cfset my_letter.delete() />

	</cffunction>

	<cffunction
		name="updateLetterField"
		hint="Aktualizacja poka opisującego listy do wysłania">

		<cfset to_update = model("correspondence_letter").updateLetterField(
			id = params.id,
			fieldname = params.field_name,
			fieldvalue = params.field_value) />

	</cffunction>

	<cffunction
		name="printNormalLetters"
		hint="Generowanie dokumentu PDF z liczbą listów wysłanych danego dnia">

		<!---
			Najpierw sprawdzam, czy przekazano format danych wynikowych.
		--->
		<cfif structKeyExists(params, "format")>

			<!---
				Dane Plik z danymi wynikowymi może zawierać listę tylko listów
				wysłanych aktualnego dnia.
			--->
			<cfset my_list = model("correspondence_letter").printLetters(
				data_od = Now(),
				data_do = Now()) />

			<cfset renderWith(data="my_list",falout=false) />

		</cfif>

	</cffunction>

	<cffunction
		name="income"
		hint="Korespondencja przychodząca">

		<cfif tree_check_user_group(groupname="Korespondencja przychodząca") is false>
			<cfset redirectTo(back=true,error="Nie masz uprawnień do przeglądania tej strony") />
		</cfif>

		<!---
			Definiuje parametry do filtrowania korespondencji przychodzącej
		--->
		<cfparam
			name="data_od"
			default="#Now()#" />

		<cfparam
			name="data_do"
			default="#Now()#" />

		<cfparam
			name="adresat"
			default="" />

		<cfparam
			name="nr_ewidencyjny"
			default="" />

		<!---
			Sprawdzam, czy przechowuje filtr w sesji.
		--->
		<cfif StructKeyExists(session, "correspondence_income_filter") and
				StructKeyExists(session.correspondence_income_filter, "data_od")>

			<cfset data_od = session.correspondence_income_filter.data_od />

		</cfif>

		<cfif StructKeyExists(session, "correspondence_income_filter") and
				StructKeyExists(session.correspondence_income_filter, "data_do")>

			<cfset data_do = session.correspondence_income_filter.data_do />

		</cfif>

		<cfif StructKeyExists(session, "correspondence_income_filter") and
				StructKeyExists(session.correspondence_income_filter, "adresat")>

			<cfset adresat = session.correspondence_income_filter />

		</cfif>

		<cfif StructKeyExists(session, "correspondence_income_filter") and
				StructKeyExists(session.correspondence_income_filter, "nr_ewidencyjny")>

			<cfset nr_ewidencyjny = session.correspondence_income_filter />

		</cfif>

		<!---
			Sprawdza, czy filtr został przekazany do metody
		--->
		<cfif StructKeyExists(params, "data_od")>
			<cfset data_od = params.data_od />
		</cfif>

		<cfif StructKeyExists(params, "data_do")>
			<cfset data_do = params.data_do />
		</cfif>

		<cfif StructKeyExists(params, "adresat")>
			<cfset adresat = params.adresat />
		</cfif>

		<cfif StructKeyExists(params, "nr_ewidencyjny")>
			<cfset nr_ewidencyjny = params.nr_ewidencyjny />
		</cfif>

		<!---
			Zapisuje w sesji ustawienia filtra
		--->
		<cfset session.correspondence_income_filter = {
			data_od = data_od,
			data_do = data_do,
			adresat = adresat,
			nr_ewidencyjny = nr_ewidencyjny} />

		<cfset my_income = model("correspondence_income").income(
			data_od = data_od,
			data_do = data_do,
			adresat = adresat,
			nr_ewidencyjny = nr_ewidencyjny) />

	</cffunction>


	<!---
		21.03.2013
		Metody filtrujące korespondencje w Intranecie

		filterCorrespondence - filtrowanie książki nadawczej
		filterCorrespondenceIn - filtrowanie korespondencji przychodzącej
		filterCorrespondenceOut - filtrowanie korespondencji wychodzącej
	--->
	<cffunction
		name="filterCorrespondence"
		hint="Filtrowanie książki nadawczej">

		<!---
			21.03.2013
			Buduje filtr do przeszukiwania książki nadawczej.
		--->
		<cfparam
			name="data_od"
			default="#DateFormat(Now(), 'yyyy-mm-dd')#" />

		<cfparam
			name="data_do"
			default="#DateFormat(Now(), 'yyyy-mm-dd')#" />

		<cfparam
			name="adresat"
			default="" />

		<!---
			Sprawdzam, czy te pola są przechowywane w sesji. Jak tak to wstawiam
			domyślne wartości do zmiennych.
		--->
		<cfif structKeyExists(session, "correspondence_filter") and
			 structKeyExists(session.correspondence_filter, "data_od")>
			 <cfset data_od = session.correspondence_filter.data_od />
		</cfif>

		<cfif structKeyExists(session, "correspondence_filter") and
			structKeyExists(session.correspondence_filter, "data_do")>
			<cfset data_do = session.correspondence_filter.data_do />
		</cfif>

		<cfif structKeyExists(session, "correspondence_filter") and
			structKeyExists(session.correspondence_filter, "adresat")>
			<cfset adresat = session.correspondence_filter.adresat />
		</cfif>

		<!---
			Sprawdzam, czy przesłano parametry w argumentach.
			Jak tak to zapisuje najbardziej aktualne parametry
		--->
		<cfif structKeyExists(params, "data_od")>
			<cfset data_od = params.data_od />
		</cfif>

		<cfif structKeyExists(params, "data_do")>
			<cfset data_do = params.data_do />
		</cfif>

		<cfif structKeyExists(params, "adresat")>
			<cfset adresat = params.adresat />
		</cfif>

		<!---
			Zapisuje w sesji ustawienia filtra i pobieram dane do widoku
		--->
		<cfset session.correspondence_filter = {
			data_od = data_od,
			data_do = data_do,
			adresat = adresat} />

		<cfset correspondence = model("correspondence").getList(
			data_od = data_od,
			data_do = data_do,
			adresat = adresat) />

		<cfset renderWith(data="correspondence",template="_ksiazka_nadawcza",layout=false) />

	</cffunction>

	<cffunction
		name="filterCorrespondenceOut"
		hint="Filtrowanie wychodzącej korespondencji">

		<!---
			21.03.2013
			Parametry do filtrowania korespondencji wychodzącej
		--->
		<cfparam
			name="data_wyslania"
			default="#Now()#" />

		<cfparam
			name="typeid"
			default="" />

		<cfparam
			name="categoryid"
			default="" />

		<cfparam
			name="search"
			default="" />

		<cfparam
			name="page"
			default="1" />

		<cfparam
			name="elements"
			default="12" />

		<!---
			Sprawdzam, czy dane są w sesji. Jak są to
		--->
		<cfif structKeyExists(session, "correspondence_out_filter") and
			structKeyExists(session.correspondence_out_filter, "data_wyslania")>
			<cfset data_wyslania = session.correspondence_out_filter.data_wyslania />
		</cfif>

		<cfif structKeyExists(session, "correspondence_out_filter") and
			structKeyExists(session.correspondence_out_filter, "typeid")>
			<cfset typeid = session.correspondence_out_filter.typeid />
		</cfif>

		<cfif structKeyExists(session, "correspondence_out_filter") and
			structKeyExists(session.correspondence_out_filter, "categoryid") >
			<cfset categoryid = session.correspondence_out_filter.categoryid />
		</cfif>

		<cfif structKeyExists(session, "correspondence_out_filter") and
			structKeyExists(session.correspondence_out_filter, "search")>
			<cfset search = session.correspondence_out_filter.search />
		</cfif>

		<cfif structKeyExists(session, "correspondence_out_filter") and
			structKeyExists(session.correspondence_out_filter, "page")>
			<cfset page = session.correspondence_out_filter.page />
		</cfif>

		<cfif structKeyExists(session, "correspondence_out_filter") and
			structKeyExists(session.correspondence_out_filter, "elements")>
			<cfset elements = session.correspondence_out_filter.elements />
		</cfif>

		<!---
			Sprawdzam, czy przesłano wyniki w formularzu
		--->
		<cfif structKeyExists(params, "data_wyslania")>
			<cfset data_wyslania = params.data_wyslania />
		</cfif>

		<cfif structKeyExists(params, "typeid")>
			<cfset typeid = params.typeid />
		</cfif>

		<cfif structKeyExists(params, "categoryid")>
			<cfset categoryid = params.categoryid />
		</cfif>

		<cfif structKeyExists(params, "search")>
			<cfset search = params.search />
		</cfif>

		<cfif structKeyExists(params, "elements")>
			<cfset elements = params.elements />
		</cfif>

		<cfif structKeyExists(params, "page")>
			<cfset page = params.page />
		</cfif>

		<cfset session.correspondence_out_filter = {
			data_wyslania = data_wyslania,
			typeid = typeid,
			categoryid = categoryid,
			search = search,
			page = page,
			elements = elements} />

		<cfset correspondence_out = model("correspondence_out").getCorrespondences(
			data_wyslania = data_wyslania,
			typeid = typeid,
			categoryid = categoryid,
			search = search,
			page = page,
			elements = elements) />

		<cfset correspondence_out_count = model("correspondence_out").getCorrespondences(
			data_wyslania = data_wyslania,
			typeid = typeid,
			categoryid = categoryid,
			search = search,
			count = true) />

		<cfset my_types = model("correspondence_type").getTypes() />
		<cfset my_categories = model("correspondence_category").getCategories() />

		<cfset renderWith(data="my_list,my_types,my_categories",template="_rejestr_poczty_wychodzacej",layout=false) />

	</cffunction>
	
	<!---
		delCorrespondenceOutRow		Usunięcie wiersza z tabeli rejestru poczty wychodzącej
	--->
	<cffunction
		name="delCorrespondenceOutRow"
		hint="Usunięcie wiersza poczty wychodzącej">
			
		<cfif isDefined("params.key")>
			<cfset delRow = model("correspondence_out").del(id = params.key) />
		</cfif>
		
		<cfset redirectTo(controller="Correspondences",action="filterCorrespondenceOut") />
			
	</cffunction>

	<cffunction
		name="correspondenceOutPrint"
		hint="Generowanie pliku PDF z rejestrem poczty wychodzącej">

		<cfset my_list = model("correspondence_out").getCorrespondences(
			data_wyslania = session.correspondence_out_filter.data_wyslania,
			typeid = session.correspondence_out_filter.typeid,
			categoryid = session.correspondence_out_filter.categoryid,
			allRows = true) />

		<cfset renderWith(data="my_list",template="correspondenceoutprint",layout=false) />

	</cffunction>

	<cffunction
		name="filterCorrespondenceIn"
		hint="Filtrowanie korespondencji przychodzącej" >

		<!---
			Definiuje odpowiednie parametry filtrowania
		--->
		<cfparam
			name="data_wplywu"
			default="#Now()#" />

		<cfparam
			name="pismo_z_dn"
			default="#Now()#" />

		<cfparam
			name="typeid"
			default="" />

		<cfparam
			name="categoryid"
			default="" />

		<cfparam
			name="search"
			default="" />

		<cfparam
			name="elements"
			default="12" />

		<cfparam
			name="page"
			default="1" />

		<!---
			Sprawdzam, czy są zdefiniowane te zeminne w sesji.
		--->
		<cfif structKeyExists(session, "correspondence_in_filter") and
			structKeyExists(session.correspondence_in_filter, "data_wplywu")>
			<cfset data_wplywu = session.correspondence_in_filter.data_wplywu />
		</cfif>

		<cfif structKeyExists(session, "correspondence_in_filter") and
			structKeyExists(session.correspondence_in_filter, "pismo_z_dn")>
			<cfset pismo_z_dn = session.correspondence_in_filter.pismo_z_dn />
		</cfif>

		<cfif structKeyExists(session, "correspondence_in_filter") and
			structKeyExists(session.correspondence_in_filter, "typeid")>
			<cfset typeid = session.correspondence_in_filter.typeid />
		</cfif>

		<cfif structKeyExists(session, "correspondence_in_filter") and
			structKeyExists(session.correspondence_in_filter, "categoryid")>
			<cfset categoryid = session.correspondence_in_filter.categoryid />
		</cfif>

		<cfif structKeyExists(session, "correspondence_in_filter") and
			structKeyExists(session.correspondence_in_filter, "search")>
			<cfset search = session.correspondence_in_filter.search />
		</cfif>

		<cfif structKeyExists(session, "correspondence_in_filter") and
			structKeyExists(session.correspondence_in_filter, "page")>
			<cfset page = session.correspondence_in_filter.page />
		</cfif>

		<cfif structKeyExists(session, "correspondence_in_filter") and
			structKeyExists(session.correspondence_in_filter, "elements")>
			<cfset elements = session.correspondence_in_filter.elements />
		</cfif>

		<!---
			Sprawdzam, czy przesłano formularz filtrowania
		--->
		<cfif structKeyExists(params, "data_wplywu")>
			<cfset data_wplywu = params.data_wplywu />
		</cfif>

		<cfif structKeyExists(params, "pismo_z_dn")>
			<cfset pismo_z_dn = params.pismo_z_dn />
		</cfif>

		<cfif structKeyExists(params, "typeid")>
			<cfset typeid = params.typeid />
		</cfif>

		<cfif structKeyExists(params, "categoryid")>
			<cfset categoryid = params.categoryid />
		</cfif>

		<cfif structKeyExists(params, "search")>
			<cfset search = params.search />
		</cfif>

		<cfif structKeyExists(params, "elements")>
			<cfset elements = params.elements />
		</cfif>

		<cfif structKeyExists(params, "page")>
			<cfset page = params.page />
		</cfif>

		<!---
			Zapisuje filtr w sesji
		--->
		<cfset session.correspondence_in_filter = {
			data_wplywu = data_wplywu,
			pismo_z_dn = pismo_z_dn,
			typeid = typeid,
			categoryid = categoryid,
			search = search,
			page = page,
			elements = elements} />

		<cfset correspondence_in = model("correspondence_in").getCorrespondences(
			data_wplywu = data_wplywu,
			pismo_z_dn = pismo_z_dn,
			typeid = typeid,
			categoryid = categoryid,
			search = search,
			elements = elements,
			page = page) />

		<cfset correspondence_in_count = model("correspondence_in").getCorrespondences(
			data_wplywu = data_wplywu,
			pismo_z_dn = pismo_z_dn,
			typeid = typeid,
			categoryid = categoryid,
			search = search,
			count = true) />

		<cfset my_types = model("correspondence_type").getTypes() />
		<cfset my_categories = model("correspondence_category").getCategories() />

		<cfset renderWith(data="my_list,my_types,my_categories",template="_rejestr_poczty_przychodzacej",layout=false) />

	</cffunction>

	<!---
		Metody edycji poczty
	--->
	<cffunction
		name="in"
		hint="Edycja książki poczty przychodzącej">

		<cfset my_types = model("correspondence_type").getTypes() />
		<cfset my_categories = model("correspondence_category").getCategories() />

	</cffunction>

	<cffunction
		name="out"
		hint="Edycja książki poczty wychodzącej">

		<cfset my_types = model("correspondence_type").getTypes() />
		<cfset my_categories = model("correspondence_category").getCategories() />

	</cffunction>

	<cffunction
		name="addInRow"
		hint="Dodanie wiersza tabeli poczty przychodzącej">

		<cfset new_row = model("correspondence_in").new() />
		<cfset new_row.userid = session.userid />
		<!---<cfset new_row.typeid = "" />--->
		<!---<cfset new_row.categoryid = "" />--->
		<cfset new_row.save(callbacks=false) />

		<cfset my_types = model("correspondence_type").getTypes() />
		<cfset my_categories = model("correspondence_category").getCategories() />

	</cffunction>

	<cffunction
		name="addOutRow"
		hint="Dodanie wiersza tabeli poczty wychodzącej">

		<cfset new_row = model("correspondence_out").new() />
		<cfset new_row.userid = session.userid />
		<!---<cfset new_row.typeid = 0 />--->
		<!---<cfset new_row.categoryid = 0 />--->
		<cfset new_row.save(callbacks=false) />

		<cfset my_types = model("correspondence_type").getTypes() />
		<cfset my_categories = model("correspondence_category").getCategories() />

	</cffunction>

	<cffunction
		name="updateCorrespondenceIn"
		hint="Aktualizacja pola korespondencji przychodzącej">

		<cfset to_update = model("correspondence_in").updateField(
			id = params.id,
			fieldname = params.field_name,
			fieldvalue = params.field_value) />

		<cfset renderWith(data="to_update",layout=false) />

	</cffunction>

	<cffunction
		name="updateCorrespondenceOut"
		hint="Aktualizacja pola korespondencji przychodzącej">

		<cfset to_update = model("correspondence_out").updateField(
			id = params.id,
			fieldname = params.field_name,
			fieldvalue = params.field_value) />

		<cfset renderWith(data="to_update",layout=false) />

	</cffunction>

</cfcomponent>