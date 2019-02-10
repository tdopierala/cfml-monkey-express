<cfcomponent
	extends="Controller">

	<cffunction
		name="init">

		<cfset super.init() />
		<cfset provides("html,xml,json,pdf")>
		<cfset filters("beforeRender") />

	</cffunction>

	<cffunction
		name="beforeRender">

		<cfset usesLayout(template="/layout",ajax=false) />

	</cffunction>

	<cffunction
		name="index"
		hint="Wyszukiwanie nieruchomości z bazy"
		description="Strona zawiera formularz wyszukiwania nieruchomości">

		<cfset provinces = model('province').findAll() />


	</cffunction>

	<cffunction
		name="add"
		hint="Formularz dodawania nowej nieruchomości do bazy"
		description="Formularz dodawania nowej nieruchomości do bazy. W tym kroku są wprowadzane ogólne dane.">

		<cfset provinces = model("province").findAll(select="id,provincename") /> <!--- Województwa --->

	</cffunction>

	<cffunction
		name="view"
		hint="Podgląd nieruchomości"
		description="Metoda daje możliwość podglądu nieruchomości, wszystkich wprowadzonych informacji. Można też dodać nowe informacje: dokumenty, zdjęcia, itp">

		<cfset place = model('place').findByKey(params.key) />
		<cfset placeworkflow = model('placeWorkflow').findAll(where="placeid=#params.key#") />
		<cfset workflow = model("triggerPlaceStepList").findOne(where="placeid=#params.key#") />

	</cffunction>

	<cffunction
		name="actionAdd"
		hint="Stworzenie nowej nieruchomości."
		description="W tym kroku zapisywane są dane o lokalizacji. Dodawanie plików czy uzupełnianie danych o lokalizacji odbywa się w kolejnych zakładkach edycji nieruchomości.">

<!--- 		<cfdump var="#params#" /> --->
<!--- 		<cfabort /> --->

		<cftry>

			<!---
			Zapisywanie danych nieruchomości odbywa się w kilku krokach.
			Pierwszym etapem jest zapisanie miasta, ulicy, województwa. Później pobierany jest xml z geolokalizacją.
			--->
			<!--- 1. Łączę się z google api i pobieram dane --->
			<cfhttp url="http://maps.googleapis.com/maps/api/geocode/xml?address=#stripPolishChars(params.address)#,#stripPolishChars(params.cityid)#,#stripPolishChars(params.provinceid)#,Poland&sensor=false" method="get" result="urlresult" charset="utf-8" />

