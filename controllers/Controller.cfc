<!---
	This is the parent controller file that all your controllers should extend.
	You can add functions to this file to make them globally available in all your controllers.
	Do not delete this file.
--->
<cfcomponent
	extends="abstract_component_intranet"
	output="false">

	<cfset title="Monkey (#get('loc').intranet.directory#)">
	
	<cfset getUserNotice() />

	<cffunction name="init" output="false" access="public" hint="">

		<cfset super.init() />

		<!--- Pobieranie ustawień aplikacji z bazy danych --->
		<cfset Request.settings = parseSettings(settings=model("setting").findAll()) />

		<!---
			Tworzę zmienną do przechowywania plików JS do importu.
		--->
		<cfif not IsDefined("APPLICATION.ajaxImportFiles")>
			<cfset APPLICATION.ajaxImportFiles = "" />
		</cfif>

		<cfif not IsDefined("APPLICATION.bodyImportFiles")>
			<cfset APPLICATION.bodyImportFiles = "" />
		</cfif>

		<cfset filters(through="auth,ajaxImportFiles,publicVariables,cleanCache",except="logIn,actionLogIn,sms,token,sendWorkflowReminder,sendHolidayProposalReminder,setNewInvoiceCounter",type="before") />
		<cfset filters(through="cacheScope",type="before") />
		<cfset filters(through="bodyImportFiles",type="after") />
		<cfset filters(through="working",type="before") />
	</cffunction>
	
	<cffunction name="working" output="false" access="public" hint="">
		
		<!---<cfif cgi.remote_addr neq "10.99.1.52">
			<cfset renderWith(data="",template="/out",layout="/layout_out") />
		</cfif>--->
		
	</cffunction>

	<cffunction name="auth" hint="Sprawdzenie, czy użytkwnik jest zalogowany w systemie">

		<cfif not structKeyExists(session, "user") or not structKeyExists(session, "userid")>
			<cfset structClear(session) />

			<cfif CGI.REMOTE_ADDR IS "10.99.1.52">
				<!---<cfset redirectTo(controller="Users",action="sms") />--->
			</cfif>
			
			<!---<cfif CGI.REMOTE_ADDR IS "10.99.1.112">
				<cfset redirectTo(controller="Users",action="sms") />
			</cfif>--->

			<!---<cfif Find("10.99.", CGI.REMOTE_ADDR) or 
				Find("10.10", CGI.REMOTE_ADDR) or
				Find("10.190", CGI.REMOTE_ADDR) or
				Find("10.90", CGI.REMOTE_ADDR)>--->
			<cfif Find("10.", CGI.REMOTE_ADDR)>
				
				<cfset redirectTo(controller="Users", action="logIn") />
			<cfelse>
				<cfset redirectTo(controller="Users",action="sms") />
			</cfif>

		</cfif>

		<cfif not StructKeyExists(url, "action") OR not StructKeyExists(url, "controller")>
			<cfset redirectTo(controller="Users",action="view",key=session.user.id) />
		</cfif>

		<!---
		<cfif cgi.remote_addr neq "10.99.1.52">

			<cfif IsAjax()>
				<cfset renderWith(data="",template="/out",layout=false) />
			<cfelse>
				<cfset renderWith(data="",template="/out") />
			</cfif>

		</cfif>
		--->

	</cffunction>

	<cffunction name="ajaxImportFiles" hint="Importowanie plików JS, które mają być w części HEAD">
		<cfset APPLICATION.ajaxImportFiles = "workflow,loadCKE,workflow_autosave,planograms,posts,folders,initNoteNotes,initProposals,initCfWindow,initDocumentArchive" />
	</cffunction>

	<cffunction name="bodyImportFiles" hint="Importowanie plików JS, które mają być załączone w części BODY">
		<cfargument name="fileName" type="string" required="false" /> 

		<cfset APPLICATION.bodyImportFiles = "" />
		
		<cfif isDefined("arguments.fileName")>
			<cfset APPLICATION.bodyImportFiles &= "," & arguments.fileName />
		</cfif>
	</cffunction>

	<cffunction name="publicVariables" hint="Tworzenie zmiennych, które mają być widoczne w reszcie plików">
		<cfset searchCategories = {
			workflows 	=	"Obieg dokumentów",
			instructions	=	"Wewnętrzne akty prawne",
			users		=	"Użytkownicy",
			archivedocuments = "Błędnie wystawione dokumenty"
		} />
	</cffunction>
	
	<cffunction name="cleanCache" output="false" access="package" hint="" returntype="void" >
		<cfif isDefined("url.cleanCache") and url.cleanCache eq 1 and arrayContains(cacheGetAllIds(), "PLACEPRIVILEGES")>
			<cfset cacheRemove("PLACEPRIVILEGES") />
		</cfif>
	</cffunction> 
	
	<cffunction name="cacheScope" access="public" output="false">
			
		<cfif structKeyExists(session, "user") and 
				structKeyExists(url, "cache") and arrayContains(cacheGetAllIds(), "PLACEPRIVILEGES")>
			<cfset cacheRemove("PLACEPRIVILEGES") />
		</cfif>
		
		<cfset timeToLive = createtimespan(7, 0, 0, 0) /> 
		
		<cfif structKeyExists(session, "user") and 
			not arrayContains(cacheGetAllIds(), "PLACEPRIVILEGES[#session.user.id#]")>
			
			<cfset cachePut( "PLACEPRIVILEGES[#session.user.id#][placestepprivileges]", model("place_stepprivilege").getUserSteps(userid=session.userid,structure=true), timeToLive ) />
			
			<cfset cachePut( "PLACEPRIVILEGES[#session.user.id#][placeformprivileges]", model("place_formprivilege").getUserForms(userid=session.userid,structure=true), timeToLive ) />
			
			<cfset cachePut( "PLACEPRIVILEGES[#session.user.id#][placecollectionprivileges]", model("place_collectionprivilege").getUserCollections(userid=session.userid,structure=true), timeToLive ) />
			
			<cfset cachePut( "PLACEPRIVILEGES[#session.user.id#][placephototypeprivileges]", model("place_phototypeprivilege").getUserPhotoTypes(userid=session.userid,structure=true), timeToLive ) />
			
			<cfset cachePut( "PLACEPRIVILEGES[#session.user.id#][placefiletypeprivileges]", model("place_filetypeprivilege").getUserFileTypes(userid=session.userid,structure=true), timeToLive ) />
			
			<cfset cachePut( "PLACEPRIVILEGES[#session.user.id#][placereportprivileges]", model("place_reportprivilege").getUserReports(userid=session.userid, structure=true), timeToLive ) />
			
		</cfif>
			
	</cffunction>

	<!---
	<cffunction name="checkLogIn">

		<cfif not StructKeyExists(session, "user") AND not StructKeyExists(session, "userid")>

			<!---
				9.11.2012
				Jeżeli IP użytkownika jest z naszej sieci to przenoszę na stronę logowania.
				Jeżeli IP uzytkownika jest spoza naszej sieci to przenosze na stronę z podawaniem loginu
			--->
			<cfif Find("10.99", CGI.REMOTE_ADDR) or Find("10.10", CGI.REMOTE_ADDR)>
				<cfset redirectTo(controller="Users", action="logIn") />
			<cfelse>
				<cfset redirectTo(controller="Users",action="getUserLogin") />
			</cfif>

		<!---
		11.09.2012
		Dodaje sprawdzenie, czy muszę podać sms token. Aby to zrobić przekierowuję na inną stronę.

		10.09.2012
		INTEGRACJA Z BRAMKĄ SMS
		Sprawdzam, czy użytkownik w bazie ma pole smsauth = 1. Jeżeli tak to:
		- generuje token
		- zapisuje token w bazie
		- ustawiam datę ważności tokenu
		- wysyłam sms

		Kroki autoryzacji przez sms widzę tak:
		- uzytkownik się loguje
		- system sprawdza usera przez LDAP
		- system zapisuje w sesji informacje o użytkowniku
		- sprawdzam czy mam apisać w sesji token
		- sprawdzenie tokenu

		--->
