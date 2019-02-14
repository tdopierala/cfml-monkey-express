
<cfoutput>
	<h1>
		<cfif StructKeyExists(session, "user") AND StructKeyExists(session, "userid")>

			<!---
				Sprawdzam jako kto jestem zalogowany i generuje odpowiednie linki.
			--->
			<cfif StructKeyExists(session.user, "isstore") and
				session.user.isstore is 1>

				#linkTo(
					text=imageTag("logo.png"),
					controller="Store_stores",
					action="view",
					key=session.userid,
					title="Twój profil",
					class="monkey_intranet_logo")#

			<cfelseif StructKeyExists(session.user, "ispartner") and
				session.user.ispartner is 1>

				#linkTo(
					text=imageTag("logo.png"),
					controller="Partners",
					action="view",
					key=session.userid,
					title="Twój profil",
					class="monkey_intranet_logo")#

			<cfelse>

				#linkTo(
					text=imageTag("logo.png"),
					controller="users",
					action="view",
					key=session.userid,
					title="Twój profil",
					class="monkey_intranet_logo")#

			</cfif>

		<cfelse>

			#linkTo(
				text=imageTag("logo.png"),
				route="home",
				title="Strona główna Monkey Intranet",
				class="monkey_intranet_logo")#

		</cfif>
	</h1>

	<ul class="monkey_top_nav">
		<!---
		<li>
			#linkTo(
				text="zgłoś błąd w systemie",
				controller="Tickets",
				action="add")#
		</li>
		--->
		<!---
		Jeśli jestem zalogowany to pokazuje opcje wylogowania.
		Jeśli jestem niezalogowany to pokazuje opcje zalogowania.
		--->
		<cfif not StructKeyExists(session, "user") AND not StructKeyExists(session, "userid")>
			<li>
				#linkTo(
					text="zaloguj",
					controller="Users",
					action="logIn")#
			</li>
		<cfelse>
			<li>
				#linkTo(
					text="wyloguj",
					controller="Users",
					action="logOut")#
			</li>
			<li>
				<!---
					Zakładam, że istnieje zmienna user i userid w sesji.

					Sprawdzam jako kto jestem zalogowany i generuje odpowiednie linki do profilu.
					Zalogowany jako ajent.
				--->
				<cfif StructKeyExists(session.user, "isstore") and session.user.isstore eq 1>

					#linkTo(
						text="mój profil",
						controller="Store_stores",
						action="view",
						key=session.userid,
						title="Zobacz swój profil")#

				<!---
					Zalogowany jako partner.
				--->
				<cfelseif StructKeyExists(session.user, "ispartner") and session.user.ispartner is 1>

					#linkTo(
						text="mój profil",
						controller="Partners",
						action="view",
						key=session.userid,
						title="Zobacz swój profil")#

				<!---
					Zalogowany jako zwykły pracownik
 				--->
				<cfelse>

					#linkTo(
						text="mój profil",
						controller="Users",
						action="view",
						key=session.userid,
						title="Zobacz swój profil")#

				</cfif> <!--- Koniec generowania linku "mój profil" --->
			</li>

			<!---
				Aby wygenerować link do panelu administracyjnego,
				sprawdzam czy jestem zalogowany jako root.

				Sprawdzanie grup odbywa się wg nowych grup użytkownika.
			--->
			<cfinvoke
				component="controllers.Tree_groupusers"
				method="checkUserTreeGroup"
				returnvariable="privRoot" >

				<cfinvokeargument
					name="groupname"
					value="root" />

			</cfinvoke>

			<cfif privRoot is not false>

			<li>
				#linkTo(
					text="panel administracyjny",
					controller="Admins",
					action="index",
					title="Panel administracyjny")#
			</li>
			
			<li>
				<a href="index.cfm?controller=stats&action=cfstat" title="Statystyki">Statystyki</a>
			</li>

			</cfif>
		
		</cfif>
		<li>
			#linkTo(
				text="mapa serwisu",
				controller="Sitemaps",
				action="index")#
		</li>
	</ul>

	<cfif StructKeyExists(session, "user") AND StructKeyExists(session, "userid")>

	<!---
		Jeżeli jestem zalogowany jako ajent to mogę wyszukiwać tylko po instrukcjach
	--->
	#startFormTag(controller="Search",action="find")#
		<ol class="monkeySearch">
			<li>
				#textFieldTag(
					name="search",
					class="input")#
			</li>
			<li>
				#submitTag(value="SZUKAJ",class="formButtonSearch")#
			</li>
		</ol>

		<ol class="monkey_advanced_search">
			<!---
			 	Jeżeli nie jestem ajentem to widzę opcje wyszukiwania zaawansowanego.
			--->
			<cfif session.user.isstore eq 0>
			<li>
				#checkBoxTag(
					name="searchdocuments",
					label="dokumenty",
					labelPlacement="before",
					checked=true)#
			</li>
			</cfif>

			<!---
				Jeżeli nie jestem ajentem to widzę opcje wyszukiwania zaawansowanego.
			--->
			<cfif session.user.isstore eq 0>
			<li>
				#checkBoxTag(
					name="searchusers",
					label="użytkownicy",
					labelPlacement="before")#
			</li>
			</cfif>

			<li>
				#checkBoxTag(
					name="searchinstructions",
					label="instrukcje",
					labelPlacement="before")#
			</li>
		</ol>
	#endFormTag()#

	</cfif>

</cfoutput>