<!--- 			<cfdump var="#urlresult#" /> --->
<!--- 			<cfabort /> --->

			<cfset provincename = model('province').findOne(where="id=#params.provinceid#") />

			<!--- 2. Zapisuje dane w tabeli z lokalizacją --->
			<cfset myplace = model('place').new() />
			<cfset myplace.xmlgeocoding = ToString(Trim(urlresult.Filecontent)) /> <!--- zml z danymi geolokalizacji --->
			<cfset myplace.lat = params.lat /> <!--- lat --->
			<cfset myplace.lng = params.lng /> <!--- lng --->
			<cfset myplace.address = params.address />
			<cfset myplace.cityname = params.cityid /> <!--- Nazwa miasta --->
			<cfset myplace.provinceid = params.provinceid /> <!--- ID województwa --->
			<cfset myplace.provincename = provincename.provincename /> <!--- Nazwa województwa --->
			<cfset myplace.placecreated = Now() />
			<cfset myplace.placeuserid = session.userid />
			<cfset myplace.districtname = params.district />
			<cfset myplace.userid = session.userid />
			<!---
			7.09.2012
			Dodaje aktualny krok i status nieruchomości.
			--->
			<cfset myplace.placestepid = 1 />
			<cfset myplace.placestatusid = 1 />

			<cfset myplace.save() /> <!--- Zapisanie lokalizacji w bazie --->

			<!---
			03.08.2012
			Po zapisaniu lokalizacji generuje pusty katalog na serwerze, który będzie zawierał wszystkie niezbędne pliki.
			--->
			<cfdirectory action="create" directory="#ExpandPath('files/places/#myplace.id#')#" mode="777" />

			<!---
			Kolejnym krokiem po zapisaniu lokalizacji jest przekierowanie na stornę zawierającą wszystkie
			informacje o danym miejscu.
			--->
			<cfset redirectTo(controller="Places",action="view",key=myplace.id) />


		<cfcatch type="any">

			<cfif IsAjax()>

				<cfset error = cfcatch.message />
				<cfset renderWith(data=error,template="/apperror",layout=false) />

			<cfelse>

				<cfset error = cfcatch.message />
				<cfset renderWith(data=error,template="/apperror",layout="/layout") />

			</cfif>

		</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="geolocalization"
		hint="Metoda łączy się z serwerem google i pobiera JSON z lokalizacją punktu"
		description="Metoda łączy się z serwerem google i pobiera JSON z pełnymi danymi punktu na mapie. Metoda służy do geolokalizacji na podstawie wpisanego adresu.">

		<cfhttp url="http://maps.googleapis.com/maps/api/geocode/xml?address=#stripPolishChars(params.streetname)#,#stripPolishChars(params.cityname)#,#stripPolishChars(params.provincename)#,Poland&sensor=false" method="get" result="result" charset="utf-8" />

		<cfif IsAjax()>

			<cfset renderWith(data=result,layout=false) />

		</cfif>

	</cffunction>

	<cffunction
		name="getDistricts"
		hint="Pobranie listy powiatów pasujących do województwa"
		description="Metoda pobiera listę powiatów, które pasują do wybranego województwa. Jeśli nie wybrano woj. lub nazwa nie pasuje to zwracam wszystkie powiaty.">

		<!--- Jeśli nie wybrałem województwa lub jest ono puste to zwracam wszystkie powiaty --->
		<cfif StructKeyExists(params, "key") and Len(params.key)>

			<cfset districts = model("district").findAll(where="provinceid=#params.key#") />

		<cfelse>

			<cfset districts = model("district").findAll() />

		</cfif>

		<cfif IsAjax()>

			<cfset renderWith(data="districts",layout=false) />

		</cfif>

	</cffunction>

	<!---
	Aby wyszukać miasto w autocomplete przekazuje specyficzny ciąg znaków.
	WOJ:POW:MIASTO

	WOJ - id województwa
	POW - id powiatu
	MIASTO - litery z nazwy miasta

	Trzeba pamiętać, że parametrów WOJ i POW może nie być.
	--->
	<cffunction
		name="getCities"
		hint="Metoda zwracająca listę miast do autocomplete w formularzu dodawania nieruchomości">

		<!--- Ciąg znaków zawierający miasto do wyszukania --->
		<cfset searchparameters = ListToArray(params.search, ":") />

		<!---
		Sprawdzam wielkość tablicy
		Jeden wiersz - samo miasto
		Dwa wiersze - miasto i woj
		Trzy wiersze - miasto, woj i powiat
		--->

		<cfset citywhere = "" />
		<cfswitch expression="#ArrayLen(searchparameters)#">

			<!--- Jeśli tablica zawiera pierwszy element to znaczy, że miasto jest uzupełnione i mogę po nim wyszukiwać --->
			<cfcase value="1">
				<cfset citywhere = "cityname LIKE '%" & searchparameters[1] & "%'" />
			</cfcase>

			<!--- Jeżeli w tablicy jest drugi element to znaczy, że został przekazany id województwa --->
			<cfcase value="2">
				<cfset citywhere = "cityname LIKE '%" & searchparameters[1] & "%' AND provinceid=#searchparameters[2]#" />
			</cfcase>

			<!--- Jeśli w tablicy jest trzeci element to znaczy, że przekazano id powiatu --->
			<!---
			TODO
			Zmienił relacje między powiatem a miastem bo źle są wpisane identyfikatory
			--->
			<cfdefaultcase>
				<cfset citywhere = "cityname LIKE '%" & searchparameters[1] & "%' AND provinceid=#searchparameters[2]#" />
			</cfdefaultcase>

		</cfswitch>

		<!--- Mam zbudowane pełne zapytanie i teraz mogę wyszukiwać miasta --->
		<cfset cities = model("city").findAll(where=citywhere) />
		<cfset renderWith(data="cities",layout=false) />

	</cffunction>

	<cffunction
		name="search"
		hint="Wyszukiwanie nieruchomości"
		description="Metoda wyszukuje nieruchomości pasujących do kryteriów wyszukiwania. Przy generowaniu wyników wyszukiwania tworzona jest Google Mapka z naniesionymi lokalizacjami.">

		<!--- Jeśli nie przesłałem ID województwa to ustawiam wartość 0 --->
		<cfif !Len(params.province)>

			<cfset params.province = 0 />

		</cfif>
<!--- 		<cfset places = model("place").findAll() /> --->

		<!---
		10.09.2012
		Sprawdzam, czy nieruchomości wyszukuje Partner, czy członek Komitetu.
		--->
		<cfif checkUserGroup(userid=session.userid,usergroupname='Komitet')>

			<cfset places = model("place").searchPlaces(provinceid=params.province,cityname="#params.city#",streetname="#params.street#",partnername="#params.partner#") />

		<cfelse>

			<!---
			Lista nieruchomości Partnera ds ekspansji.
			--->
			<cfset places = model("place").searchPartnerPlaces(provinceid=params.province,cityname="#params.city#",streetname="#params.street#",partnername="#params.partner#",userid=session.userid) />

		</cfif>

		<!--- Wyciągam listę wszystkich kroków obiegu nieruchomości --->
		<cfset placesteps = model("placeStep").findAll() />

		<cfset renderPartial("googlemap") />
		<cfset renderPartial("searchresult") />

		<cfif IsAjax()>

			<cfset renderWith(data="places",layout=false) />

		</cfif>

	</cffunction>

	<cffunction
		name="files"
		hint="Pobranie listy plików przypisanych do nieruchomości"
		description="Metoda pobiera listę plikow przypisaną do nieruchomości. Przy plikach jest widoczna kategoria pliku oraz data dodania i użytkownika, który dodał zasób.">

		<cfset placeid = params.key />
		<cfset placefiles = model("place").getFiles(placeid=placeid) />

		<cfif IsAjax()>

			<cfset renderWith(data="placeid,placefiles",layout=false) />

		</cfif>

	</cffunction>

	<cffunction
		name="getFileCategories"
		hint="Pobieram z bazy typy plików, które mogę umieszczać przy nieruchomościach">

		<cfset var placefile = structNew() />
		<cfset placefile["placeid"] = params.placeid />
		<cfset placefile["fileid"] = params.fileid />