<!--- 		<cfset user = model("user").findByKey(session.userid) /> --->
		<!---<cfelseif (session.user.smsauth eq 1) and DateCompare(session.user.smsvalidtokento, Now()) eq -1 >
			<cfset redirectTo(controller="Users",action="sms") />--->

		<!---
		13.02.2012
		Ważny warunek, który sprawdza, czy jest prawidłowy adres url - controller i action. Jeśli nie ma (użytkownik wpisał
		w url intranet) to przekierowuje na stronę jego profilu.
		--->
		<cfelseif not StructKeyExists(url, "action") OR not StructKeyExists(url, "controller")>

			<cfset redirectTo(controller="Users",action="view",key=session.userid) />

		<!---
		Aby pominąć sprawdzanie maski uprawnień trzeba zakomentować <cfelse> poniżej
		--->
		<!---
		<cfelseif not grantRevoke(action="#url.action#",controller="#url.controller#",userid=session.userid)>

			<cfset flashInsert(error="Nie masz uprawnień do przeglądania tej strony")>

			<cfif IsAjax()>
				<cfset renderWith(data="",template="/autherror",layout=false) />

			<cfelse>

				<cfset renderWith(data="",template="/autherror",layout="/layout") />

			</cfif>

		<cfelse>
		--->
		
		<!---
		11.09.2012
		Jeżeli jesz wszystko si to inkrementuje ważność tokenu o 30 minut od teraz
		--->

			<cfset myuser = model("user").updateByKey(key=session.userid,smsvalidtokento=DateAdd("n", 30, Now())) />
			<cfset session.user.smsvalidtokento = DateAdd("n", 30, Now()) />

		</cfif>

		<!---
			11.01.2013
			Jeżeli nazywam się czeszak to nie mam dostępu do Intranetu.
		--->
		<!---<cfif structKeyExists(session, "userid") and session.userid eq 230>
			<cfset renderWith(data="",template="/out") />
		</cfif>--->

		<!---
		<cfif structKeyExists(session.user, "baned_to") and DateCompare(session.user.baned_to, Now()) eq 1>

			<cfset renderWith(data="",template="/blocked") />

		</cfif>
		--->

	</cffunction>
	--->
	
	<!---
	TODO
	Sprawdzanie czy użytkownik ma uprawnienia z sesji. Aktualnie za kazdym razem łączę się z bazą danych i odpytuje serwer.
	Sprawdzanie i porównywanie danych zapisanych w sesji przyspieszy działanie skryptu.
	--->
	<!---
	<cffunction name="grantRevoke" hint="Funkcja przechodzi przez wszystkie uprawnienia jakie ma użytkownik
										i spprawdza, czy mam dostęp do danej metody" returnType="boolean">

		<cfargument name="controller" type="string" hint="Nazwa kontrolera">
		<cfargument name="action" type="string"	hint="Nazwa metody">
		<cfargument name="rules" type="query" hint="Maska uprawnień do sprawdzenia">
		<cfargument name="userid" type="numeric" hint="Identyfikator użytkownika">

		<cfset rule = model("acl").findOne(where="groupaccess=1 AND ruleaccess=1 AND controller='#arguments.controller#' AND action='#arguments.action#' AND userid=#arguments.userid#")>

		<cfif IsObject(rule)>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>

	</cffunction>
	--->
	
	<!---
	Usuwanie znaków HTML z treści tekstu.
	--->
	<cffunction name="stripHtml" returnType="string">
		<cfargument name="text" type="string" default="" required="true">

		<cfset var loc.stripped = REReplaceNoCase(arguments.text, "<[^>]*>", "", "ALL")>

		<cfreturn loc.stripped>
	</cffunction>

	<!---
	Zwracanie losowego ciągu znaków o zadanej długości
	--->
	<cffunction name="randomText" hint="Metoda zwraca losowy ciąg znaków o zadanej długości" returnType="string">
		<cfargument name="length" type="numeric" default="5" required="false" />

		<cfset local.CharSet = "QWERTYUPASDFGHJKLZXCVBNM23456789" />
		<cfset local.str = "" />
		<cfset local.tempstr = ""/>

		<cfloop from="1" to="#arguments.Length#" index="local.Cnt">
			<cfset local.tempstr = Mid(local.CharSet, RandRange(1,
Len(local.CharSet)), 1) />

			<cfset local.str = local.str & local.tempstr />
		</cfloop>

		<cfreturn local.str>

	</cffunction>

	<cffunction name="stripPolishChars" hint="Metoda zamieniająca polskie znaki na ich odpowiedniki bez ogonków." returnType="string">
		<cfargument name="text" default="" type="string" hint="Tekst zawierający polskie znaki" />

		<cfset loc.text = arguments.text />

		<cfset loc.text = ReplaceNoCase(loc.text, "ó", "o", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "Ó", "O", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "ę", "e", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "Ę", "E", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "Ą", "A", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "ą", "a", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "ł", "l", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "Ł", "L", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "ż", "z", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "Ż", "Z", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "ź", "z", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "Ź", "Z", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "ń", "n", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "Ń", "N", "all") />

		<cfreturn loc.text />

	</cffunction>

	<cffunction
		name="stripWhiteChars"
		hint="Metoda usuwająca spacje z ciągu znaków."
		description="Metoda widoczna we wszystkich kontrolerach. Usuwa spacje z ciągu znaków."
		returnType="string">

		<cfargument name="text" type="string" default="" required="true" />
		<cfargument name="separator" type="string" default="_" required="false" />

		<cfreturn ReplaceNoCase(arguments.text, " ", arguments.separator, "all") />

	</cffunction>

	<cffunction
		name="onlyChars"
		hint="Metoda usuwająca Wszystkie znaki inne niż litery i cyfry."
		description="Metoda widoczna we wszystkich kontrolerach. Pozostawia tylko litery i cyfry."
		returnType="string">

		<cfargument name="text" type="string" default="" required="true" />

		<cfset loc.text = arguments.text />

		<cfset loc.text = ReplaceNoCase(loc.text, " ", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "+", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "-", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "(", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, ")", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "/", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "\", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "_", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "'", "", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, '"', "", "all") />

		<cfreturn loc.text />

	</cffunction>
	
	<cffunction
		name="cf_escape_string"
		hint="Dodaje znaki unikowe w łańcuchu znaków do użycia w instrukcji SQL"
		description="Dodaje znaki unikowe w łańcuchu znaków do użycia w instrukcji SQL"
		returnType="string">

		<cfargument name="text" type="string" default="" required="true" />

		<cfset loc.text = arguments.text />

		<cfset loc.text = ReplaceNoCase(loc.text, "\", "\\", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "\0", "\\0", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "\n", "\\n", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "\r", "\\r", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "'", "\'", "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, '"', '\"', "all") />
		<cfset loc.text = ReplaceNoCase(loc.text, "\x1a", "\\Z", "all") />

		<cfreturn loc.text />

	</cffunction>

	<cffunction
		name="parseSettings"
		hint="Parsowanie ustawień"
		description="Metoda parsująca ustawienia wyciągane z bazy. Znakiem oddzielającym wartości jest :"
		returnType="struct">

		<cfargument name="settings" required="true" hint="Lista wyciągniętych z bazy ustawień" />

		<cfset loc.settings = StructNew() />

		<cfloop query="arguments.settings">
			<cfset loc.tmp = StructNew() />
			<cfset loc.tmp[settingname] = listToArray(settingvalue, ":", false, true) />

			<cfset StructAppend(loc.settings, loc.tmp, false) />
		</cfloop>

		<cfreturn loc.settings />

	</cffunction>

	<cffunction
		name="checkUserGroup"
		hint="Metoda sprawdzająca czy użytkownik należy do wskazanej grupy.">

		<cfargument name="userid" type="numeric" required="true" default="0" />
		<cfargument name="usergroupname" type="string" required="false" default="" />

		<cfset usergroups = model("userGroup").findAll(where="userid=#arguments.userid# AND access=1",select="groupname,groupid",include="group") />

		<cfloop query="usergroups">

			<cfif groupname eq arguments.usergroupname >

				<cfreturn true />

			<cfelse>

				<cfcontinue />

			</cfif>

		</cfloop>

		<cfreturn false />

	</cffunction>

	<cffunction
		name="getUserGroupId"
		hint="Pobranie identyfikatora grupy, do której jest przypisany użytkownik">

		<cfargument name="userid" type="numeric" required="true" default="0" />
		<cfargument name="usergroupname" type="string" required="false" default="" />

		<!--- Pobieram wszystkie grupy, do których jest przypisany użytkownik --->
		<cfset usergroups = model("userGroup").findAll(where="userid=#params.userid# AND access=1",select="groupname,groupid",include="group") />

		<cfloop query="usergroups">

			<cfif groupname eq params.usergroupname>

				<cfreturn groupid />

			</cfif>

		</cfloop>

		<cfreturn false />

	</cffunction>

	<cffunction
		name="IsHoliday"
		hint="Metoda sprawdza, czy dany dzień jest świętem, czy nie jest">

		<cfargument name="tocompare" type="string" required="true" />

		<cfset myholidays = model("holiday").findAll() />
		<cfset tmpDate = CreateDate(Year(arguments.tocompare), Month(arguments.tocompare), Day(arguments.tocompare)) />

		<cfloop query="myholidays">
			<cfif DateCompare(tmpDate, holidaydate) eq 0>
				<cfreturn true />
			</cfif>
		</cfloop>

		<cfreturn false />

	</cffunction>

	<!---
		8.11.2012
		Z braku laku i pomysłu gdzie, metody sprawdzające uprawnienia w module nieruchomości umieściłem właśnie tutaj.
		Zapewne docelowo będzie komponent dziedzicący po Controller a po nim następnie będą dziedziczyły komponenty
		Modułu nieruchomości.
	--->

	<cffunction
		name="checkAccess"
		hint="Sprawdzenie, czy użytkownik ma praco do czytania">

		<cfargument name="privileges" type="any" required="true" />
		<cfargument name="itemname" type="any" required="true" />
		<cfargument name="itemvalue" type="any" required="true" />
		<cfargument name="accessname" type="any" required="true" />

		<cfloop array="#arguments.privileges#" index="i">

			<cfif i[arguments.itemname] eq arguments.itemvalue and i[arguments.accessname] eq 1>
				<cfreturn true />
			</cfif>
		</cfloop>

		<cfreturn false />

	</cffunction>

	<cffunction
		name="modulePlacePrivileges"
		hint="Metoda nadająca uprawnienia użytkownikom do modułu nieruchomości.">

		<cfif structKeyExists(session, "userid") and not StructKeyExists(session, "placestepprivileges")>
			<cfset session.placestepprivileges = model("place_stepprivilege").getUserSteps(userid=session.userid,structure=true) />
		</cfif>

		<cfif structKeyExists(session, "userid") and not StructKeyExists(session, "placeformprivileges")>
			<cfset session.placeformprivileges = model("place_formprivilege").getUserForms(userid=session.userid,structure=true) />
		</cfif>

		<cfif structKeyExists(session, "userid") and not StructKeyExists(session, "placecollectionprivileges")>
			<cfset session.placecollectionprivileges = model("place_collectionprivilege").getUserCollections(userid=session.userid,structure=true) />
		</cfif>

		<cfif structKeyExists(session, "userid") and not StructKeyExists(session, "placephototypeprivileges")>
			<cfset session.placephototypeprivileges = model("place_phototypeprivilege").getUserPhotoTypes(userid=session.userid,structure=true) />
		</cfif>

		<cfif structKeyExists(session, "userid") and not StructKeyExists(session, "placefiletypeprivileges")>
			<cfset session.placefiletypeprivileges = model("place_filetypeprivilege").getUserFileTypes(userid=session.userid,structure=true) />
		</cfif>

		<cfif structKeyExists(session, "userid") and not structKeyExists(session, "placereportprivileges")>
			<cfset session.placereportprivileges = model("place_reportprivilege").getUserReports(
					userid=session.userid,
					structure=true) />
		</cfif>

	</cffunction>
	
	<cffunction 
		name="getUserNotice"
		hint="Metoda pobiera liste powiadomien użytkownika">
		
		<cfif StructKeyExists(session, "userid") and (not StructKeyExists(session, "noticeTime") or not StructKeyExists(session, "notice") or Minute(Now() - session.noticeTime) gt 10)>
			
			<cfset session.noticeTime = Now() />
			
			<cfset session.notice = model("users_notice").findAll(where="userid=#session.userid#", order="id DESC", maxRows=10) />
			
		</cfif>
		
	</cffunction>

</cfcomponent>
