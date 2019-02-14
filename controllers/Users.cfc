<cfcomponent
	extends="Controller" >

	<cffunction name="init">
		<cfset super.init() />
		<cfset filters(through="before",type="before") />
	</cffunction>

	<cffunction name="before">
		<cfset bodyImportFiles(fileName = "initDatePicker") />
		<cfset APPLICATION.ajaxImportFiles &= ",widget.PrzetrzymaneFaktury" />
		<cfset usesLayout("/layout") />
	</cffunction>

	<cffunction name="index">
		
		<cfif not IsDefined("params.page")>
			<cfset params.page = 1>
		</cfif>
	
		<cfset users = model("user").findAll(page=params.page,perPage=12,order="login",where="active=1")>
	</cffunction>

	<!---
		29.03.2013
		Zmieniam stronę profilową użytkownika.
		Po zmianie widok VIEW pokazuje podatawowe dane o uzytkowniku (lewa kolumna).
		Wszystkie dodatkowe informacje są wyświetlane na zasadzie widgetów. Widgety
		będą cachowane co pół godziny aby ograniczyć zapytania do bazy.
	--->
	<cffunction
		name="view"
		hint="Prezentowanie profile użytkownika">

		<!---
			29.03.2013
			Pobieram podstawowe informacje o użytkowniku, które są wyświetlane
			w lewej kolumnie na stronie.
		--->
		<cfset user_attribute = model("viewUserAttributeValue").getUserAttributes(
			userid=params.key) >

		<!---
			1.04.2013
			Pobieram cały wiersz z tabeli opisującej użytkownika.
		--->
		<cfset user = model("user").findByKey(params.key) />

		<!---
			2.04.2013
			Pobieram listę dostępnych dla użytkownika widgetów.
		--->
		<cfif structKeyExists(params, "edit") and params.edit is true>
			<cfset user_available_widgets = model("widget_widget").getUserAvailableWidgets(
				userid = session.user.id) />
		</cfif>

		<!---
			2.04.2013
			Lista aktywnych widgetów użytkownika.
		--->
		<cfset user_widgets = model("widget_widget").getUserWidgets(
			userid = session.user.id) />

		<!---
			2.04.2013
			Pobieram listę ostatnio zalogowanych użytkowników.
			Zapytanie jest cachowane raz na 5 minut.
		--->
		<cfset last_logged_in = model("user").getLastLoggedIn() />

		<!---
			3.04.2013
			Pobieram statystyki do wyświetlania w lewym panelu użytkownika.
			Zapytania są cachowane raz na 15 minut.
		--->
		<cfset stat_workflows = model("workflow").statUserWorkflow(userid = session.user.id) />
		<!---<cfset stat_messages = model("message").statUserMessage() />--->
		<cfset stat_posts = model("post").statUserPost(userid = session.user.id) />
		<!---<cfset stat_materials = model("material_material").statUserMaterial() />--->
		<cfset stat_places = model("place_instance").statUserPlace(userid = session.user.id) />
		<cfset stat_proposals = model("proposal").statUserProposals(userid = session.user.id) />
		<cfset stat_proposals_to_accept = model("proposal").statUserToAcceptProposals(userid = session.user.id) />
		<cfset stat_instructions = model("instruction").statUserInstructions(userid = session.user.id) />
		<!---<cfset stat_ideas = model("idea").statUserIdeas() />--->
		<cfset stat_correspondences = model("correspondence").statCorrespondences() />
		<!---<cfset stat_ssg = model("ssgQuestionary").statStoreSsg(userid = session.user.id) />--->
		<cfset stat_folder = model("folder_folder").statNewFolders(userid = session.user.id) />
		<cfset stat_document = model("folder_document").statNewDocuments(userid = session.user.id) />
		<cfset stat_questionnaires = model("user_user").iloscAktywnychAnkiet() />
		<cfset stat_video = model("user_user").iloscNowychMaterialowVideo(userid = session.user.id) />
		<cfset kanal_audio = model("store_audio").pobierzAudioSklepu(session.user.login) />
		<cfset konkurs_sprzedawcow = model("Konkurs_sprzedawcow").findAll(where="projekt='#session.user.login#'") />

	</cffunction>

	<cffunction name="manageUserGroups" hint="Przypisanie użytkownika do grup">
		<cfset user_groups = model("userGroup").findAll(where="userid=#params.key#",include="user,group")>
	</cffunction>

	<cffunction name="updateUserGroup" hint="Aktualizuje dostęp użytkownika do danej grupy">

		<cfif isAjax()>
			<cfset user_group = model("userGroup").findByKey(params.key)>
			<cfset user_group.update(access=1-user_group.access)>
			<cfset message = "Dostęp został zaktualizowany">
		<cfelse>
			<cfset message = "Niepoprawdze wywołanie żądania">
		</cfif>

		<cfset renderWith(data=message,layout=false)>

	</cffunction>

	<!---
		01.06.2012
		Automatyczne logowanie użytkownika

		7.04.2013
		Zmieniłem sposób logowania użytkownika. Nie ma już serwerów logowania.
		Teraz wszystkie dane są zaczytywane z widgetów. Jak jestem partnerem,
		to moje widgety pobierają dane o mnie.

		Do modyfikacji pozostaje jeszcze logowanie przy pomocy tokenu. To przeniosę
		do komponentu Controller, aby było niezależne od samego logowania.
	--->
	<cffunction
		name="logIn">

		<!---<cfdump var="#Decrypt('+2\.%N+T*6=[MZ$0', get('loc').intranet.securitysalt)#" />--->
		<!---<cfabort />--->

		<cfcookie name = "IntranetAutoLogin" value = "#Now()#" expires = "NOW" />

		<!---<cfif not (Find("10.99", CGI.REMOTE_ADDR) or 
			Find("10.10", CGI.REMOTE_ADDR) or
			Find("10.190", CGI.REMOTE_ADDR))>--->
		
		<cfif (not Find("10.", CGI.REMOTE_ADDR) ) <!---or (StructKeyExists(params, "sendsms") and params.sendsms eq 'true')---> >

			<cfif IsDefined("session.smsvalidto") AND DateCompare(session.smsvalidto, Now()) EQ 1>

				<cfset oUser = model("user").New() />
				<cfset renderWith(data="oUser",layout="/authlayout") />

			<cfelse>

				<cfset redirectTo(controller="Users",action="sms") />

			</cfif>

		<cfelse>

			<cfset oUser = model("user").New() />
			<cfset renderWith(data="oUser",layout="/authlayout") />

		</cfif>

		<cfif IsDefined("session.user")>
			<cfset redirectTo(controller="Users",action="view",key=session.user.id) />
		</cfif>

	</cffunction>

	<!---
	1.06.2012
	Automatyczne logowanie użytkownika.
	Sposób działania metody:
	- pobiera id usera z ciastka
	- wyszukuje usera w bazie intranetowej
	- autoryzuje się do serwera LDAP
	- aktualizuje dane
	- aktualizuje dane usera w bazie intranetu
	- przenosi do profilu usera
	--->
	<cffunction
		name="autoLogIn"
		hint="Automatyczne logowanie usera.">

		<cftry>

			<cfif IsDefined("Cookie.IntranetAutoLogin") is True>

				<!--- Jeśli jest ciastko to pobieram usera z lokalnej bazy --->
				<cfset user = model("user").findByKey(Cookie.IntranetAutoLogin) />

				<!--- Loguje się do serwera LDAP --->
				<cfldap
					action="query"
					attributes="sAMAccountName,mail,memberOf,sn,givenName,distinguishedName,company,title,department,description,telephoneNumber,manager,streetAddress"
				filter="(&(objectCategory=person)(objectClass=user)(samaccountname=#user.samaccountname#))"
				name="ldapuser"
				password="#Decrypt(user.password, get('loc').intranet.securitysalt)#"
				server="#get('loc').ldap.server#"
				username="#user.samaccountname#@#get('loc').ldap.domain#"
				start="ou=Monkey Group,dc=mc,dc=local">



				<!--- WIELKA AKTUALIZACJA UŻYTKOWNIKA --->
				<!--- Aktualizuje użytkownika z ldap do intranetu --->
				<!--- Aktualizuję atrybuty użytkownika z LDAP do Intranetu --->
				<cfset loc.ldap = {} />
				<cfset loc.ldap.company		=	ldapuser.company />
				<cfset loc.ldap.title		=	ldapuser.title />
				<cfset loc.ldap.description	=	ldapuser.description />
				<cfset loc.ldap.department	=	ldapuser.department />
				<cfset loc.ldap.telephoneNumber	=	ldapuser.telephoneNumber />

				<cfset userattributevalues = model("userAttributeValue").ldapToIntranet(userid=user.id,ldap=loc.ldap,callbacks=false) />
				<!--- Aktualizuję tabele z użytkownikami --->
				<cfset toupdate = {} />
				<cfset toupdate.firstlogin = 0 /> <!--- Informacja, czy uzytkownik loguje się pierwszy raz do Intranetu, czy nie. Jest to wykorzystywane przy aktualizowaniu atrybutów użytkownika. --->
				<cfset toupdate.last_login = Now() />
				<cfset toupdate.distinguishedName = ldapuser.distinguishedName /> <!--- Aktualizuje pole distinguishedName --->
				<cfset toupdate.manager = ldapuser.manager /><!--- 17.05.2012 Dodałem atrybut manager. Aktualizuję go przy każdym zalogowaniu--->
				<cfset user.update(callbacks=false,properties=toupdate) />
				<!--- KONIEC WIELKIEJ AKTUALIZACJI UŻYTKOWNIKA --->

				<!---
				04.06.2012
				Aktualizuję nazwę departamentu użytkownika
				--->
				<cfset tmp_usr = model("user").updateUserDepartment(userid=user.id,dn=ldapuser.distinguishedName,callbacks=false) />

				<!--- ZAPISYWANIE USTAWIEŃ W SESJI --->
				<cfset session.user = user />
				<cfset session.userid = user.id>
				<!---<cfset session.rules = model("acl").findAll(where="userid=#user.id# AND groupaccess=1 AND ruleaccess=1") />--->
				<!--- <cfset session.distinguishedName = intranetuser.distinguishedName /> ---> <!--- Zapisuje pole distinguishedName w sesji aby mieć do niego dostęp przy aktualizacji danych użytkownika. --->
				<!---
					9.05.2012
					Dodaję listę grup, do których należy użytkownik.
					Grupy są potrzebne przy tworzeniu menu (ukrywanie opcji, do których dana grupa nie ma dostępu).
				--->
				<cfset session.usergroups = model("userGroup").findAll(where="userid=#user.id# AND access=1",select="groupname,groupid",include="group") />

				<!--- Zapisanie menu użytkownika w sesji --->
				<cfset session.usermenus = model("viewUserMenu").findAll(where="userid=#user.id# AND usermenuaccess=1", order="menuname, ord ASC") />

				<cfinclude template="../include/places_privileges.cfm" />

				<cfset redirectTo(controller="Users",action="view",key=user.id) />

			</cfif>

		<cfcatch type="any">

			<!--- Jesli nie znaleziono użytkownika w bazie --->
			<cfif find("525", cfcatch.message)>
				<cfset flashInsert(login="Nie ma takiego użytkownika w bazie danych.")>
				<!--- Wysłanie maila z informacją o próbie zalogowania --->

			<!--- Jeśli podano złe hasło --->
			<cfelseif find("52e", cfcatch.message)>
				<cfset flashInsert(login="Podano nieprawidłowe hasło.")>
				<!--- Wysłanie maila z informacją o złym haśle --->

			<!--- Jeśli nie można się zalogować w tym momencie --->
			<cfelseif find("530", cfcatch.message)>
				<cfset flashInsert(login="Nie można zalogować w tym momencie")>
				<!--- Wysłanie maila, że nie można się zalogować w tym momencie --->

			<!--- Jeśli nie można się zalogować z tego komputera --->
			<cfelseif find("531", cfcatch.message)>
				<cfset flashInsert(login="Nie można zalogować na tym komputerze")>
				<!--- Wysyłanie maila do użytownika, że ktoś z tego IP próbował się zalogować --->

			<!--- Jeśli hasło wygasło --->
			<cfelseif find("532", cfcatch.message)>
				<cfset flashInsert(login="Dotychczasowe hasło wygasło")>
				<!--- Wysyłanie maila, że hasło dla tego użytkownika wygasło --->

			<!--- Jeśli konto jest nieaktywne --->
			<cfelseif find("533", cfcatch.message)>
				<cfset flashInsert(login="Konto jest nieaktywne. Skontaktuj się z Departamentem Informatyki")>
				<!--- Wysłanie maila z informacją, że próbował się zlogować użytkownik o nieaktywnym koncie --->

			<!--- Jeśli konto wygasło --->
			<cfelseif find("701", cfcatch.message)>
				<cfset flashInsert(login="Konto wygasło. Skontaktuj się z Departmentem Informatyki")>
				<!--- Wysłanie maila do administratorów --->

			<!--- Jeśli hasło musi być zresetowane --->
			<cfelseif find("773", cfcatch.message)>
				<cfset flashInsert(login="Musisz zmienić hasło")>
				<!--- Formularz zmiany hasła i email do administratorów --->

			<!--- Jeśli konto jest zablokowane --->
			<cfelseif find("775", cfcatch.message)>
				<cfset flashInsert(login="Twoje konto jest zablokowane. Skontaktuj się z Departamentem Informatyki")>
				<!--- Wysłanie wiadomości z informacją o zablokowaniu konta --->

			<!--- Nieudane połączenie z powodu złego hasła lub loginu --->
			<cfelseif find("bind", cfcatch.message)>
				<cfset flashInsert(login="Niepoprawna nazwa użytkownika lub hasło.")>