<!--- 		<cfdump var="#placefile#" /> --->
<!--- 		<cfabort /> --->

		<cfset filecategories = model("placeFileCategory").findAll(select="id,placefilecategoryname") />

		<cfset renderWith(data="filecategories,placefile",layout=false) />

	</cffunction>

	<cffunction
		name="actionAddFile"
		hint="Przypisywanie pliku do nieruchomości"
		description="Metoda przypisująca dodany przez uzytkownika plik do nieruchomości. Dodatkowo dodawany jest komentarz do pliku, który też jest zapisywany. Komentarze i plik do nieruchomości znajdują się w osobnych tabelach.">

		<cftry>

			<!--- Dodaje powiązanie pliku z nieruchomością --->
			<cfset myplacefile = model("placeFile").new() />
			<cfset myplacefile.fileid = params.fileid />
			<cfset myplacefile.placeid = params.placeid />
			<cfset myplacefile.placefilecategoryid = params.placefilecategories />
			<cfset myplacefile.placefilecreated = Now() />
			<cfset myplacefile.placefileuserid = session.userid />
			<cfset myplacefile.save(callbacks=false) />

			<!---
			03.08.2012
			Po dodaniu powiązania z plikiem generuje miniaturkę do galerii (jeśli jest to grafika);
			--->
			<cfset placeFile = model("placeFile").findAll(where="fileid=#params.fileid#",include="file,placeFileCategory") />
			<cfset myfile = model("file").findAll(select="id,filename,filesrc",where="id=#params.fileid#") />

			<!--- Jeżeli plik jest grafiką --->
			<cfif placeFile.isimage eq 1>

				<cffile action="copy" source="#ExpandPath('files/uploaded/thumb/#myfile.filename#')#" destination="#ExpandPath('files/places/#params.placeid#/')#" />

			</cfif>
			<!--- Koniec generowania miniaturki --->

			<!--- Dodaje komentarz do pliku --->
			<cfset myfilecomment = model("fileComment").new() />
			<cfset myfilecomment.fileid = params.fileid />
			<cfset myfilecomment.userid = session.userid />
			<cfset myfilecomment.filecommentdate = Now() />
			<cfset myfilecomment.filecommenttext = params.comment />
			<cfset myfilecomment.save(callbacks=false) />

			<!--- Po dodaniu powiązania i zapisaniu komentarza renderuje widok z odpowiednim komunikatem --->
			<cfset mymessage = "Plik został przypisany do nieruchomości. Komentarz został dodany." />
			<cfif IsAjax()>

				<cfset renderWith(data="mymessage",layout=false) />

			</cfif>

		<!--- Przechwytuje wyjątek i zwracam komunikat błędu --->
		<cfcatch type="any">

			<cfset error = cfcatch.message />

			<cfif IsAjax()>

				<cfset renderWith(data=error,layout=false,template="/apperror")/>

			<cfelse>

				<cfset renderWith(data=error,template="/apperror") />

			</cfif>

		</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="location"
		hint="Opis lokalizacji"
		description="Widok prezentujący formularz z opisem lokalizacji. Formularz zawiera pola wpisania przez użytkownika/partnera/koordynatora.">

		<!--- Pobieram atrybuty i ich wartości do widoku lokalizacji --->
		<cfset attributes = model("place").getAttributes(placeid=params.key) />
		<cfset renderWith(data="attributes",layout=false) />

	</cffunction>

	<cffunction
		name="photos"
		hint="Lista zdjęć lokalizacji"
		description="Wyświetlanie zdjęcia lokalizacji. Pobierana jest lista plików będących grafikami. Przed wyświetleniem pliku tworzona jest jego miniaturka.">

		<cfset place = model("place").findByKey(params.key) />
		<!---
		Kroki tej metody są dość skomplikowane. Kolejne etapy, które są realizowane to:
		- pobranie listy zdjęć przypisanych do lokalizacji
		- sprawdzenie, czy te pliki znajdują się w katalogu files/places/ID_LOKALIZACJI/ (miniaturki)
		- jeśli plików nie ma to tworze tam miniaturki, jeśli są to nic nie robię.
		--->

		<!--- Pobranie listy zdjęć przypisanych do lokalizacji --->
		<cfset photos = model("place").getPhotos(placeid=params.key) />

		<!--- Przechodzę przez wszystkie pliki przypisane do lokalizacji --->
		<!--- <cfloop query="photos"> --->

			<!--- Sprawdzam, czy istnieje miniaturka. Jeśli jej nie ma to ją generuję --->
			<!--- <cfif not FileExists(ExpandPath('files/places/#params.key#/#filename#'))> --->

				<!--- <cfimage action="info" structname="imagetemp" source="#filesrc#" /> --->
				<!--- <cfset x = min(300/imagetemp.width, 200/imagetemp.height) /> --->
				<!--- <cfset newwidth = x*imagetemp.width /> --->
				<!--- <cfset newheight = x*imagetemp.height /> --->
				<!--- <cfimage action="resize" source="#filesrc#" width="#newwidth#" height="#newheight#" destination="#expandPath('files/places/#params.key#/#filename#')#" overwrite="true" /> --->

			<!--- </cfif> --->

		<!--- </cfloop> --->

		<!--- Zwracam listę zmiennych do widoku --->
		<cfset renderWith(data="place,photos",layout=false) />

	</cffunction>

	<cffunction
		name="newPlaceForm"
		hint="Formularz zgłaszania lokalizacji"
		description="Formularz zgłaszania lokalizacji zaproponowany przez Iwonę Pytlak. Formularz jest pierwszym etapem realizacji modułu nieruchomości.">

		<cfset place = model("place").new() />

	</cffunction>

	<cffunction
		name="partner"
		hint="Formularz z danymi, które wypełnia partner"
		description="Formularz z danymi, które wypełnia partner. Jeszcze nie wiem jak zrobić uprawnienia do konkretnych pół formularza partnera">

		<cftry>

			<!--- Sprawdzam, czy użytkownik należy do odpowiedniej grupy --->
			<cfif !(checkUserGroup(userid=session.userid,usergroupname="Partner ds. ekspansji") OR
					checkUserGroup(userid=session.userid,usergroupname="root") OR
					checkUserGroup(userid=session.userid,usergroupname="Weryfikacja nieruchomości"))>

				<cfthrow type="Uprawnienia" message="Nie masz uprawnień do przeglądania tej strony. Prosimy o kontakt z Departamentem Informatyki" />

			</cfif>

			<!--- Get request from ColdFusion page contenxt. --->
			<cfset objRequest = GetPageContext().GetRequest() />

			<!--- Get requested URL from request object. --->
			<cfset session.lasturl = objRequest.GetRequestUrl().Append("?" & objRequest.GetQueryString()).ToString() />

			<cfset attributes = model("place").getAttributesByGroup(placeid=params.key,groupid=12) />

			<!---
			22.08.2012
			Pobieranie wartości pól wyboru odbywa się automatycznie.
			Przechodzę przez wszystkie atrybuty, sprawdzam typ i pobieram opcje.
			--->
			<cfset options = {} />
			<cfloop query="attributes">

				<!--- Jeżeli type jest SelectBox to pobieram jego opcje --->
				<cfif attributetypeid eq 5>

					<cfset options[attributeid] = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=#attributeid#",order="ord ASC") />

				</cfif>

			</cfloop>

	<!--- 		<cfset options = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=145",order="ord ASC") /> --->


			<!--- ///---/// --->
			<!--- |||---||| --->
			<!--- \\\---\\\ --->
			<cfset place = model("place").findByKey(key=params.key) />

			<cfset placeworkflow = model("placeWorkflow").findAll(where="placestepid=1 AND placeid=#params.key#",include="placeStep,placeStatus") />

			<cfset placestatuses = model("placeStatus").findAll() />

			<cfset placestepstatusreasons = model("placeStepStatusReason").findAll() />

			<!--- ///---/// --->
			<!--- |||---||| --->
			<!--- \\\---\\\ --->

			<!---
			10.09.2012
			Pobieram użytkownika, k†óry wprowadził daną nieruchomość
			--->
			<cfset userplace = model("user").findByKey(place.userid) />

			<cfset workflow = model("triggerPlaceStepList").findOne(where="placeid=#params.key#") />

			<cfif IsAjax()>

				<cfset renderPartial("changestatus") />
				<cfset renderWith(data="attributes,place,options,workflow",layout=false) />

			</cfif>

			<!--- Przechwytuje wyjątek i generuje odpowiedni komunikat błędu --->
			<cfcatch type="Uprawnienia">

				<cfset error = cfcatch.message />
				<cfset renderWith(data=error,template="/autherror",layout=false)/>

			</cfcatch>

			<!--- Wyjątek dla wszelkiego rodzaju błędów --->
			<cfcatch type="any">

				<cfset error = cfcatch.message />
				<cfset renderWith(data=error,template="/apperror")/>

			</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="acceptation"
		hint="Formularz akceptacyjny nieruchomość przez dyrektora sprzedazy (lub osobę prze niego wskazaną)"
		description="Formularz akceptacji nieruchomości przez dyrektora sprzedaży">

		<cftry>

			<!--- Sprawdzam, czy użytkownik należy do odpowiedniej grupy --->
			<cfif !(checkUserGroup(userid=session.userid,usergroupname="root") OR
					checkUserGroup(userid=session.userid,usergroupname="Weryfikacja nieruchomości"))>

				<cfthrow type="Uprawnienia" message="Nie masz uprawnień do przeglądania tej strony. Prosimy o kontakt z Departamentem Informatyki" />

			</cfif>


			<!--- Get request from ColdFusion page contenxt. --->
			<cfset objRequest = GetPageContext().GetRequest() />

			<!--- Get requested URL from request object. --->
			<cfset session.lasturl = objRequest.GetRequestUrl().Append("?" & objRequest.GetQueryString()).ToString() />

			<!--- ///---/// --->
			<!--- |||---||| --->
			<!--- \\\---\\\ --->
			<cfset place = model("place").findByKey(select="id",key=params.key) />

			<cfset placeworkflow = model("placeWorkflow").findAll(where="placestepid=2 AND placeid=#params.key#",include="placeStep,placeStatus") />

			<cfset placestatuses = model("placeStatus").findAll() />

			<cfset placestepstatusreasons = model("placeStepStatusReason").findAll() />

			<cfset renderPartial("changestatus") />
			<!--- ///---/// --->
			<!--- |||---||| --->
			<!--- \\\---\\\ --->

			<cfif IsAjax()>

				<cfset renderWith(data="",layout=false) />

			</cfif>

			<cfcatch type="Uprawnienia">

				<cfset error = cfcatch.message />
				<cfset renderWith(data=error,template="/autherror",layout=false) />

			</cfcatch>

			<cfcatch type="any">

				<cfset error = cfcatch.message />
				<cfset renderWith(data=error,template="/apperror") />

			</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="supplement"
		hint="Metoda generująca formularz z polami do uzupełnienia"
		description="Formularz zawiera pola do uzupełnienia dla nieruchomości. Jest to trzeci etap obiegu nieruchomości.">

		<cftry>

			<!--- Sprawdzam, czy użytkownik należy do odpowiedniej grupy --->
			<cfif !(checkUserGroup(userid=session.userid,usergroupname="root") OR
					checkUserGroup(userid=session.userid,usergroupname="Controlling") OR
					checkUserGroup(userid=session.userid,usergroupname="Komitet") OR
					checkUserGroup(userid=session.userid,usergroupname="SdsPB") OR
					checkUserGroup(userid=session.userid,usergroupname="Uzupełnianie danych"))>

				<cfthrow type="Uprawnienia" message="Nie masz uprawnień do przeglądania tej strony. Prosimy o kontakt z Departamentem Informatyki" />

			</cfif>

			<!--- Get request from ColdFusion page contenxt. --->
			<cfset objRequest = GetPageContext().GetRequest() />
			<!--- Get requested URL from request object. --->
			<cfset session.lasturl = objRequest.GetRequestUrl().Append("?" & objRequest.GetQueryString()).ToString() />

			<!--- ///---/// --->
			<!--- |||---||| --->
			<!--- \\\---\\\ --->
			<!--- Pobieram aktuany krok obiegu nieruchomości --->
			<cfset placeworkflow = model("placeWorkflow").findAll(where="placeid=#params.key# AND placestepid=3",include="placeStep,placeStatus") />

	<!--- 		<cfset options = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=145",order="ord ASC") /> --->

			<!--- Pobieram możliwe statusy nieruchomości --->
			<cfset placestatuses = model("placeStatus").findAll() />

			<!--- Informacje o lokalizacji --->
			<cfset place = model("place").findByKey(params.key) />

			<cfset placestepstatusreasons = model("placeStepStatusReason").findAll() />

			<cfset renderPartial("changestatus") />
			<!--- ///---/// --->
			<!--- |||---||| --->
			<!--- \\\---\\\ --->

			<cfset workflow = model("triggerPlaceStepList").findOne(where="placeid=#params.key#") />

			<!--- Struktira przechowująca opcje wyboru dla select boxów --->
			<cfset options = {} />

			<!---
			12.09.2012
			Zmianie ulega sposób generowania pól formularza. Teraz kontroler pobiera wszystkie atrybuty,
			które powinny być widoczne na etapie uzupełniania danych. Widok sprawdza, czy użytkownik jest w
			określonej grupie uprawnień. Jeżeli tak, to pozwalam edytować pola, jeżeli nie to nie pozwalam na edycję.
			--->

			<!---
			Pobieram wszystkie atrybuty dla danego kroku obiegu dokumentów
			--->
			<cfset r = StructNew() />
			<cfset r["Controlling"] = model("place").getAttributesByGroup(placeid=params.key,groupid=7) />
			<cfset r["Partner ds. ekspansji"] = model("place").getAttributesByGroup(placeid=params.key,groupid=15) />
			<cfset r["SdsPB"] = model("place").getAttributesByGroup(placeid=params.key,groupid=17) />

			<!---
			W pętli przechodzę, przez wszystkie atrybuty nieruchomości i generuje opcje wyboru
			dal pól select box.
			--->
			<cfloop collection="#r#" item="i">
				<cfset myattributes = r[i] />
				<cfloop query="myattributes">
					<cfif attributetypeid eq 5>
						<cfset options[attributeid] = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=#attributeid#",order="ord ASC") />
					</cfif>
				</cfloop>
			</cfloop>

