<cfcomponent
	extends="mc">

	<cffunction
		name="init">

		<cfset super.init() />

	</cffunction>

	<cffunction
		name="index"
		hint="Wyświetlanie wszystkich komunikatów w systemie">

		<!---
			30.10.2012
			Dodaje linijkę zapisującą stronę, na której jestem do generowania breadcrumbs.
		--->

		<cfset messages = model("userMessage").findAll(where="userid=#session.userid# AND usermessageactive=1",order="messagecreated DESC",include="message(user)") />

		<cfif IsAjax()>

			<cfset renderWith(data="messages",layout=false) />

		</cfif>

	</cffunction>

	<cffunction
		name="add"
		hint="Formularz dodawania nowego komunikatu"
		description="Formularz dodawania nowego komunikatu. Komunikat może być konfigurowany: data wyświetlania, grupa odbiorców.">

		<cfset message = model("message").new() />
		<cfset messagepriorities = model("messagePriority").findAll(select="id,prioritylabel") />
		<cfset groups = model("group").findAll(select="id,groupname") />

		<cfif IsAjax()>

			<cfset renderWith(data="message,groups,messagepriorities",layout=false) />

		</cfif>

	</cffunction>

	<cffunction
		name="actionAdd"
		hint="Zapisanie komunikatu w bazie danych.">

		<cfset message = model("message").create(params.message) />
		<cfset message.userid = session.userid />
		<cfset message.messagecreated = Now() />
		<cfset message.save(callbacks=false) />

		<!---
			3.04.2013
			Nie ma już grup odbiorców.
			Teraz komunikat jest przypisywany do każdego użytkownika indywidualnie.
			Wyjątkiem są komunikaty prywatne wysyłane bezpośrednio do usera.
		--->

		<cfset redirectTo(controller="Messages",action="index",key=session.userid) />

	</cffunction>

	<cffunction
		name="view"
		hint="Pobieranie pełnej treści komunikatu"
		description="Metoda wyświetlająca pełną treść komunikatu.">

		<cfset message = model("message").findOne(where="id=#params.key#") />

		<!--- Struktura do aktualizacji --->
		<cfset usermessagestruct = {} />
		<cfset usermessagestruct.usermessagereaded = 1 />
		<cfset usermessage = model("userMessage").updateOne(where="userid=#session.userid# AND messageid=#params.key#",properties=usermessagestruct) />

		<cfif IsAjax()>

			<cfset renderWith(data="message",layout=false) />

		</cfif>

	</cffunction>

	<cffunction
		name="delete"
		hint="Usunięcie komunikatów."
		description="Usunięcie komunikatów. Komunikat nie jest faktycznie usuwany. Zmieniana jest flaga messagedeleted na 1.">

		<cftry>

			<cfset messageids = ListToArray(params.messageid, ":", false, true) />

			<!--- Przechodzę przez wszystkie identyfikatory komunikatów i aktualizuje ich status --->
			<cfloop array=#messageids# index="i">
				<cfset message = model("userMessage").findByKey(i) />
				<cfset message.usermessageactive = 0 />
				<cfset message.usermessagedeleted = 1 />
				<cfset message.save(callbacks=false) />
			</cfloop>

			<!--- Jeśli już zaktualizowałem wszystkie komunikaty, renderuje stronę z komunikatami --->
			<cfset redirectTo(controller="Users",action="getUserProfile",key=session.userid) />

		<cfcatch type="any">

			<cfset error = cfcatch />
			<cfset renderWith(data="error",layout=false,template="/apperror") />

		</cfcatch>

		</cftry>

	</cffunction>

	<!---
	23.07.2012
	Dodawanie komunikatu dla pojedyńczego użytkownika.
	Sposób dodawania tego komunikatu jest odrobinę inny niż komunikatów dla użytkowników. Przy zapisywaniu pojedynczej
	wiadomości w tabeli usermessages dodaje tylko jedno powiązanie.
	--->
	<cffunction
		name="addUserMessage"
		hint="Formularz dodawania komunikatu dla pojedyńczego użytkownika."
		description="Formularz dodawania komunikatu dla pojedyńczego użytkownika.">

		<cfset message = model("message").new() />
		<cfset messagepriorities = model("messagePriority").findAll(select="id,prioritylabel") />
		<cfset user = model("user").findByKey(params.key) />
		<cfset renderWith(data="message,messagepriorities,user",layout=false) />

	</cffunction>

	<cffunction
		name="actionAddUserMessage"
		hint="Zapisanie komunikaty dla użytkownika"
		description="Metoda zapisująca prywatny komunikat dla użytkownika">

		<cftry>

			<!---
			Dodaje wymagane parametry dla wiadomości.
			Datę ważności wiadomości ustawiam na bardzo długą.
			--->
			<cfset params.message.messagestartdate = Now() />
			<cfset params.message.messagestopdate = DateAdd("yyyy", 10, Now()) />
			<cfset params.message.userid = session.userid />
			<cfset params.message.messagecreated = Now() />
			<cfset message = model("message").create(params.message) /> <!--- Zapisuje nowy komunikat --->

			<!---
			Zapisuje wiadomość w tablicy usermessages.
			--->
			<cfset usermessage = model("userMessage").new() />
			<cfset usermessage.userid = params.createdforuserid /> <!--- Zapisuje dla kogo ma wiadomość --->
			<cfset usermessage.messageid = message.id />
			<cfset usermessage.usermessagedeleted = 0 />
			<cfset usermessage.usermessageactive = 1 />
			<cfset usermessage.createdbyuserid = session.userid />
			<cfset usermessage.save(callbacks=false) />

			<cfset redirectTo(controller="Users",action="view",key=params.createdforuserid) />

		<cfcatch type="any">

			<cfset error = cfcatch.message />
			<cfset renderWith(data=error,layout=false,template="/apperror")/>


		</cfcatch>

		</cftry>

	</cffunction>

</cfcomponent>