<!--- 					<cfset REQUEST.errmsg  = "Nieprawidłowa nazwa u¿ytkownika lub has³o - nieudane połączenie"> --->

			<!--- Jeśli wystąpił inny błąd przy próbie połączenia --->
			<cfelse>

				<cfset flashInsert(login=cfcatch.message) />
<!--- 					<cfset flashInsert(login="Wystąpił nieznany błąd przy próbie autoryzacji. Skontaktuj się z Departamentem Informatyki") />					 --->
			</cfif>

			<!--- Usuwam ciastko z automatycznym logowaniem --->
			<cfcookie name = "IntranetAutoLogin"
			    value = "#Now()#"
			    expires = "NOW">
			<cfset redirectTo(controller="Users",action="logIn")>

		</cfcatch>

		</cftry>

	</cffunction>

	<!---
		4.01.2012 Autoryzacja poprzez LDAP

		Sprawdzam poprzez LDAP czy istnieje użytkownik o podanym loginie i haśle. Jeśli użytkownik istnieje to aktualizuje
		informacje o nim w bazie: login, email firmowy, grupy organizacyjne, do których należy.

		Jeśli użytkownika nie ma w lokalnej bazie to dodaje go, przypisuje do grup z LDAP.

		9.05.2012
		Dodałem nowe pole zapisywane w sesji session.usergroups. Jest to lista grup, do których jest przypisany użytkownik.
		Grupy są potrzebne np. do tworzenia menu (ukrywanie opcji, do których nie ma dostępu dana grupa).

		16.05.2012
		Dodałem funkcjonalność pobierania listy menu dla zalogowanego użytkownika. Menu przechowywane jest w sesji.

		17.05.2012
		Pobierany jest dodatkowy parametr użytkownika - manager. Przechowuje informacje i przełożonym użytkownika.

		TODO
		Dorobić automatyczne przekazywanie faktury w obiegu z controllingu do przełożonego.

		7.04.2013
		Zmieniłem procedurę logowania użytkownika. Najpierw sprawdzam, czy
		użytkownik znajduje się w bazie LDAP. Jak tak to go loguję i aktualizuje
		lokalne dane. Jeżeli nie to loguję użytkownika po bazie Intranetowej.
	--->

	<cffunction
		name="actionLogIn"
		hint="Autoryzacja użytkownika.">

		<!---
			7.04.2013
			Zmieniłem sposób logowania się do Intranetu.
			Najpierw sprawdzam, czy użytkownik istnieje w bazie AD.
		--->
		<cftry>

			<!---
				7.04.2013
				Odpytuje serwer LDAP poprzez użytkownika Intranet aby sprawdzić,
				czy istnieje użytkownik o podanym loginie.
			--->
			<cfldap
				action="query"
				attributes="sAMAccountName"
				filter="(&(objectCategory=person)(objectClass=user)(samaccountname=#params.user.login#))"
				name="ldapUserExists"
				start="ou=Monkey Group,dc=mc,dc=local"
				server="#get('loc').ldap.server#"
				username="#get('loc').ldap.user#"
				password="#get('loc').ldap.password#" />

			<!---
				Jeżeli nie ma takiego użytkownika to sprawdzam w bazie lokalnej
				Intrnetu.
			--->
			<cfif ldapUserExists.RecordCount EQUAL 0>

				<cfset qUser = model("user").findOne(where="login='#Trim(params.user.login)#' AND active=1",order="created_date DESC") />

				<!---
					Jeżeli istnieje użytkownik o podanym loginie w bazie
					Intranetu to sprawdzam, czy podano dobre dane logowania.
				--->
				<cfif not isBoolean(qUser)>

					<!---
						Sprawdzam, czy zgadzają się hasła/
					--->
					<cfif Compare(
							Decrypt(qUser.password,get('loc').intranet.securitysalt),
							Trim(params.user.password)) EQUAL 0 >

						<!---
							8.04.2013
							Tutaj zapisuje w sesji dane uzytkownika.
							Dodatkowo zapisuje czas trwania sesji aby zrobić licznik.
						--->
						<cfset session.user = qUser />
						<cfset session.userid = qUser.id />
						<cfset session.tree_groups = model("tree_groupuser").getUserTreePrivileges(userid = qUser.id) />

						<!---
							Sprawdzam, czy jestem zalogowany.
						--->
						<cfset session.loggedin = true />

						<!---
							Zapisuje przedział ostatniego logowania.
						--->
						<cfset qUser.date_from = qUser.date_to />
						<cfset qUser.date_to = Now() />
						<cfset qUser.last_login = Now() />
						<cfset qUser.save() />

						<cfset redirectTo(controller="Users",action="view",key=qUser.id) />

					<!---
						Podane hasło jest nieprawidłowe. Rzucam wyjątek.
					--->
					<cfelse>

						<cfthrow
							type="any"
							message="Podano nieprawidłowy login lub hasło." />

						<!---<cfset redirectTo(controller="Users",action="logIn",error="Podano nieprawidłowy login lub hasło.") />--->

					</cfif>

				<cfelse>

					<cfthrow
						type="any"
						message="Nie ma takiego użytkownika." />

					<!---<cfset redirectTo(controller="Users",action="logIn",error="Nie ma takiego użytkownika.") />--->

				</cfif>

			<!---
				Jeżeli taki użytkownik istnieje to loguje się poprzez podane przez
				niego w formularzu dane.
			--->
			<cfelse>

				<!---
					Pobieram dane z serwera LDAP.
				--->
				<cfldap
				action="query"
				attributes="sAMAccountName,mail,memberOf,sn,givenName,distinguishedName,company,title,department,description,telephoneNumber,manager,streetAddress"
				filter="(&(objectCategory=person)(objectClass=user)(samaccountname=#params.user.login#))"
				name="ldapUser"
				password="#params.user.password#"
				server="#get('loc').ldap.server#"
				username="#params.user.login#@#get('loc').ldap.domain#"
				start="ou=Monkey Group,dc=mc,dc=local"
				maxrows="1" />

				<!---
					Pobieram użytkownika z serwera Intranetu
				--->
				<cfset localUser = model("user").findOne(where="samaccountname='#ldapUser.samaccountname#' AND active = 1") />

				<!---
					Jeżeli taki użytkownik istnieje w bazie lokalnej to
					aktualizuje jego dane i przechodzę do jego profilu.
				--->
				<cfif isObject(localUser)>

					<cfset localUser.memberof = ldapUser.memberof />
					<cfset localUser.distinguishedName = ldapUser.distinguishedname />
					<cfset localUser.manager = ldapUser.manager />
					<cfset localUser.last_login = Now() />
					<cfset localUser.password = Encrypt(params.user.password, get('loc').intranet.securitysalt) />
					<cfset localUser.date_from = localUser.date_to />
					<cfset localUser.date_to = Now() />
					<cfset localUser.smsvalidtokento =  DateAdd("h", 1, Now()) />
					<cfset localUser.save(callbacks=false) />

					<cfset session.user = localUser />
					<cfset session.userid = localUser.id />
					<cfset session.tree_groups = model("tree_groupuser").getUserTreePrivileges(userid = localUser.id) />

					<!---
						Sprawdzam, czy jestem zalogowany.
					--->
					<cfset session.loggedin = true />

					<cfset redirectTo(controller="Users",action="view",key=localUser.id) />

				<!---
					Jeżeli nie ma takiego użytkownika w lokalnej bazie to go
					dodaje i automatycznie loguje.
				--->
				<cfelse>

					<cfset oLdapUser = QueryToStruct(Query=ldapUser) />

					<cfset newLocalUser = model("user").new(oLdapUser.ROWS[1]) />
					<cfset newLocalUser.password = Encrypt(params.user.password, get('loc').intranet.securitysalt) />
					<cfset newLocalUser.created_date = Now() />
					<cfset newLocalUser.last_login = Now() />
					<cfset newLocalUser.photo = "monkeyavatar.png" />
					<cfset newLocalUser.login = ldapUser.samaccountname />
					<cfset newLocalUser.date_from = Now() />
					<cfset newLocalUser.date_to = Now() />
					<cfset newLocalUser.smsvalidtokento =  DateAdd("h", 1, Now()) />
					<cfset newLocalUser.save(callbacks=false) />
					
					<!--- Generuje atrybuty użytkownika --->
					<cfinvoke 
						method="generateUserBlankAttributes"
						component="models.User"
						returnvariable="ifPrivileges" >
						
						<cfinvokeargument 
							name="userid" 
							value="#newLocalUser.id#" />
						
					</cfinvoke>

					<cfset session.user = newLocalUser />
					<cfset session.userid = newLocalUser.id />
					<cfset session.tree_groups = model("tree_groupuser").getUserTreePrivileges(userid = newLocalUser.id) />

					<!---
						Sprawdzam, czy jestem zalogowany.
					--->
					<cfset session.loggedin = true />

					<cfset redirectTo(controller="Users",action="view",key=newLocalUser.id) />

				</cfif>

			</cfif>

			<cfcatch type="any">

				<!--- Jesli nie znaleziono użytkownika w bazie --->
				<cfif find("525", cfcatch.message)>
					<cfset flashInsert(login="Nie ma takiego użytkownika w bazie danych.") />

				<!--- Jeśli podano złe hasło --->
				<cfelseif find("52e", cfcatch.message)>
					<cfset flashInsert(login="Podano nieprawidłowe hasło.") />

				<!--- Jeśli nie można się zalogować w tym momencie --->
				<cfelseif find("530", cfcatch.message)>
					<cfset flashInsert(login="Nie można zalogować w tym momencie.") />

				<!--- Jeśli nie można się zalogować z tego komputera --->
				<cfelseif find("531", cfcatch.message)>
					<cfset flashInsert(login="Nie można zalogować na tym komputerze.") />

				<!--- Jeśli hasło wygasło --->
				<cfelseif find("532", cfcatch.message)>
					<cfset flashInsert(login="Dotychczasowe hasło wygasło.") />

				<!--- Jeśli konto jest nieaktywne --->
				<cfelseif find("533", cfcatch.message)>
					<cfset flashInsert(login="Konto jest nieaktywne. Skontaktuj się z Departamentem Informatyki.") />

				<!--- Jeśli konto wygasło --->
				<cfelseif find("701", cfcatch.message)>
					<cfset flashInsert(login="Konto wygasło. Skontaktuj się z Departmentem Informatyki") />

				<!--- Jeśli hasło musi być zresetowane --->
				<cfelseif find("773", cfcatch.message)>
					<cfset flashInsert(login="Musisz zmienić hasło") />

				<!--- Jeśli konto jest zablokowane --->
				<cfelseif find("775", cfcatch.message)>
					<cfset flashInsert(login="Twoje konto jest zablokowane. Skontaktuj się z Departamentem Informatyki") />

				<!--- Nieudane połączenie z powodu złego hasła lub loginu --->
				<cfelseif find("bind", cfcatch.message)>
					<cfset flashInsert(login="Niepoprawna nazwa użytkownika lub hasło.") />

				<cfelse>
					<cfset flashInsert(login=cfcatch.message) />
				</cfif>

				<cfset redirectTo(controller="Users",action="logIn") />

			</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="restartSession"
		hint="Przedłużenie sesji użytkwnika">

		<cfset session.give_me_more_time = true />
		
		<cfset renderPage(layout=false) />

	</cffunction>

	<cffunction name="logOut" hint="Wylogowywanie użytkownika.
									Wszystkie informacje zapisane w sesji zostają skasowane.">

		<cfset StructDelete(session, "user")>
		<cfset StructDelete(session, "rules")>
		<cfset StructDelete(session, "userid")>
		<cfset StructDelete(session, "usergroups") />
		<cfset StructDelete(session, "usermenus") />
		<cfset StructDelete(session, "placestepprivileges") />
		<cfset StructDelete(session, "placeformprivileges") />
		<cfset StructDelete(session, "placecollectionprivileges") />
		<cfset StructDelete(session, "placephototypeprivileges") />
		<cfset StructDelete(session, "placefiletypeprivileges") />
		<cfset StructDelete(session, "placereportprivileges") />
		<cfset StructDelete(session, "tree_groups") />

		<cfset structClear(session) />

		<!--- Usuwam ciastko z automatycznym logowaniem --->
		<cfcookie name = "IntranetAutoLogin"
		    value = "#Now()#"
		    expires = "NOW">

		<cfset redirectTo(controller="Users",action="logIn",success="Zostałeś wylogowany")>

	</cffunction>

	<cffunction name="addFeed">
		<cfset user_feed = model("userFeed").findAll(where="userid=#session.userid#",include="feedDefinition")>
	</cffunction>

	<!---
	Dodawanie użytkownika do danego kanału rss
	--->
	<cffunction name="actionAddFeed" hint="Dodawanie uprawnienia użytkownika do danego kanału rss">

		<cfif isAjax()>
			<cfset user_feed = model("userFeed").findByKey(params.key)>
			<cfset user_feed.update(access=1-user_feed.access)>
			<cfset message = "Dostęp do kanału został zaktualizowany">
		<cfelse>
			<cfset message = "Niepoprawdze wywołanie żądania">
		</cfif>

		<cfset renderWith(data=message,layout=false)>

	</cffunction>

	<!---
	Pobieranie strony głównej profilu użytkownika.
	--->
	<cffunction name="getUserProfile" hint="Pobieranie strony głównej profilu użytkownika.">

		<!---
			30.10.2012
			Dodaje breadcrumbs. Minusem tego rozwiązania jest umieszczenie dodatkowej
			linijki w każdej metodzie, która ma się wykonać i która ma pokazywać okruszki chleba.
		--->

		<!---<cfset APPLICATION.cfc.breadcrumbs.push(page_name="Mój profil") />--->

		<!---
		15.05.2012
		Pobieram informacje o tym, kto jest Prezesem
		--->
		<cfset workflowsetting = model("workflowSetting").findOne(where="workflowsettingname='chairman'") />
		<cfset chairman = listToArray(workflowsetting.workflowsettingvalue, ":", false, true) /> <!--- Wyciągam identyfikator Prezesa --->

		<!--- Podstawowe parametry użytkownika jak login czy data utworzenia konta --->
		<!--- Dorobić automatyczne przydizelanie do departamentu --->