<!--- 			<cfloop query="session.usergroups"> --->

<!--- 				<cfset r[groupname] = model("place").getAttributesByGroup(placeid=params.key,groupid=groupid) /> --->

				<!---
				22.08.2012
				Przejście przez wszystkie atrybuty w kroku uzupełniania jest inne.
				Najpierw pobieram atrybuty dla określonej grupy, do której należy użytkownik. Dopiero później
				pobierane są opcje do list wyboru.
				--->
<!--- 				<cfset tmp = r[groupname] /> --->
<!--- 				<cfloop query="tmp"> --->
<!--- 					<cfif attributetypeid eq 5> --->

<!--- 						<cfset options[attributeid] = model("selectValue").findAll(select="selectvalue,selectlabel",where="attributeid=#attributeid#",order="ord ASC") /> --->

<!--- 					</cfif> --->
<!--- 				</cfloop> --->

<!--- 			</cfloop> --->

			<cfif isAjax()>

				<cfset renderWith(data="r,workflow,place,options",layout=false) />

			</cfif>

			<cfcatch type="Uprawnienia">

				<cfset error = cfcatch.message />
				<cfset renderWith(data=error,template="/autherror",layout=false) />

			</cfcatch>

			<cfcatch type="any">

				<cfset error = cfcatch.message />
				<cfset renderWith(data=error,template="/autherror",layout=false) />

			</cfcatch>

		</cftry>

	</cffunction>



	<cffunction
		name="actionUpdateAttributes"
		hint="Zapisanie formularza partnera">

		<!---
		7.08.2012
		Przechodzę przez wszystkie przesłane atrybuty i aktualizuje je w bazie
		--->

		<cfloop collection="#params.placeattributevalue#" item="i">

			<cfset placeattributevalue = model("placeAttributeValue").updateByKey(key=i,placeattributevaluetext=params.placeattributevalue[i]) />

		</cfloop>

		<cfif StructKeyExists(session, "lasturl")>

			<cflocation url="#session.lasturl#" statusCode="301" />

		<cfelse>

			<cfset redirectTo(controller="Places",action="view",key=params.placeid) />

		</cfif>

	</cffunction>

	<cffunction
		name="committee"
		hint="Etap akceptacji nieruchomości na komitecie"
		description="Etap nieruchomości polegający na akceptacji obiektu na komitecie. Na chwilę obecną formularz pozwala na zaakceptowanie/odrzucenie lokalizacji i podanie powodu. Docelowo w tej zakładce ma się znajdować głosowanie człownków komitetu.">

		<cftry>

			<!--- Sprawdzam, czy użytkownik należy do odpowiedniej grupy --->
			<cfif !(checkUserGroup(userid=session.userid,usergroupname="root") OR
					checkUserGroup(userid=session.userid,usergroupname="Komitet"))>

				<cfthrow type="Uprawnienia" message="Nie masz uprawnień do przeglądania tej strony. Prosimy o kontakt z Departamentem Informatyki" />

			</cfif>

			<!--- ///---/// --->
			<!--- |||---||| --->
			<!--- \\\---\\\ --->
			<!--- Pobieram aktuany krok obiegu nieruchomości --->
			<cfset placeworkflow = model("placeWorkflow").findAll(where="placeid=#params.key# AND placestepid=4",include="placeStep,placeStatus") />

			<!--- Pobieram możliwe statusy nieruchomości --->
			<cfset placestatuses = model("placeStatus").findAll() />

			<!--- Informacje o lokalizacji --->
			<cfset place = model("place").findByKey(params.key) />

			<cfset placestepstatusreasons = model("placeStepStatusReason").findAll() />

			<cfset renderPartial("changestatus") />
			<!--- ///---/// --->
			<!--- |||---||| --->
			<!--- \\\---\\\ --->

			<!--- Pobieram listę wszystkich atrybutów, które są widoczne dla komitetu --->
			<cfset r = StructNew() />
			<cfset r[1]['Analiza finansowa'] = model("place").getAttributesByGroup(placeid=params.key,groupid=22) />
			<cfset r[3]['Dane lokalu'] = model("place").getAttributesByGroup(placeid=params.key,groupid=20) />
			<cfset r[2]['Informacje o lokalizacji'] = model("place").getAttributesByGroup(placeid=params.key,groupid=21) />

			<!---
			04.09.2012
			Zmieniłem atrybuty widoczne dla komitetu. Atrybuty nie są brane na podstawie grup, do których należy użytkownik.
			Teraz atrybuty są pobierane "na sztywno" dla grupy o ID = 14 - Komitet.

			TODO
			Dorobić procedurę, która zwraca ID grupy na podstawie jej nazwy!!!
			--->
			<!---
