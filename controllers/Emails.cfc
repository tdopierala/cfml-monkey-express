<cfcomponent extends="Controller">

	<cffunction name="init">
		<cfset super.init()>
	</cffunction>

	<cffunction name="test" hint="Wysłanie testowej wiadomości mailowej">

		<cfmail
			to="admin@monkey"
			cc="intranet@monkey"
			from="Monkey <intranet@monkey>"
			replyto="intranet@monkey"
			subject="form.subject"
			<!---server="poczta.monkey"
			username="#get('loc').ldap.user#"
			password="#get('loc').ldap.password#"--->
			>
                This message was sent by an automatic mailer built with cfmail:
                = = = = = = = = = = = = = = = = = = = = = = = = = = =
                form.body
        </cfmail>

	</cffunction>

	<!---
	sendWorkflowReminder
	---------------------------------------------------------------------------------------------------------------
	Wysyłanie maila do użytkowników z informacją o dokumentach w obiegu.
	Metoda przechodzi prze całą tabelę workflowtosendemails i zlicza ile jest dokumentów przypisanych do każdego użytkownika.
	W wiadomościu jest informacja o ilości przypisanych faktur oraz link do zalogowania się.

	--->
	<cffunction name="sendWorkflowReminder" hint="Wysyłanie maila do użytkowników z informacją o dokumentach w obiegu.">

		<!--- Pobieram informację o użytkowniku i ilości dokumentów mu przypisanych --->
		<cfset emails = model("workflowToSendMail").getUserWorkflow() />
		<cfset chairmannextreminder = model("workflowSetting").findOne(where="workflowsettingname='chairmannextreminder'") />

		<cfset renderWith(data="emails,chairmannextreminder",layout=false) />

	</cffunction>

	<cffunction
		name="sendHolidayProposalReminder"
		hint="Wysyłanie powiadomienia o wnioskach do zaakceptowania">

		<cfset emails = model("viewHolidayProposalReminder").findAll() />

	</cffunction>

	<cffunction
		name="setUpChairmanDuration"
		hint="Aktualizacja daty wysyłki wiadomości dla p Prezesa"
		description="Metoda wywołuje się cyklicznie o godzinie 16. Aktualizuje datę wysyłki kolejnych przypomnień na koniec dnia.">

		<cfset chairmannextreminder = model("workflowSetting").findOne(where="workflowsettingname='chairmannextreminder'") />
		<cfset chairmannextreminder.workflowsettingvalue = DateAdd('d', 2, Now()) />
		<cfset chairmannextreminder.save(callbacks=false) />

	</cffunction>

	<cffunction
		name="sendPlaceReminder"
		hint="Wysłanie powiadomienia o zmianie statusu obiegu nieruchomości."
		description="Wysyłanie powiadomienia o zmianie statusu obiegu nierchomości. Wiadomość wysyłana jest 1 raz po zmianie statusu na decyzja pozytywna lub decyzja negatywna.">

	</cffunction>
	
	<!---<cffunction 
		name="sendIndexReminder"
		hint="Wysyłanie powiadomienia o indeksach"
		description="Wysyłanie zbiorczego powiadomienia o zmianach w indeksach raz na dobe">
		
		<cfset datetime = DateFormat(DateAdd('d', -1, Now()),'yyyy-mm-dd') />
		
		<cfset statuses = model("Product_step").findAll(
			select="userid, indexid, step, comment"
			,where="date > '#datetime#' AND notice_sent=0"
			,order="step ASC"
		)/>

		<cfset emails = ArrayNew(2) />
		<cfset users = ArrayNew(1) />
		
		<cfset _users = model("Tree_groupuser").getGroupUsersFull(68) />
		<cfloop query="_users">
			
			<cfset users[_users.userid] = StructNew() />
			<cfset StructInsert(users[_users.userid], 'id', _users.userid, true) />
			<cfset StructInsert(users[_users.userid], 'email', _users.mail, true) />
			<cfset StructInsert(users[_users.userid], 'name', _users.givenname & ' ' & _users.sn, true) />
			
			<cfloop query="statuses">
				
				<cfset _status = StructNew() />
				<cfset StructInsert(_status, 'userid', statuses.userid, true) />
				<cfset StructInsert(_status, 'indexid', statuses.indexid, true) />
				<cfset StructInsert(_status, 'step', statuses.step, true) />
				<cfset StructInsert(_status, 'comment', statuses.comment, true) />
				
				<cfif statuses.step eq 1>
					<cfset StructInsert(_status, 'message', 'Nowy indeks #statuses.indexid# w zakładce Nowe indeksy.', true) />
					<cfset ArrayAppend(emails[_users.userid], _status) />
				</cfif>
			</cfloop>
			
		</cfloop>
		
		<cfset _users = model("Tree_groupuser").getGroupUsersFull(69) />
		<cfloop query="_users">
			
			<cfset users[_users.userid] = StructNew() />
			<cfset StructInsert(users[_users.userid], 'id', _users.userid, true) />
			<cfset StructInsert(users[_users.userid], 'email', _users.mail, true) />
			<cfset StructInsert(users[_users.userid], 'name', _users.givenname & ' ' & _users.sn, true) />
			
			<cfloop query="statuses">
				
				<cfset _status = StructNew() />
				<cfset StructInsert(_status, 'userid', statuses.userid, true) />
				<cfset StructInsert(_status, 'indexid', statuses.indexid, true) />
				<cfset StructInsert(_status, 'step', statuses.step, true) />
				<cfset StructInsert(_status, 'comment', statuses.comment, true) />
				
				<cfif statuses.step eq 2>
					<cfset StructInsert(_status, 'message', 'Zmieniono status indeksu o numerze #statuses.indexid# na "zweryfikowany"', true) />
					<cfset ArrayAppend(emails[_users.userid], _status) />
				</cfif>
				
				<cfif statuses.step eq 3>
					<cfset StructInsert(_status, 'message', 'Zmieniono status indeksu o numerze #statuses.indexid# na "odrzucony na etapie weryfikacji"', true) />
					<cfset ArrayAppend(emails[_users.userid], _status) />
				</cfif>
			</cfloop>
			
		</cfloop>
		
		<cfset _users = model("Tree_groupuser").getGroupUsersFull(70) />
		<cfloop query="_users">
			
			<cfset users[_users.userid] = StructNew() />
			<cfset StructInsert(users[_users.userid], 'id', _users.userid, true) />
			<cfset StructInsert(users[_users.userid], 'email', _users.mail, true) />
			<cfset StructInsert(users[_users.userid], 'name', _users.givenname & ' ' & _users.sn, true) />
			
			<cfloop query="statuses">
				
				<cfset _status = StructNew() />
				<cfset StructInsert(_status, 'userid', statuses.userid, true) />
				<cfset StructInsert(_status, 'indexid', statuses.indexid, true) />
				<cfset StructInsert(_status, 'step', statuses.step, true) />
				<cfset StructInsert(_status, 'comment', statuses.comment, true) />
				
				<cfif statuses.step eq 4>
					<cfset StructInsert(_status, 'message', 'Zmieniono status indeksu o numerze #statuses.indexid# na "zaakceptowany"', true) />
					<cfset ArrayAppend(emails[_users.userid], _status) />
				</cfif>
				
				<cfif statuses.step eq 5>
					<cfset StructInsert(_status, 'message', 'Zmieniono status indeksu o numerze #statuses.indexid# na "brak akceptacji"', true) />
					<cfset ArrayAppend(emails[_users.userid], _status) />
				</cfif>
			</cfloop>
			
		</cfloop>
		
	</cffunction>--->
	
	<cffunction
		name="sendEmail"
		hint="Metoda dodająca email do kolejki"
		description="">
		
		
	</cffunction>

</cfcomponent>