<!--- 		<cfset user = model("user").findAll(where="id=#params.key#",include="department")> --->

		<!---
		28.06.2012
		Modyfikacja sposobu wyświetlania profilu i podglądania go przez inną osobę.
		Nie sprawdzam, czy jestem zalogowany jako dopiet. Po prostu pobieram dane dla tego użytkownika,
		który był przekazany w URL.

		Jeśli chcę obejrzeć nie swój profil to renderuje inny widok (pod koniec tej metody).
		--->
		<!--- Tylko jeden użytkownik może podglądać profile innych użytkowników --->
<!--- 		<cfif session.userid eq 2>  --->
<!--- 		 --->
<!--- 			<cfset loc.userid = params.key /> --->
<!--- 			<cfset user = model("user").findAll(where="id=#params.key#")> --->
<!--- 		 --->
<!--- 		<cfelse> --->
<!--- 		 --->
<!--- 			<cfset loc.userid = session.userid /> --->
			<!--- Id użytkownika pobierany z sesji --->
<!--- 			<cfset user = model("user").findAll(where="id=#session.userid#")>  --->

<!--- 		</cfif> --->
		<cfset loc.userid = params.key />
		<cfset user = model("user").findAll(where="id=#loc.userid#") />

		<cfif user.active eq 0>
			<cfset redirectTo(controller="Users",action="getUserProfile",key=session.userid) />
		</cfif>

		<!--- Wszystkie atrybuty opisujące użytkownika --->
		<cfset user_attribute = model("viewUserAttributeValue").findAll(where="userid=#loc.userid#",order="ord ASC") >

		<!---
		28.06.2012
		Pobieram strukturę organizacyjną firmy.
		--->
		<!--- <cfset organizationstructure = model("user").findAll(select="departmentname",distinct=true,order="departmentname ASC",where="departmentname IS NOT NULL") /> --->

		<!---
		17.07.2012
		Zmienił się sposób pobierania i wyświetlania struktury organizacyjnej firmy. Jest utworzony widok zawierający
		strukturę drzewa pracowników. Każdy pracownik posiada nazwę stanowiska, które zajmuje.
		Pobieramy jest pierwszy poziom drzewa.
		--->
		<cfset organizationstructure = model("user").getRoot() />
		<cfset renderPartial("organizationstructure") />

		<!---
		Początek pobierania danych fo wykresu przedstawiającego godziny pracy.
		Idea jest taka aby pobrać imię i nazwisko z atrybutów użytkowika i po tych polach wyciągać dane z RCP.

		TODO
		Optymalny sposób pobierania danych do RCP.
		Dodać flagę, która nie pozwala na usunięcie atrybutów

		DONE 4.02.2012
		--->

		<!--- Pobieram wszystkie godziny dla danego użytkownika --->
		<!---