<cfloop query="session.usergroups">

				<cfset r[groupname] = model("place").getAttributesByGroup(placeid=params.key,groupid=groupid) />

			</cfloop>
--->

			<cfif IsAjax()>

				<cfset renderWith(data="r",layout=false) />

			</cfif>

			<cfcatch type="Uprawnienia">

				<cfset error = cfcatch.message />
				<cfset renderWith(data=error,template="/autherror",layout=false) />

			</cfcatch>

			<cfcatch type="any">

				<cfset error = cfcatch.message />
				<cfset renderWith(data=error,template="/apperror") />

			</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="preview"
		hint="Podgląd aktualnego statusu nieruchomości">

		<cfset placeworkflow = model("placeWorkflow").getPlaceWorkflow(placeid="#params.key#") />
<!--- 		<cfset placeworkflow = model("placeWorkflow").findAll(where="placeid=#params.key#",include="placeStep,placeStatus,user") /> --->
		<cfset placesteps = model("triggerPlaceStepList").findAll(where="placeid=#params.key#") />
		<cfset workflow = model("triggerPlaceStepList").findOne(where="placeid=#params.key#") />

		<cfif IsAjax()>

			<cfset renderWith(data="placeworkflow,placesteps,workflow",layout=false) />

		</cfif>

	</cffunction>

	<!---
	0 - plik nie jest eksportowany
	1 - plik jest eksportowany
	--->
	<cffunction
		name="toExport"
		hint="Metoda zmieniająca parametr mówiący o eksporcie pliku."
		description="Metoda zmieniająca parametr eksportu pliku.">

		<cfif isAjax()>
			<cfset placefile = model("placeFile").findByKey(params.key)>
			<cfset placefile.update(toexport=1-placefile.toexport)>
			<cfset message = "Reguła została zaktualizowana.">
		<cfelse>
			<cfset message = "Niepoprawdze wywołanie żądania">
		</cfif>

		<cfset renderWith(data=message,layout=false)>

	</cffunction>

	<cffunction
		name="exportToPdf"
		hint="Eksport lokalizacji do pliku."
		description="Metoda pozwalająca na eksport nieruchomości do pliku PDF.">

		<!--- Nieruchomość --->
		<cfset place = model("place").findByKey(key=params.key,include="user") />

		<!--- Grafiki przypisane do nieruchomości --->
		<cfset placephotos = model("place").getPhotos(placeid=params.key) />

		<!--- Atrybuty opisujące nieruchomość --->
		<!--- Pobieram listę wszystkich atrybutów, które są widoczne dla komitetu --->
		<cfset r = StructNew() />
		<cfset r[1]['Analiza finansowa'] = model("place").getAttributesByGroup(placeid=params.key,groupid=22) />
		<cfset r[3]['Dane lokalu'] = model("place").getAttributesByGroup(placeid=params.key,groupid=20) />
		<cfset r[2]['Informacje o lokalizacji'] = model("place").getAttributesByGroup(placeid=params.key,groupid=21) />

		<!---
		17.09.2012
		Zmieniłem sposób pobierania atrybutów nieruchomości do raportu na komitet.
		--->
<!---
		<cfloop query="session.usergroups">
			<cfset r[groupname] = model("place").getAttributesByGroup(placeid=params.key,groupid=groupid) />
		</cfloop>
--->

		<cfset placeworkflow = model("placeWorkflow").getPlaceWorkflow(placeid=params.key) />

		<cfset renderWith(data="place,placephotos,r,placeworkflow",layout=false) />

	</cffunction>

	<!---
	10.08.2012
	Aktualizacja statusu obiegu nieruchomości.

	Zmiana statusu jest dość skomplikowana i składa się z kilku kroków:
	- pobranie listy możliwych etapów/kroków
	- pobranie aktualnego kroku
	- zmiana statusu aktualnego kroku
	- utworzenie (lub nie) nowego kroku
	--->
	<cffunction
		name="changeStatus"
		hint="Zmiana statusu obiegu nieruchomości."
		description="Metoda zmieniająca status kroku obiegu nieruchomości.">

		<cftry>

			<cfset placeworkflowstep = model("placeWorkflow").findOne(where="placeid=#params.placeid# AND placestepid=#params.stepid# AND placestatusid=1") />

			<!--- Pobieram aktualny krok --->
			<cfset steps = model("placeStep").findByKey(params.stepid) />

			<cfif !IsObject(placeworkflowstep)>
				<cfthrow message="Nie można pobrać aktualnego kroku obiegu nieruchomości" />
			</cfif>