<cftry>

			<cfset rcp = model("rcp").findAll(where="C_Time_start is not null AND C_Time_stop is not null AND C_Name != 'Nie przypisano' AND C_Name_start LIKE '%#user.sn# #user.givenname#%'",order="C_Date_start asc")>

		<cfcatch type="any">

			<cfset rcp = {}>

		</cfcatch>

		</cftry>
		--->

		<!---
		Pobieram strukturę organizacyjną, do której należy uzytkownik

		28.06.2012
		Usunąłem w profilu użytkownika ramkę ze strukturą organizacyjną.
		--->
<!--- 		<cfset userorganizations = model("userOrganizationUnit").findAll(where="userid=#params.key#",order="ord DESC",include="user,organizationUnit")> --->

		<!---
		Pobieram kanały RSS subskrybowane przez użytkownika

		28.06.2012
		Usunąłem z profilu użytkownika ramkę z kanałami RSS.
		--->
<!--- 		<cfset user_feeds = model("userFeed").findAll(where="userid=#params.key# AND access=1",include="feedDefinition")> --->

		<!--- Pobieram ostatnie 8 wiadomości rss z kanałów użytkownika --->
		<!--- <cfset user_last_feed = model("userFeed").findAll(where="userid=#params.key#",include="feedDefinition(feed)",maxRows=8,order="pubdate DESC")> --->

		<!--- Pobieram obiekty, które są przypisane do użytkownika --->
		<!--- <cfset user_objects = model("userObjectInstance").findAll(where="userid=#loc.userid# AND access=1",include="objectInstance")> --->

		<!---
		Pobieram grupy uprawnień, do których należy użytkownik

		28.06.2012
		Usunąłem w profilu użytkownika listę uprawnień, do których należy użytkownik.
		--->
<!--- 		<cfset usergroups = model("userGroup").findAll(where="userid=#loc.userid# AND access=1",include="group") /> --->

		<!--- Buduję listę identyfikatorów grup, do których nalezy uzytkownik --->
		<!--- 24.04.2012 Zmieniłem sposób przypisywania i pobierania komunikatów użytkownika --->
		<!---
		<cfset usermessagegroups = "" />
		<cfloop query="usergroups">
			<cfset usermessagegroups &= groupid & "," />
		</cfloop>
		<cfset usermessagegroups = Left(usermessagegroups, Len(usermessagegroups)-1) />
		--->

		<!---
			24.04.2012
			Pobieram listę komunikatów, które zostały przypisane do grupy użytkownika.

			21.11.2012
		 	Do generowania komunikatów napisałem procedurę na bazie. Pobierane jest ostatnich 12 komunikatów.
		--->
		<cfset mymessages = model("userMessage").getMessages(userid=loc.userid,page=1,num=6) />
		<cfset renderPartial("usermessages") />

		<!---
		24.04.2012
		Pobieram listę dokumentów w obiegu.
		Dokumenty zostaną wyświetlone w taki dam sposób, jak pojawiają się komunikaty.

		15.05.2012
		Sprawdzam, czy jestem zalogowany jako Prezes. Jeśli tak to pobieram inne dane z bazy i wyświetlam inny formularz.
		--->
		<cfif chairman[1] eq session.user.id> <!--- Jeśli jestem zalogowany jako prezes --->

			<cfset userworkflow = model("workflow").getChairmanActiveWorkflow() />

		<cfelse>

			<!---
				19.11.2012
				Korzystam z procedury na bazie danych, która pobiera listę 12 najnowszych aktywnych dokumentów użytkownika.
			--->
			<cfset myworkflow = model("workflow").v2_getUserLastActiveWorkflow(userid="#loc.userid#",page=1,num=12) />
			<cfset renderPartial("userworkflow") />

		</cfif>

<!--- 		<cfset userproposals = model("proposal").findAll(where="userid=") /> --->

		<!--- Pobieram listę użytkowników, który dzisiaj logowali się do Intranetu --->
		<cfset loggedincondition = "#DateFormat(Now(), 'yyyy-mm-dd')#" />
		<cfset userslastloggedin = model("user").findAll(where="last_login > '#loggedincondition#' AND firstlogin <> 1",select="id,photo,sn,givenname,login",order="last_login DESC",maxRows="20") />
		<cfset renderPartial("lastloggedin") />

		<!--- Pobieram listę wszystkich wniosków użytkownika --->
		<!---
		13.06.2012
		Jeśli jestem zalogowany jako Prezes pobieram inne dane do widoku z wnioskami
		--->
		<cfif chairman[1] eq session.userid>

			<cfset chairmanproposals = model("triggerHolidayProposal").findAll(where="managerid=#session.userid# AND proposalstep2status=1",include="proposalType,proposalStatus") />
			<cfset renderPartial("chairmanproposals") />

		<cfelse>

			<cfset myproposals = model("proposal").getUserProposals(userid=loc.userid,page=1,num=6) />
			<cfset renderPartial("userproposals") />

		</cfif>

		<!---
		Pobieram listę osób, które są dzisiaj nieobecne.

		4.07.2012
		Lista dotychczas pobierana zawierała zastępstwa osób, których nie ma. Jeżeli ktoś nie wskazał zastępstwa to nie pojawiał się na liście.
		Teraz pobierana jest lista osób, których nie ma danego dnia. Jeśli ma zastępstwo to je wyświetlam, jeśli nie ma to nie :)
		--->
<!--- 		<cfset substitutions = model("substitution").findAll(where="substituteaccess=1 AND substitutetime like '%#DateFormat(Now(), 'dd-mm-yyyy')#%'",include="user") /> --->
		<cfset substitutions = model("triggerHolidayProposal").getUserHolidays(date="#DateFormat(Now(), 'dd-mm-yyyy')#") />
<!--- 		<cfset substitutions = model("triggerHolidayProposal").getUserHolidays(date="#DateFormat(Now(), 'dd-mm-yyyy')#") /> --->
		<cfset renderPartial("substitutions") />

		<!---
			16.08.2012
			Pobieram listę aktualności dodanych do systemu.

			21.11.2012
			Do pobrania nieruchomości została zmodyfikowana procedura. Teraz można paginować po aktualnościach.
		--->

		<cfset myposts = model("post").getPostList(page=1,num=3) />
		<cfset renderPartial("posts") />

		<!---
			10.12.2012
			Pobranie listy instrukcji przypisanych do użytkownika.

			07.02.2013
			Tutaj sprawdzam, do jakich grup nalezy użytkownik i na tej podstawie
			buduje odpowiednie zapytanie do bazy danych.
		--->
		<cfparam name="where_conditions" type="string" default=""/>

		<cfif checkUserGroup(userid=session.userid,usergroupname="user") >
			<cfset where_conditions = where_conditions & " centrala=1 or " />
		</cfif>

		<cfif checkUserGroup(userid=session.userid,usergroupname="Partner Prowadzący Sklep") >
			<cfset where_conditions = where_conditions & " partner_prowadzacy_sklep = 1 or " />
		</cfif>

		<cfif checkUserGroup(userid=session.userid,usergroupname="Dyrektorzy")>
			<cfset where_conditions &=  ' dyrektorzy = 1 or ' />
		</cfif>

		<cfif checkUserGroup(userid=session.userid,usergroupname="Partner ds. ekspansji")>
			<cfset where_conditions &= ' partner_ds_ekspansji = 1 or ' />
		</cfif>

		<cfif checkUserGroup(userid=session.userid,usergroupname="Partner ds. sprzedaży")>
			<cfset where_conditions &= ' partner_ds_sprzedazy = 1 or ' />
		</cfif>

		<cfif Len(where_conditions)>
			<cfset where_conditions = Left(where_conditions, Len(where_conditions)-3) />
		</cfif>

		<cfset myinstructions = model("instruction_document").getUserInstructions(
			userid=session.userid,
			where_condition="#where_conditions#",
			limit=6) />

		<!---<cfset myinstructions = model("instruction_document").getUserInstructions(userid=session.userid) />--->
		<cfset renderPartial("instructions") />

		<!--- Pobieram ilość faktur przypisanych do użytkownika i czekających w obiegu --->
		<!--- <cfset workflowcount = model("workflowStep").count(where="userid='#loc.userid#' AND workflowstatusid=1",distinct=true) /> --->

		<!--- Sprawdzam, czy żądanie przyszło AJAXowo --->
		<cfif IsAjax()>

			<!--- Generuje inny widok dla użytkownika chcącego zobaczyć swój profil i inny widok, dla użytkownika widzącego profil innego pracownika --->
			<cfif params.key eq session.userid> <!--- Oglądam sam siebie --->

				<cfset renderWith(data="user,user_attribute,userslastloggedin,userworkflow,chairman",layout=false) />

			<cfelse> <!--- Oglądam profil innego użytkownika --->

				<!---
				Pobieram wiadomości, które wysłałem użytkownikowi, którego przeglądam.
				W sesji przechowywany jest mój ID. W zmiennej params.key znajduje się ID użytkownika, k†órego oglądam.
				--->
				<cfset privatemessages = model("userMessage").findAll(where="userid=#params.key# AND createdbyuserid=#session.userid#",include="message(user,messagePriority)") />

				<cfset renderWith(data="user,user_attribute,userslastloggedin,privatemessages",layout=false,template="viewguest") />

			</cfif>

		<cfelse> <!--- Jeśli nie przyszło AJAXowo to jeszcze nic nie robię --->

			<!--- Narazie nie robię nic. Może coś się później będzie robić :) --->

		</cfif>

	</cffunction>

	<!---
	getUserActiveWorkflow
	---------------------------------------------------------------------------------------------------------------
	Metoda zwracająca listę dokumentów wraz z krokami obiedu dokumentów przypisanymi do użytkownika.
	- numer faktury,
	- listę ukończonych/nieukończonych etapów
	- kwotę netto na fakturze

	14.05.2012
	Osobna tabelka z fakturami dla Prezesa. Tabelka ma takie informacje jak:
	numer faktury
	kontrahent,
	brutto,
	opis,
	możliwość akceptacji

	18.12.2012
	Dodałem ramkę z filtrem po aktywnych dokumentach.
	--->
	<cffunction name="getUserActiveWorkflow" hint="Lista przypisanych do użytkownika dokumentów">

		<!---
			Ustawiam domyślne wartości filtrom wyszukiwania.
		--->
		<cfparam name="page" default="1" />
		<cfparam name="month" default="#Month(Now())#" />
		<cfparam name="year" default="#Year(Now())#" />
		<cfparam name="elements" default="100" />
		<cfparam name="categoryid" default="0" />
		<cfparam name="all" default="0" />
		<cfparam name="automated" default="0" />

		<!---
			Sprawdzam, czy są zapisane wartości w sesji.
		--->
		<cfif structKeyExists(session, "workflow_filter") and structKeyExists(session.workflow_filter, "month")>
			<cfset month = session.workflow_filter.month />
		</cfif>

		<cfif structKeyExists(session, "workflow_filter") and structKeyExists(session.workflow_filter, "year")>
			<cfset year = session.workflow_filter.year />
		</cfif>

		<cfif structKeyExists(session, "workflow_filter") and structKeyExists(session.workflow_filter, "page")>
			<cfset page = session.workflow_filter.page />
		</cfif>

		<cfif structKeyExists(session, "workflow_filter") and structKeyExists(session.workflow_filter, "categoryid")>
			<cfset categoryid = session.workflow_filter.categoryid />
		</cfif>

		<!---
			Sprawdzam, czy były przesłane parametry filtrowania.
		--->
		<cfif structKeyExists(params, "workflow_filter_month")>
			<cfset month = params.workflow_filter_month />
		</cfif>

		<cfif structKeyExists(params, "workflow_filter_year")>
			<cfset year = params.workflow_filter_year />
		</cfif>

		<cfif structKeyExists(params, "page")>
			<cfset page = params.page />
		</cfif>

		<cfif structKeyExists(params, "categoryid")>
			<cfset categoryid = params.categoryid />
		</cfif>

		<cfif structKeyExists(params, "all")>
			<cfset all = params.all />
		</cfif>
		
		<cfif structKeyExists(params, "automated")>
			<cfset automated = params.automated />
		</cfif>

		<!---
			Zapisuje parametry w sesji aby móc się do niech odwołać w widoku.
		--->
		<cfset session.workflow_filter = {
			month	=	month,
			year		=	year,
			page		=	page,
			elements	=	elements,
			categoryid	=	categoryid,
			all			=	all
			} />

		<!---
			Wywołuje procedurę na bazie, która zwraca dane.
			08.01.2013
			Dodałem opcję all=1 do procedury wyszukiwania. Z tym parametrem
			zwracane są wszystkie dokumenty, które są w obiegu (nie ma filtrowania
			i paginacji).
		--->

		<cfset myworkflow = model("workflow").v2_getUserActiveWorkflow(
			year		= year
			,month	= month
			,page	= page
			,elements	= elements
			,userid	= session.user.id
			,categoryid	= categoryid
			,all		= all
			,automated= automated
		) />

		<cfset myworkflowcount = model("workflow").v2_getUserActiveWorkflowCount(
			year		= year
			,month	= month
			,userid	= session.user.id
			,categoryid	= categoryid
			,all		= all
			,automated= automated
		) />

		<!---
			30.10.2012
			Dodaje linijkę zapisującą stronę, na której jestem do generowania breadcrumbs.
		--->
		<!---<cfset APPLICATION.cfc.breadcrumbs.push(page_name="Moje aktywne dokumenty") />--->

		<!---
			18.12.2012
			Aby wygenerować filtr po aktywnych dokumentach muszę pobrać dane do przefiltrowania.
			Pobieram lata i miesiące.
		--->
		<cfset years	=	model("workflow").getYears() />
		<cfset months	=	model("workflow").getMonths() />

		<!---
			6.09.2012
			Pobieram listę typów dokumentów. Lista jest generowana na podstawie grup, do których należy użytkownik.
			Typy dokumentów są potrzebne do filtrowania wyników.
		--->
		<cfset types = model("type").getTypes() />
		
		<!--- Kategorie faktur ---> 
		<cfset categories = model("tree_groupworkflowcategory").getCategories(session.user.id) />

		<!---
			Pobieram listę etapów obiegu dokumentów
		--->
		<cfset my_steps = model("workflowstepstatuse").findAll() />

		<!---
			Pobieram ustawienia obiegu dokumentów i sprawdzam jaki id ma Prezes
		--->
		<!--- <cfset workflowsettings = model("workflowSetting").findAll(where="workflowsettingname='chairman'") /> --->

		<!---
			W pierwszym wierszu jest id Prezesa
		--->
		<!--- <cfset chairmanArray = listToArray(workflowsettings.workflowsettingvalue, ":", false, true) /> --->

		<!---
		<cfif chairmanArray[1] eq session.userid> <!--- Jeśli jestem zalogowany jako prezes to przekierowuje do innego widoku --->

			<cfset chairmanworkflow = model("workflow").getChairmanActiveWorkflow() />
			<cfset renderWith(data="chairmanworkflow,types",layout=false,template="chairmanactiveworkflow") />

		</cfif>
		--->
		
		<cfif StructKeyExists(params, "layout") and params.layout eq 'true'>
			<cfset usesLayout(true) />
		<cfelse>
			<cfset usesLayout(false) />
		</cfif>
		
		<!---<cfset renderWith(data="useractiveworkflow,types",layout=false)/>--->

	</cffunction>

	<!---
	21.05.2012
	Metoda została usunięta.

	TODO
	Usunąć zbędny wpis z tabeli z regułami.
	--->
	<!---
<cffunction name="getUserActiveWorkflowJson">

		<cfset userworkflow = model("workflow").getUserActiveWorkflow(userid=session.userid)>
		<cfset renderWith(data=userworkflow,hideDebugInformation=true,layout=false)>

	</cffunction>