<!---
			<cfset myplace = model("place").findByKey(params.placeid) />
			<cfset myplace.placestatusid = params.statusid />
			<cfset myplace.update(callbacks=false) />
--->

			<!---
			22.08.2012
			Trzeba wykluczyć możliwość zmiany statusu z "W trakcie" na "W trakcie". W tym celu muszę sprawdzic
			id nowego statusu. Jesli jest 1 to nic nie robię. Jeśli jest != 1 to zmieniami status.
			--->
			<cfif params.statusid neq 1> <!--- Sprawdzam nowy status --->

				<!--- Aktualizuje dany krok obiegu nieruchomości --->
				<cfset placeworkflowstep.placeworkflowstop = Now() /> <!--- Ustawim datę zamknięcia tego kroku obiegu --->
				<!--- <cfset placeworkflowstep.placestatusid = params.statusid /> ---> <!--- Ustawiam nowy status tego kroku --->
				<cfset placeworkflowstep.placestepstatusreasonid = params.placestepstatusreasonid /> <!--- Zapisanie powodu zmiany statusu. To pole jest wypełniane głównie przy odrzuceniu lokalizacji --->
				<cfset placeworkflowstep.placeworkflownote = params.placeworkflownote /> <!--- Dodanie komentarza do kroku obiegu --->
				<cfset placeworkflowstep.newplacestatusid = params.statusid /> <!--- Ustawiam nowy status --->
				<cfset placeworkflowstep.newuserid = session.userid /> <!--- Zapisuje id użytkownika, który zmienił status --->
				<cfset placeworkflowstep.save(callbacks=false) />

				<!--- Jeżeli nie jest to ostatni krok obiegu to tworzę go --->
				<cfif Len(steps.next) AND params.statusid neq 3> <!--- Jeżeli status na który zmieniam nie jest negatywny --->

					<!--- Dodaje nowy krok obiegu nieruchomoścu --->
					<cfset myplaceworkflowstep = model("placeWorkflow").new() />
					<cfset myplaceworkflowstep.userid = session.userid />
					<cfset myplaceworkflowstep.placeworkflowstart = Now() />
					<cfset myplaceworkflowstep.placeid = params.placeid />
					<cfset myplaceworkflowstep.placestatusid = 1 /> <!--- ID statusu wynosi 1 - w trakcie --->
					<cfset myplaceworkflowstep.placestepid = steps.next />
					<cfset myplaceworkflowstep.save() />

					<!---
					7.09.2012
					Aktualizuje aktualny etap nieruchomości
					--->
<!---
					<cfset myplace = model("place").findByKey(params.placeid) />
					<cfset myplace.placestepid = steps.next />
					<cfset myplace.placestatusid = 1 />
					<cfset myplace.update(callbacks=false) />