--->

	<!---
	getUserWorkflow
	---------------------------------------------------------------------------------------------------------------
	Pobieram wszystkie dokumenty do których był i jest przypisany użytkownik.
	--->
	<cffunction
		name="getUserWorkflow"
		hint="Lita dokumentów użytkownika, które są w obiegu."
		description="Metoda zwraca listę dokumentów, do których był lub jest
				przypisany użytkownik.">

		<!---
			Ustawiam domyślne wartości dla paginacji.
		--->
		<cfparam
			name="page"
			default="1" />

		<cfparam
			name="elements"
			default="100" />

		<cfparam
			name="year"
			default="#Year(Now())#" />

		<cfparam
			name="month"
			default="#Month(Now())#" />

		<cfparam
			name="categoryid"
			default="0" />

		<cfparam
			name="all"
			default="0" />

		<!---
			Sprawdzam, czy zostały przesłane atrybuty do paginacji.
			Jeżeli tak to podstawiam nowe dane.
		--->
		<cfif structKeyExists(params, "page")>
			<cfset page = params.page />
		</cfif>

		<cfif structKeyExists(params, "elements")>
			<cfset elements = params.elements />
		</cfif>

		<cfif structKeyExists(params, "workflow_filter_year")>
			<cfset year = params.workflow_filter_year />
		</cfif>

		<cfif structKeyExists(params, "workflow_filter_month")>
			<cfset month = params.workflow_filter_month />
		</cfif>

		<cfif structKeyExists(params, "categoryid")>
			<cfset categoryid = params.categoryid />
		</cfif>

		<cfif structKeyExists(params, "all")>
			<cfset all = params.all />
		</cfif>

		<!---
			Zapisuje w sesji wszystkie ustawienia paginacji
		--->
		<cfset session.workflow_filter = {
			month		=	month,
			year		=	year,
			page		=	page,
			elements	=	elements,
			categoryid		=	categoryid
			} />

		<!---
			Dane niezbędne do filtrowania faktur
		--->
		<cfset years	=	model("workflow").getYears() />
		<cfset months	=	model("workflow").getMonths() />

		<!---
			6.09.2012
			Pobieram listę typów dokumentów. Lista jest generowana na podstawie grup, do których należy użytkownik.
			Typy dokumentów są potrzebne do filtrowania wyników.
		--->
		<cfset types = model("type").getTypes() />
		
		<!--- Kategorie faktur ---> 
		<cfset categories = model("tree_groupworkflowcategory").getCategories(session.user.id) />

		<!---
			Pobieram paginowaną listę dokumentów w obiegu.
		--->
		<cfset userworkflow = model("workflow").getUserWorkflow(
			userid=session.userid,
			page=page,
			elements=elements,
			year=year,
			month=month,
			categoryid=categoryid,
			all=all)/>

		<!---
			Pobieram listę wszystkich dokumentów z obiegu.
		--->
		<cfset userworkflowcount = model("workflow").getUserWorkflowCount(
			userid=session.userid,
			year=year,
			month=month,
			categoryid=categoryid,
			all=all) />

		<cfset renderWith(data="userworkflow,userworkflowcount,types,months,years",layout=false) />

	</cffunction>
	
	<cffunction name="getUserAutomatedWorkflow" hint="Lista dokumentów w obiegu automatycznym przypisanych do użytkownika">

		<!---
			Ustawiam domyślne wartości filtrom wyszukiwania.
		--->
		<cfparam
			name="page"
			default="1" />

		<cfparam
			name="month"
			default="#Month(Now())#" />

		<cfparam
			name="year"
			default="#Year(Now())#" />

		<cfparam
			name="elements"
			default="100" />

		<cfparam
			name="categoryid"
			default="0" />

		<cfparam
			name="all"
			default="0" />
			
		<cfparam
			name="automated"
			default="1" />

		<!---
			Sprawdzam, czy są zapisane wartości w sesji.
		--->
		<cfif structKeyExists(session, "workflow_filter") and structKeyExists(session.workflow_filter, "month")>
			<cfset month = session.workflow_filter.month />
		</cfif>

		<cfif structKeyExists(session, "workflow_filter") and structKeyExists(session.workflow_filter, "year")>
			<cfset year = session.workflow_filter.year />
		</cfif>

		<cfif structKeyExists(session, "workflow_filter") and structKeyExists(session.workflow_filter, "page")>
			<cfset page = session.workflow_filter.page />
		</cfif>

		<cfif structKeyExists(session, "workflow_filter") and structKeyExists(session.workflow_filter, "categoryid")>
			<cfset categoryid = session.workflow_filter.categoryid />
		</cfif>

		<!---
			Sprawdzam, czy były przesłane parametry filtrowania.
		--->
		<cfif structKeyExists(params, "workflow_filter_month")>
			<cfset month = params.workflow_filter_month />
		</cfif>

		<cfif structKeyExists(params, "workflow_filter_year")>
			<cfset year = params.workflow_filter_year />
		</cfif>

		<cfif structKeyExists(params, "page")>
			<cfset page = params.page />
		</cfif>

		<cfif structKeyExists(params, "categoryid")>
			<cfset categoryid = params.categoryid />
		</cfif>

		<cfif structKeyExists(params, "all")>
			<cfset all = params.all />
		</cfif>
		
		<cfif structKeyExists(params, "automated")>
			<cfset automated = params.automated />
		</cfif>

		<!---
			Zapisuje parametry w sesji aby móc się do niech odwołać w widoku.
		--->
		<cfset session.workflow_filter = {
			month	=	month,
			year		=	year,
			page		=	page,
			elements	=	elements,
			categoryid		=	categoryid,
			all		=	all
			} />

		<!---
			Wywołuje procedurę na bazie, która zwraca dane.

			08.01.2013
			Dodałem opcję all=1 do procedury wyszukiwania. Z tym parametrem
			zwracane są wszystkie dokumenty, które są w obiegu (nie ma filtrowania
			i paginacji).
		--->

		<cfset myworkflow = model("workflow").v2_getUserActiveWorkflow(
			year		= year
			,month	= month
			,page	= page
			,elements	= elements
			,userid	= session.user.id
			,categoryid	= categoryid
			,all		= all
			,automated= automated
		) />

		<cfset myworkflowcount = model("workflow").v2_getUserActiveWorkflowCount(
			year		= year
			,month	= month
			,userid	= session.user.id
			,categoryid	= categoryid
			,all		= all
			,automated= automated
		) />

		<!---
			30.10.2012
			Dodaje linijkę zapisującą stronę, na której jestem do generowania breadcrumbs.
		--->
		<!---<cfset APPLICATION.cfc.breadcrumbs.push(page_name="Moje aktywne dokumenty") />--->

		<!---
			18.12.2012
			Aby wygenerować filtr po aktywnych dokumentach muszę pobrać dane do przefiltrowania.
			Pobieram lata i miesiące.
		--->
		<cfset years	=	model("workflow").getYears() />
		<cfset months	=	model("workflow").getMonths() />

		<!---
			6.09.2012
			Pobieram listę typów dokumentów. Lista jest generowana na podstawie grup, do których należy użytkownik.
			Typy dokumentów są potrzebne do filtrowania wyników.
		--->
		<cfset types = model("type").getTypes() />
		
		<!--- Kategorie faktur ---> 
		<cfset categories = model("tree_groupworkflowcategory").getCategories(session.user.id) />

		<!---
			Pobieram listę etapów obiegu dokumentów
		--->
		<cfset my_steps = model("workflowstepstatuse").findAll() />

		<!---
			Pobieram ustawienia obiegu dokumentów i sprawdzam jaki id ma Prezes
		--->
		<cfset workflowsettings = model("workflowSetting").findAll(where="workflowsettingname='chairman'") />

		<!---
			W pierwszym wierszu jest id Prezesa
		--->
		<!--- <cfset chairmanArray = listToArray(workflowsettings.workflowsettingvalue, ":", false, true) />

		<cfif chairmanArray[1] eq session.userid> <!--- Jeśli jestem zalogowany jako prezes to przekierowuje do innego widoku --->

			<cfset chairmanworkflow = model("workflow").getChairmanActiveWorkflow() />
			<cfset renderWith(data="chairmanworkflow,types",layout=false,template="chairmanactiveworkflow") />

		</cfif> --->

		<cfset renderWith(data="useractiveworkflow,types",layout=false)/>

	</cffunction>

	<!---
	getUserWorkflowJson
	---------------------------------------------------------------------------------------------------------------
	Lista wszystkich dokumentów do których był i jest przypisany użytkownik. Metoda getUserWorkflow znajduje się w
	modelu Workflow. Dane są zwracane w formacie JSON.

	21.05.2012
	Metoda została usunięta.

	TODO
	Usunąć zbędna regułę
	--->
	<!---
<cffunction name="getUserWorkflowJson">

		<cfset userworkflow = model("workflow").getUserWorkflow(userid=session.userid)/>
		<cfset renderWith(data=userworkflow,hideDebugInformation=true,layout=false)/>

	</cffunction>