--->
<!--- 					<cfset myplace.update(placestepid=steps.next,placestatusid=1) /> --->

				</cfif>

				<!---
				23.08.2012
				Po zmianie statusu wysyłam email z informacją o zmianie. Email jest wysyłany do odpowiednich osób.
				Lista osób znajduje się w tabeli settings w kolejnych wierszach.
				--->
				<cfset settings = model("setting").findAll() />
				<cfset emails = parseSettings(settings=settings) />

				<cfset users_array = ArrayNew(2) /> <!--- Tworzę pustą tablicę dwuwymiarową di przechowywania użytkowników --->
				<cfswitch expression="#placeworkflowstep.placestepid#">

					<cfcase value="2"> <!--- Etap weryfikacja --->

						<cfset users_array = emails['place_acceptation'] />

					</cfcase>

					<cfcase value="3"> <!--- Etap weryfikacja --->

						<cfset users_array = emails['place_supplement'] />

					</cfcase>

					<cfcase value="4"> <!--- Etap weryfikacja --->

						<cfset users_array = emails['place_committee'] />

					</cfcase>

					<cfcase value="5"> <!--- Etap weryfikacja --->

						<cfset users_array = emails['place_agreement'] />

					</cfcase>

					<cfdefaultcase>

						<cfset users_array = emails['place_admin'] />

					</cfdefaultcase>

				</cfswitch>

				<!---
				10.09.2012
				Dodaje ID partnera, który dodał nieruchomość. On też sotanie powiadomienie email o zmianach.
				--->
				<cfset place = model("place").findByKey(params.placeid) />
				<cfset ArrayAppend(users_array, place.userid) />

				<cfset users_struct = {} />
				<cfloop array="#users_array#" index="i">
					<cfset users_struct[i] = model("user").findByKey(i) />
				</cfloop>

				<cfset sending = model("email").sendPlaceReminder(placeid=params.placeid,emails=users_struct) />

			</cfif>

			<cfset redirectTo(controller="Places",action="view",key=params.placeid) />

			<cfcatch type="any">

				<cfset error = cfcatch.message />
				<cfset renderWith(data=error,template="/apperror")/>

			</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="history"
		hint="Historia danej nieruchomości."
		description="Metoda pokazuje historię danej nieruchomości. W tabelce są widoczne poszczególne etapy i ich statusy z datami zmian">

		<cfif IsAjax()>

			<cfset renderWith(data="",layout=false) />

		</cfif>

	</cffunction>

	<cffunction
		name="agreement"
		hint="Zmiana statusu podpisania umowy."
		description="Etap zamykający cały obieg nieruchomości.">

		<cftry>

			<!--- Sprawdzam, czy użytkownik należy do odpowiedniej grupy --->
			<cfif !(checkUserGroup(userid=session.userid,usergroupname="root") OR
					checkUserGroup(userid=session.userid,usergroupname="Komitet"))>

				<cfthrow type="Uprawnienia" message="Nie masz uprawnień do przeglądania tej strony. Prosimy o kontakt z Departamentem Informatyki" />

			</cfif>

			<!--- ///---/// --->
			<!--- |||---||| --->
			<!--- \\\---\\\ --->
			<!--- Pobieram aktuany krok obiegu nieruchomości --->
			<cfset placeworkflow = model("placeWorkflow").findAll(where="placeid=#params.key# AND placestepid=5",include="placeStep,placeStatus") />

			<!--- Pobieram możliwe statusy nieruchomości --->
			<cfset placestatuses = model("placeStatus").findAll() />

			<!--- Informacje o lokalizacji --->
			<cfset place = model("place").findByKey(params.key) />

			<cfset placestepstatusreasons = model("placeStepStatusReason").findAll() />

			<cfset renderPartial("changestatus") />
			<!--- ///---/// --->
			<!--- |||---||| --->
			<!--- \\\---\\\ --->

			<cfif IsAjax()>

				<cfset renderWith(data="",layout=false) />

			</cfif>

			<cfcatch type="Uprawnienia">

				<cfset error = cfcatch.message />
				<cfset renderWith(data=error,template="/autherror",layout=false) />

			</cfcatch>

			<cfcatch type="any">

				<cfset error = cfcatch.message />
				<cfset renderWith(data=error,template="/apperror") />

			</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="changePriority"
		hint="Zmiana ważnośli lokalizacji"
		description="Metoda pozwalająca na zmianę, czy dana lokalizacja jest ważna, czy nie">

		<cfif isAjax()>
			<cfset place = model("place").findByKey(params.key)>
			<cfset place.update(priority=1-place.priority)>
			<cfset message = "Reguła została zaktualizowana.">
		<cfelse>
			<cfset message = "Niepoprawdze wywołanie żądania">
		</cfif>

		<cfset renderWith(data=message,layout=false)>

	</cffunction>

	<!---
	28.08.2012
	--->
	<cffunction
		name="myPlaces"
		hint="Lista nieruchomości, w obiegu których biorę udział"
		description="Metoda prezentująca listę nieruchoności, w obiegu której biorę udział">

		<!---
		10.09.2012
		Pobieram tylko moje nircuhomości
		--->
		<cfset places = model("place").searchPartnerPlaces(userid=session.userid) />
<!--- 		<cfset places = model("place").getMyPlaces(userid=session.userid) /> --->

		<cfif IsAjax()>

			<cfset renderWith(data="places",layout=false) />

		</cfif>

	</cffunction>

	<!---
	10.09.2012
	Sprawdzenie, czy istnieje już lokalizacja o podanym adresie.
	--->
	<cffunction
		name="checkPlace"
		hint="Sprawdzanie, czy dana lokalizacja istnieje"
		description="Metoda sprawdzająca, czy istnieje lokalizacja o podanym adresie">

		<!--- Pobieram listę nieruchomości pasujących do wzorca (adresu) --->
		<cfset place = model("place").checkPlace(cityname="#params.cityname#",address="#params.address#") />

		<cfif place.RecordCount eq 0> <!--- Jeżeli nie ma wyników, to nieruchomość nieistnieje --->

			<cfset renderWith(data="",template="noplaces") />

		<cfelse>

			<cfset renderWith(data="",template="yesplaces") />

		</cfif>

	</cffunction>

	<cffunction
		name="agreementReport"
		hint="Raport nieruchomości do weryfikacji"
		description="Metoda generująca raport nieruchomości do weryfikacji">

		<cfset place = model("place").findByKey(key=params.key,include="user") />
		<cfset attributes = model("place").getAttributesByGroup(placeid=params.key,groupid=12) />
		<cfset placephotos = model("place").getPhotos(placeid=params.key) />

		<cfset renderWith(data="place,attributes,placephotos",layout=false) />

	</cffunction>

	<cffunction
		name="widget_placesAdded"
		hint="Widget prezentujący liczbę dodanych nieruchomości."
		description="Liczba dodanych nieruchomości na przełomie ostatnich 12
			miesięcy. Generowany jest wykres liniowy, które pokazuje jak zmieniał
			się trend.">

		<cfset qPlaces = model("place_instance").wingetPlacesAdded() />

	</cffunction>

</cfcomponent>