--->

	<!---
	getUserToWorkflowStep
	---------------------------------------------------------------------------------------------------------------
	Pobieram listę użytkowników, którym zostanie przekazany dokument z obiegu. Wynik jest zawężony do wyszukania
	frazy przesłanej w params.searchvalue
	--->
	<cffunction
		name="getUserToWorkflowStep"
		hint="Pobieram listę użytkowników, którym zostanie przekazany
				dokument z obiegu. Wynik jest zawężony do wyszukania frazy
				przesłanej w params.searchvalue">
				
		<cfif not StructKeyExists(params, "searchvalue")>
			<cfset params.searchvalue = '' />
		</cfif>
		
		<cfif not StructKeyExists(params, "step")>
			<cfset params.step = 0 />
		</cfif>
		
		<cfif not StructKeyExists(params, "searchall")>
			<cfset params.searchall = 0 />
		</cfif>
				
		<!---<cfset users = model("user").findAll(
			select="givenname,sn,id",
			where="(login LIKE '%#params.searchvalue#%' OR givenname LIKE '%#params.searchvalue#%' OR memberof LIKE '%#params.searchvalue#%' OR sn LIKE '%#params.searchvalue#%') AND active = 1 AND id <> 38",
			order="givenname, sn ASC"
		)/>--->
		
		<cfset users = model("user").getUserToWorkflowStep(params.searchvalue,params.step,params.searchall)/>
		
		<cfset json = QueryToStruct(Query=users) />
		<cfset renderWith(data="json",template="json",layout=false) />
		
	</cffunction>

	<!---
	editPhoto
	---------------------------------------------------------------------------------------------------------------
	Generowanie formularza podmieniającego avatar użytkownika.
	--->
	<cffunction
		name="editPhoto"
		hint="Metoda generująca formularz aktualizacji zdjęcia użytkownika"
		description="Metoda generująca formularz aktualizacji zdjęcia użytkownika. Zdjęcie jest dodawane przy pomocy pluginu.">
			
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="avatar">
			<cfinvokeargument name="groupname" value="Aktualizacja avatara w profilu" />
		</cfinvoke>
		
		<cfset user = model("User").findByKey(params.key) />
		
		<cfif avatar is true>
			<cfset renderPage(layout=false) />
		<cfelse>
			<cfset renderPage(template="/autherror",layout=false) />
		</cfif>
		

		<!---<cftry>

			<cfset renderWith(data="",layout=false) />

		<cfcatch type="any"> <!--- Jeśli jest zwrócony jakiś wyjątek to generują stronę z błędem --->

			<cfset error = cfcatch />
			<cfif IsAjax()>

				<cfset renderWith(data="error",layout=false,template="/apperror") />

			<cfelse>

				<cfset renderWith(data="error",template="/apperror") />

			</cfif>

		</cfcatch>

		</cftry>--->

	</cffunction>
	
	<cffunction 
		name="uploadPhoto"
		hint="Zapisuje avatar uzytkownika przed edycja">
			
		<cfparam 
			name="strField" 
			default="imagedata"/>
		
		<cfif (StructKeyExists(FORM, strField) AND Len(FORM[strField]))>
			
			<cfset myfile = APPLICATION.cfc.upload.SetDirName(dirName="users") />
			<cfset myfile = APPLICATION.cfc.upload.uploadImage(file_field="imagedata") />
			<cfset myfile.binarycontent = false />
			
			<cfscript> 
				response = StructNew();
				StructInsert(response, "cfilename", myfile.clientfilename & "." & myfile.clientfileext); 
				StructInsert(response, "sfilename", myfile.newservername);
				StructInsert(response, "thumbnail", myfile.thumbfilename);
				StructInsert(response, "fileext", myfile.clientfileext);
			</cfscript>
		</cfif>
		
		<!---<cfset variable = 'ok' />
		<cfset renderWith(data="variable",template="/dump",layout=false) />--->
		
		<cfset json = response />
		<cfset renderWith(data="json",template="json",layout=false) />
	
	</cffunction>
	
	<!---
	ajaxActionEditPhoto
	---------------------------------------------------------------------------------------------------------------
	Zapisanie nowego avataru w tabeli. Miniaturka jest w trzech rozmiarach:
	- normalny rozmiar dodany przez użytkownika,
	- miniaturka
	- mała miniaturka

	Po zapisaniu nowego obrazka użytkownik jest przekierowywany do swojej strony z profilem.
	--->
	<cffunction
		name="actionEditPhoto"
		hint="Zapisanie nowego avataru użytkownika"
		description="Edycja i zapisanie nowego avataru w tabeli z użytkownikami i przekierowanie do profilu użytkownika.">
		
		<cfif StructKeyExists(params, "key")>
			
			<cfset myfile = APPLICATION.cfc.upload.SetDirName(dirName="users") />
			<cfset myfile = APPLICATION.cfc.upload.cropAndSaveImage(
				filename	= params.filename,
				userid		= params.key,
				x1			= params.x1,
				y1			= params.y1,
				x2			= params.x2,
				y2			= params.y2,
				h			= params.h,
				w			= params.w				
			) />
			<cfset myfile.binarycontent = false />
			
			<cfif StructKeyExists(myfile, "SUCCESS") and myfile.SUCCESS eq 'true'>
				
				<cfset user = model('User').findByKey(params.key).update(photo=myfile.FILENAME) />
				
			</cfif>
			
			<cfset json = myfile />
			<cfset renderWith(data="json",template="json",layout=false) />
			
		</cfif>
		
		<!---<cfif session.userid eq 2>
			<cfset user = model("user").findByKey(params.userid) />
		<cfelse>
			<cfset user = model("user").findByKey(session.userid) />
		</cfif>--->

		<!---<cfset user.update(photo="#params.photo#",callbacks=false) />--->
		<!---<cfset redirectTo(controller="Users",action="view",key=session.userid) />--->

	</cffunction>

	<cffunction
		name="getUsersList"
		hint="Pobieranie listy użytkowników"
		description="Metoda pobiera listę użytkowników, którzy pasują do wyszukiwanego wzorca">

		<cfset users = model("user").findAll(select="givenname,sn",where="distinguishedName like '%#params.search#%' OR memberof like '%#params.search#%'") />
		<cfset renderWith(data=users,layout=false) />

	</cffunction>

	<!---
	28.06.2012
	Metoda zwracająca listę ul użytkowników z danego departamentu.

	17.07.2012
	Metoda zwraca kolejny poziom gałęzi w drzewie.
	--->
	<cffunction
		name="getBranch"
		hint="Metoda zwraca kolejny poziom gałęzi w drzewie"
		description="Metoda zwraca kolejny poziom gałęzi w drzewie.">

		<cfset user = model("viewUser").findByKey(params.id) />
		<cfset branch = model("user").getRootBranch(lft=params.lft,rgt=params.rgt) />

		<cfset renderWith(data="user,branch",layout=false) />

	</cffunction>

	<cffunction
		name="getNodeChildreen"
		hint="Pobranie dzieci danego liścia w drzewie."
		description="Metoda pobierająca listę pracowników (dzieci danego liścia).">

		<cfset users = model("user").getNodeChildreen(parentid=params.id,lft=params.lft,rgt=params.rgt,depthlevel=params.depth) />
		<cfset renderWith(data="users",layout=false) />

	</cffunction>

	<cffunction
		name="getUserPreview"
		hint="Podgląd profilu"
		description="Podgląd profilu użytkownika po najechaniu myszką na avatar użytkownika">

		<cfset attributes = model("viewUserAttributeValue").findAll(where="userid=#params.userid#")>
		<cfset user = model("user").findOne(where="id=#params.userid#") />
		<cfset renderWith(data="attributes,user",layout=false) />

	</cffunction>

	<cffunction
		name="moveBranch"
		hint="Przenoszenie gałęzi struktury organizacyjnej"
		description="Metoda przenosząca gałąź struktury organizacyjnej">

		<cfset move = model("user").moveBranch(userid=params.userid,parentuserid=params.parentuserid) />
		<cfset users = model("user").getTree() />
		<cfset renderWith(data="users",layout=false) />

	</cffunction>

	<cffunction
		name="sms"
		hint="Formularz logowania SMS"
		description="Metoda generująca token i wysyłająca go smsem.
				Dodatkowo aktualizowana jest ważność tokenu w bazie">

		<cfset usesLayout("/smslayout") />

		<cfif IsDefined("form.user_sms_submit")>

			<cfset myuser = model("viewUser").findOne(where="login='#form.login#'") />

			<cfif not IsStruct(myuser) or structIsEmpty(myuser)>
				<cfset redirectTo(controller="Users",action="sms",error="Nie ma użytkownika o podanym loginie.") />
			</cfif>

			<!---
				SMS wa ważność 30 minut.
				Przez ten czas nie jest wysyłana nowa wiadomość.
			--->
			<cfif not Len(myuser.smsvalidto) or DateCompare(myuser.smsvalidto, Now()) eq -1>

				<!---
					Aby SMS nie był wysyłany proszę odkomentować poniższą linijkę.
				--->
				<cfif not Len(myuser.mob)>
					<cfset redirectTo(controller="Users",action="sms",error="W systemie nie jest zdefiniowany numer telefonu, pod który ma zostać wysłany token.") />
				</cfif>

				<!---
					Usuwam wszystkie znaki nie będące cyframi
				--->
				<cfset mobile = onlyChars(text=myuser.mob) />

				<!---
					Generuje nowy token. Zapisuje go w bazie.
					Zapisuje ważność tokenu. Zapisuje wiadomość SMS w bazie.
				--->
				<cfset token = randomText() />
				<cfset v = DateAdd("n", 58, Now()) />
				<cfset sms = model("sms").new() />
				<cfset sms.sms_to = mobile />
				<cfset sms.sms_text = "Token dla loginu " & myuser.login & ": " & token & ". Token traci waznosc " & DateFormat(v, "dd.mm.yyyy") & " o godz. " & TimeFormat(v, "HH:mm:ss") />
				<cfset sms.sms_created = Now() />
				<cfset sms.save(callbacks=false) />

				<!---
					Wysłanie SMSa
				--->
				<cfhttp
					url="http://api.smsapi.pl/sms.do?username=dopiet&password=e10adc3949ba59abbe56e057f20f883e&to=#mobile#&from=INTRANET&eco=0&message=#sms.sms_text#"
					resolveurl="Yes"
					throwOnError="No"
					result="status"
					timeout="60" >

				</cfhttp>

					<cfmail
						to="admin@monkey.xyz"
						from="SMS - Monkey<intranet@monkey.xyz>"
						replyto="#get('loc').intranet.email#"
						subject="SMS"
						type="html">

						<cfdump var="#status#" />
						<cfdump var="#sms#" />

					</cfmail>

				<!---
					Parsuje odpowiedź z serwera
				--->
				<cfset response = ListToArray(status.Filecontent, ':', false, true) />

				<!---
					Aktualizuje informacje o smsie o status z serwera
				--->
				<cfif ArrayLen(response) eq 3>

					<cfset mysms = model("sms").findByKey(sms.id) />
					<cfset mysms.sms_status = response[1] />
					<cfset mysms.sms_id = response[2] />
					<cfset mysms.sms_points = response[3] />
					<cfset mysms.save(callbacks=false) />

				<!---
					Status błędu ma tylko 2 pola
				--->
				<cfelseif ArrayLen(response) EQ 2>

					<cfset mysms = model("sms").findByKey(sms.id) />
					<cfset mysms.sms_status = response[1] />
					<cfset mysms.sms_id = response[2] />
					<cfset mysms.save(callbacks=false) />

					<cfmail
						to="#get('loc').intranet.email#"
						from="SMS - Monkey<intranet@monkey.xyz>"
						replyto="#get('loc').intranet.email#"
						subject="Błąd przy próbie wysłania SMS"
						type="html">

						<cfdump var="#status#" />

					</cfmail>

					<cfset redirectTo(controller="Users",action="sms",error="System nie może wysłać SMS z Tokenem. Proszę spróbować ponownie.") />

				<cfelse>

					<cfset mysms = model("sms").findByKey(sms.id) />
					<cfset mysms.sms_status =  status.Filecontent/>
					<cfset mysms.save(callbacks=false) />

				</cfif>

				<!---
					Aktualizuje tabele z użytkownikiem.
					Ustawiam ważność TOKENU na 7 minut.
				--->
				<cfset myuser = model("user").FindOne(where="login='#params.login#'") />
				<cfset myuser.smstoken = token /> <!--- Token przesłany smsem --->
				<cfset myuser.smsvalidto = DateAdd("h", 1, Now()) />
				<cfset myuser.save(callbacks=false) />

				<cfset redirectTo(controller="Users",action="token",message="SMS z TOKENem został wysłany.") />

			<cfelse>

				<cfset redirectTo(controller="Users",action="token",message="Proszę wpisać TOKEN wysłany SMSem.") />

			</cfif>

		</cfif>

	</cffunction>


	<cffunction
		name="token"
		hint="Autoryzacja przez sms"
		description="Metoda sprawdza, czy token przesłany przez SMS zgadza się
				z tym, w bazie danych. Jeżeli tak to zmieniana jest data
				ważności tokenu +60minut">

		<cfif IsDefined("session.smsvalidto") AND DateCompare(session.smsvalidto, Now()) EQ 1>
			<cfset redirectTo(controller="Users",action="logIn") />
		</cfif>

		<cfset usesLayout("/smslayout") />

		<cfif IsDefined("form.user_token_submit")>

			<cfset myuser = model("user").findOne(where="login='#form.login#' AND smstoken='#form.token#'") />

			<cfif not IsStruct(myuser) or structIsEmpty(myuser)>

				<cfset redirectTo(controller="Users",action="sms",error="Niepoprawna autoryzacja.") />

			<cfelse>

				<cfset session.smsauth = Now() />
				<cfset session.smsvalidto = myuser.smsvalidto />
				<cfset redirectTo(controller="Users",action="logIn") />

			</cfif>

		</cfif>

	</cffunction>

	<cffunction
		name="loginHistory"
		output="false" >

		<cfset myusers = model("user").getUserHistory() />

	</cffunction>

	<!---
		21.02.2013
		Metoda szukająca użytkowników w bazie.
		Dane są zwracane w formacie JSON aby można je było przeparsować przez
		JS i wygenerować odpowiedni widok.
	--->
	<cffunction
		name="search"
		hint="Metoda wyszukująca użytkownika w bazie i zwracające wszystkie informacje o nim">

		<cfset my_users = model("user").search(
			search		=		params.search) />

		<cfset my_users = model("user").QueryToStruct(Query=my_users) />

	</cffunction>

	<cffunction
		name="getSubstitutionsWidget"
		hint="Pobranie zastępstw w firmie"
		description="Zapytanie pobiera listę zastępstw w firmie i generuje
			odpowiedni widok">

		<!---
			10.04.2013
			Metoda tworząca widget z zastępstwami.
		--->
		<cfset qUSubstitutions = model("triggerHolidayProposal").getUserHolidays() />

		<cfset renderWith(data="qUSubstitutions",layout=false) />

	</cffunction>
	
	<cffunction
		name="getUsers"
		hint="Wyszukiwanie użytkowników"
		description="Wyszukiwanie wszystkich uzytkowników w systemie. Nie 
				są brani pod uwagę nieaktywni uzytkownicy. Zapytanie można 
				zawęzić np tylko do pracowników centrali">
		
		<!--- Ustawiam domyślne kryteria wyszukiwania. --->
		<cfparam 
			name="centrala"
			type="numeric"
			default="1" />
			
		<cfparam
			name="menadzer"
			type="numeric"
			default="0" />
			
		<cfparam
			name="dyrektorzy"
			type="numeric"
			default="0" />
		
		<cfparam
			name="partner_ds_ekspansji"
			type="numeric"
			default="0" />
		
		<cfparam
			name="partner_ds_sprzedazy"
			type="numeric"
			default="0" />
			
		<cfparam
			name="partner_prowadzacy_sklep"
			type="numeric"
			default="0" />
			
		<!--- Sprawdzam, czy przesłano parametry wyszukiwania --->
		<cfif IsDefined("params.centrala")>
			<cfset centrala = params.centrala />
		</cfif>
		
		<cfif IsDefined("params.dyrektorzy")>
			<cfset dyrektorzy = params.dyrektorzy />
		</cfif>
		
		<cfif IsDefined("params.menadzer")>
			<cfset menadzer = params.menadzer />
		</cfif>
		
		<cfif IsDefined("params.partner_ds_sprzedazy")>
			<cfset partner_ds_sprzedazy = params.partner_ds_sprzedazy />
		</cfif>
		
		<cfif IsDefined("params.partner_ds_ekspansji")>
			<cfset partner_ds_ekspansji = params.partner_ds_ekspansji />
		</cfif>
		
		<cfif IsDefined("params.partner_prowadzacy_sklep")>
			<cfset partner_prowadzacy_sklep = params.partner_prowadzacy_sklep />
		</cfif>
		
		<!--- Wyszukuje użytkowników o określonych parametrach --->
		<cfset json = model("user").find(
			structure = true,
			search = params.search) />
			
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
	<!---
	<cffunction name="tmpTest" output="false" access="public" hint="">
		<cfargument name="id" type="numeric" required="true" />
		<cfset var formularze = "" />
		<cfquery name="formularze" datasource="#get('loc').datasource.intranet#">
			select * from store_form_instances 
			where store_id = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		<cfif formularze.RecordCount NEQ 0>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>
	
	<cffunction name="test" hint="" output="false">
		<cfsetting requesttimeout="540" />
		
		<cfset var noweSklepy = "" />
		<cfquery name="noweSklepy" datasource="#get('loc').datasource.intranet#">
			select id, projekt from store_stores
			where projekt not in ('B12011', 'C12011', 'B12016', 'C12016', 'B12017', 'C12017', 'B12018', 'C12018', 'B12019', 'C12019', 'B12020', 'C12020', 'B12021', 'C12021', 'B12024', 'C12024', 'B12030', 'C12030', 'B12031', 'C12031', 'B12032', 'C12032', 'B12034', 'C12034', 'B12038', 'C12038') and Year(storecreated) = 2014 and Day(storecreated) = 27 and Month(storecreated) = 03;	
		</cfquery>
		
		<cfloop query="noweSklepy">
			<cfset var starySklepC = "" />
			<cfset var numerStaregoSklepu = Right(noweSklepy.projekt, Len(noweSklepy.projekt)-1) />
			
			<cfquery name="starySklepC" datasource="#get('loc').datasource.intranet#">
				select id from store_stores 
				where projekt = <cfqueryparam value="C#numerStaregoSklepu#" cfsqltype="cf_sql_varchar" />
				and not (Year(storecreated) = 2014 and Day(storecreated) = 27 and Month(storecreated) = 03);
			</cfquery> 
			
			<!---<cfdump var="#starySklepC#" />
			<cfloop query="starySklepC">
				<cfif tmpTest(starySklepC.id) is true>
					<cfdump var="#starySklepC.id#" />
				</cfif>
			</cfloop>--->
			<cfloop query="starySklepC">
				<cfif tmpTest(starySklepC.id) is true>
					<!---<cfdump var="#starySklepC.id#" />
					<cfdump var="#noweSklepy.id#" />--->
					<cfset var a = model("store_store").copyStoreForms(starySklepC.id, noweSklepy.id) />
				</cfif>
			</cfloop>
			
			
		</cfloop>
		
		<cfdump var="#noweSklepy#" />
		<cfabort />
		
		<!---<cfset var a = model("store_store").synchronizujUzytkownikow() />--->
		<!---<cfset var a = model("store_store").synchronizujAwaryjnie() />--->
		<cfset renderNothing() />
	</cffunction>
	--->
	
	<cffunction name="test" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		
		<cfset var dokumentyGateway = createObject("component", "cfc.models.DokumentyGateway").init(get('loc').datasource.intranet) />
		<cfset var dokumenty = dokumentyGateway.pobierzNieprzeniesioneDokumenty() />
		<cfset var indeks = 0 />
		<cfset var wszystkie = 0 />
		<cfloop query="dokumenty">
			<cfif not directoryExists( ExpandPath( "faktury/#DateFormat(dokumenty.documentcreated, 'yyyy')#/#DateFormat(dokumenty.documentcreated, 'mm')#" ) )>
				<cfset directoryCreate( expandPath( "faktury/#DateFormat(dokumenty.documentcreated, 'yyyy')#/#DateFormat(dokumenty.documentcreated, 'mm')#" ) ) />
			</cfif>
			
			<cfset var nowaNazwaPliku = replace(dokumenty.documentname, "/", "_", "ALL") />
			
			<cfif fileExists( ExpandPath( 'files/#document_file_name#' ) )>
				<cffile action="move" destination="#ExpandPath( 'faktury/#DateFormat(dokumenty.documentcreated, 'yyyy')#/#DateFormat(dokumenty.documentcreated, 'mm')#/#nowaNazwaPliku#.pdf' )#" source="#ExpandPath( 'files/#document_file_name#' )#" />
				
				<cfset var aktualizujDokument = dokumentyGateway.przeniesDokument(idDokumentu = dokumenty.id, nazwaPliku = nowaNazwaPliku & ".pdf", katalog = "faktury/#DateFormat(dokumenty.documentcreated, 'yyyy')#/#DateFormat(dokumenty.documentcreated, 'mm')#") />
				<!---
					<cfoutput>#aktualizujDokument.message#</cfoutput>
				--->
				<cfset indeks++ />
			</cfif>
			<cfset wszystkie++ />
		</cfloop>
		
		<cfoutput><br />Wszystkie: #wszystkie#. Przeniesione: #indeks#<br /></cfoutput>
		<cfabort />
	</cffunction>
	
	<cffunction name="userNotice" hint="Metoda obsługuje powiadomienia dla użytkowników">
		
		<cfset json = false />
		<cfif StructKeyExists(session, "userid")>
			<cfset sessionuserid = session.userid />
				
			<cfif StructKeyexists(params, "mod")>
			
				<cfswitch expression="#params.mod#">
					
					<cfcase value="check">
						<!--- sprawdza dostepne nowe powiadomienia --->
						<cfset n_new = model("users_notice").findAll(where="userid=#sessionuserid# AND status=1") />
						<cfset n_unread = model("users_notice").findAll(where="userid=#sessionuserid# AND (status=1 OR status=2)") />
						
						<cfset json = StructNew() />
	 					<cfset StructInsert(json, "unew", n_new.RecordCount) />
						<cfset StructInsert(json, "ureaded", n_unread.RecordCount) />
						<!---<cfset json = notice.RecordCount />--->
						
					</cfcase>
					
					<cfcase value="get">
						<!--- pobiera liste ostatnich powiadomien --->
						<cfset notice = model("users_notice").findAll(where="userid=#sessionuserid# AND status<>4", order="readed, date DESC", maxRows=10) />
						<cfset json = QueryToStruct(Query=notice) />
						
						<cfset notice = model("users_notice").updateAll(new=0, status=2, where="userid=#sessionuserid# AND (new=1 OR status=1)") />
						
						<cfset notice = model("users_notice").deleteAll(where="userid=#sessionuserid# AND (date<'#DateFormat(Now(), "yyyy-mm")#' OR status=4)") />
					</cfcase>
					
					<cfcase value="uncheck">
						<!--- odznacza pobrane nowe powiadomienia --->
						<cfset notice = model("users_notice").updateAll(new=0, status=2, where="userid=#sessionuserid# AND (new=1 OR status=1)") />
						<cfset json = 'OK' />
						
					</cfcase>
					
					<cfcase value="readOne">
						<!--- odczytuje pojedyncze powiadomienie --->
						<cfif StructKeyExists(params, "key")>
							<cfset notice = model("users_notice").findByKey(params.key) />
							<cfif IsObject(notice)>
								<cfset notice.update(readed=1, status=3, callbacks=false) />
							</cfif>
						</cfif>
						<cfset json = 'OK' />
						
					</cfcase>
					
					<cfcase value="remove">
						<!--- usuwa pojedyncze powiadomienie --->
						<cfif StructKeyExists(params, "key")>
							<cfset notice = model("users_notice").findByKey(params.key) />							
							<cfif IsObject(notice)>
								<cfset notice.update(status=4) />
								<!---<cfset notice.delete() />--->
							</cfif>
						</cfif>
						<cfset json = 'OK' />
						
					</cfcase>
					
					<cfcase value="readAll">
						<!--- automatycznie odczytuje wszystkie powiadomienia --->
						<cfset notice = model("users_notice").updateAll(readed=1, status=3, where="userid=#sessionuserid# AND (readed=0 OR status=2)") />
						<cfset json = 'OK' />
						
					</cfcase>
					
					<cfcase value="removeAll">
						<!--- usuwa wszystkie powiadomienia --->
						<cfset notice = model("users_notice").deleteAll(where="userid=#sessionuserid#") />
						<cfset json = 'OK' />
						
					</cfcase>
					
				</cfswitch>
			
			</cfif>
			
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	
	</cffunction>
	
	<cffunction 
		name="find">
			
		<cfif StructKeyExists(params, "key") and params.key neq ''>
			
			<cfset user = model("User").findByKey(params.key) />
		
		<cfelseif StructKeyExists(params, "logo") and params.logo neq ''>
			
			<cfset user = model("User").findOne(where="logo=#params.logo#") />
		
		</cfif>
		
		<cfset json = user />
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
	<cffunction 
		name="getUserByGroup">
		<cfset json = '' />
			
		<cfif StructKeyExists(params, "group") and StructKeyExists(params, "search")>
			
			<cfset users = model("User").getUserByGroup(
				group = params.group,
				search = params.search
			)/>
			
			<cfset json = users />
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>

</cfcomponent>