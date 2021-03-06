<cfcomponent extends="Controller">

	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init()>
		<cfset provides("html,json,xml,pdf")>
	</cffunction>

	<!---
	index
	---------------------------------------------------------------------------------------------------------------
	Lista wszystkich dokumentów w obiegu. Dokumenty są pogrupowane po etapie w jakim sę znajdują.
	Docelowo do dokumentu mają mieć dostęp użytkownicy z Controllingu i Księgowości.

	21.05.2012
	Zmieniony został widok prezentujący dokumenty w obiegu. Teraz nie ma tabelek z ExtJS.

	3.01.2013
	Widok z dokumentami w obiegu nie jest już generowany Ajaxowo. Dodałem filtr oraz paginację. W
	zamyśle ma to poprawić wydajność.
	--->
	<cffunction
		name="index"
		hint="Wyświetlenie wszystkich zdefiniowanych przepływów dokumentów.">

		<cfparam
			name="year"
			default="#Year(Now())#" />

		<cfparam
			name="month"
			default="#Month(Now())#" />

		<cfparam
			name="page"
			default="1" />

		<cfparam
			name="elements"
			default="50" />

		<cfparam
			name="step"
			default="0" />

		<cfparam
			name="type"
			default="0" />

		<!---
			Sprawdzam, czy przesłano parametry filtra. Jak tak to zapisuje je.
		--->
		<cfif structKeyExists(params, "workflow_filter_year")>
			<cfset year = params.workflow_filter_year />
		</cfif>

		<cfif structKeyExists(params, "workflow_filter_month")>
			<cfset month = params.workflow_filter_month />
		</cfif>

		<cfif structKeyExists(params, "page")>
			<cfset page = params.page />
		</cfif>

		<cfif structKeyExists(params, "elements")>
			<cfset elements = params.elements />
		</cfif>

		<cfif structKeyExists(params, "type")>
			<cfset type = params.type />
		</cfif>

		<!---
			Teraz zapisuje ustawienia w sesji.
		--->
		<cfset session.workflow_filter = {
			year		=	year,
			month		=	month,
			page		=	page,
			elements	=	elements,
			type		=	type} />

		<!---
			Pobieram dokumenty
		--->
		<cfset myworkflow = model("workflow").getWorkflow(
			year		=	year,
			month		=	month,
			page		=	page,
			elements	=	elements,
			step		=	0) />

		<cfset myworkflow_count = model("workflow").getWorkflowCount(
			year		=	year,
			month		=	month,
			step		=	0) />

		<!---
			Pobieram dane do filtrowania.
		--->
		<cfset years	=	model("workflow").getYears() />
		<cfset months	=	model("workflow").getMonths() />
		<cfset types	=	model("type").getUserTypes(userid=session.userid) />

	</cffunction>
	
	<!---<cffunction
		name="indexAll"
		hint="Lista wszystkich dokumentów, które są w obiegu."
		description="Widok jest przeznaczony głównie dla dep finansowego aby
				mogli wyszukiwać faktur.">
		
		
		
	</cffunction>--->

	<!---
	Metoda zwracająca listę dokumentów w obiegu w formacie json.

	21.05.2012
	Metoda została usunięta.
	--->
	<!---
<cffunction name="jsonIndex" hint="Lista obiegu dokumentów w formacie JSON">

		<cfset workflows = model('workflow').getWorkflowsListJson()>
		<cfset renderWith(data=workflows,hideDebugInformation=true,layout=false)>

	</cffunction>
--->

	<!---
	step
	---------------------------------------------------------------------------------------------------------------
	Krok obiegu dokumentów.
	Metoda prezentuje formularz. Dostęp do tej metody ma tylko użytkownik, któremu zostało przypisane zadanie.
	Do zabezpieczenia metody przesyłany jest token.

	1.02.2012
	Usunięto token. Zmodyfikowano sposób przeglądania dokumentów. Odpowiednie strony ładowane są Ajaxowo.
	Widok step jest głównym widokiem obiegu dokumentów. Są tutaj ładowane pliki js.

	--->
	<!---<cffunction name="step" hint=""></cffunction>--->

	<!---
	userStep
	---------------------------------------------------------------------------------------------------------------
	Widok użytkownika danego kroku obiegu dokumentu. Widok zwracany jest Ajax'owo.

	1.02.2012
	Pobierane są dane MPK i Projektów do wyboru.

	--->
	<!---<cffunction name="userStep" hint="Krok obiegu dokumentu dla zalogowanego użytkownika">

		<!---
		Wyszukuje krok obiegu dokumentu dla użytkownika.
		Wyszukiwanie jest po ID kroku i tokenie do niego przypisanym.
		--->

		<cftry>

			<cfset workflowstep = model("workflowStep").findAll(select="workflowstatusid,documentid,workflowid,workflowstepstatusname,next,prev,workflowstepstatusid,id,token,workflowstepnote,moveto,workflowstepdescriptionid",where="workflowid=#params.key# AND workflowstatusid=1 AND userid=#session.userid#",include="workflow,workflowStepStatus,document(documentInstance)")>

			<cfif workflowstep.RecordCount eq 0>

				<cfif IsAjax()>

					<cfset redirectTo(controller="Workflows",action="preview",key=params.key,layout=false) />

				<cfelse>

					<cfset redirectTo(controller="Workflows",action="preview",key=params.key) />

				</cfif>
	<!--- 				<cfthrow type="db" message="Nie masz uprawnień do tego etapu obiego dokumentu lub etap został zamknięty."> --->

			</cfif>


			<cfset workflowstepstatuses = model("workflowStatus").findAll(where="id <> #workflowstep.workflowstatusid#",select="id,workflowstatusname")>

			<!--- Pobieram listę MPKów z bazy Asseco, 13.03.2012 --->
			<cfset mpks = model("mpk").getMpks() />
			<cfset loc.tmpmpk = "[" /> <!--- Zmienna pomocnicza przechowująca tablicę podpowiedzi mpków --->
			<cfloop array=#mpks.rows# index="element"> <!--- Przechodzę przez wszystkie MPKi z bazy Asseco --->
				<cfset loc.tmpmpk &= "'#element.mpk# - #element.nazwa#'," />
			</cfloop>
			<cfset loc.tmpmpk &= "]" />
			<cfset mpkautocomplete = loc.tmpmpk /> <!--- Zapisuje dane w zmiennej i przekazuje ją do widoku --->

			<!--- Lista MPKów --->
			<!--- <cfset mpks = model("mpk").findAll(select="id,mpkname,mpknumber") /> --->

			<!--- Lista projektów z Asseco, 13.03.2012 --->
			<cfset projects = model("project").getProjects() />
			<cfset loc.tmpproject = "[" /> <!--- Zmienna pomocnicza przechowująca tablicę podpowiedzi projektów --->
			<cfloop array=#projects.rows# index="element">
				<cfset loc.tmpproject &= "'#element.projekt# - #element.nazwa#; #element.opis#; #element.miejscerealizacji#'," />
			</cfloop>
			<cfset loc.tmpproject &= "]" />
			<cfset projectsautocomplete = loc.tmpproject /> <!--- Zapisuje dane w zmiennej i przekazuje ją do widoku --->

			<!--- Lista projektów --->
			<!--- <cfset projects = model("project").findAll(select="id,projectname") /> --->

			<!---
			14.02.2012
			Usunąłem listę użytkowników, do których można przekazać dokument. Lista generowana jest Ajaxowo.
			--->
<!--- 			<cfset users = model("workflowStepStatusUser").findAll(where="workflowstepstatusid <= #workflowstep.next#",include="user")/> --->
			<!--- Lista użytkowników do których mogę przekazać dokument --->

			<cfset price = model("documentAttributeValue").findAll(where="attributeid=101 AND documentid=#workflowstep.documentid#",select="documentattributetextvalue") /> <!--- Kwota net to faktury --->

			<!--- Dane do tabelki z opisem faktury --->
			<cfset workflowstepdescription = model("workflowStepDescription").findAll(where="workflowid=#params.key#",include="project,mpk")/>

			<!--- Pobieram ID dokumentu z tabeli ze zdefiniowanymi obiegami dok, aby móc pobrać dane z tabeli documents --->
			<cfset documentid = model("workflow").findOne(where="id=#params.key#") />
			<cfset document = model("document").findOne(select="contractorid,id",where="id=#documentid.documentid#") />

			<!--- Lista atrybutów opisujących fakturę --->
			<cfset documentattributes = model("documentAttributeValue").findAll(select="documentid,attributename,documentattributetextvalue,attributeid",include="attribute,documentAttribute",where="documentid=#documentid.documentid# AND documentattributevisible=1")/>

			<!--- Lista opisów dokumentu z nazwą etapu --->
			<!---<cfset workflowstepnotes = model("workflowStep").findAll(where="workflowid=#params.key#",order="workflowstepcreated and AND workflowstepstatusid ASC",include="workflowStepStatus",select="workflowstepstatusname,workflowstepnote,workflowstepstatusid") />--->

			<cfset workflowstepdecreenote = model("workflowStep").findAll(select="workflowstepnote",where="(workflowid=#params.key# AND workflowstepstatusid=1 AND isdraft=0 AND workflowstepended is not null) OR (workflowid=#params.key# AND workflowstepended is null AND isdraft <> 0 AND workflowstepstatusid=1)",order="workflowstepcreated desc",maxRows=1) />

			<!--- Pobieranie Kontrahenta, który wystawił fakturę --->
			<cfset contractor = model("contractor").findOne(where="id=#document.contractorid#") />

			<cfset defaultinvoicenumber = model("documentAttributeValue").findOne(where="documentid=#document.id# AND attributeid=108") />

			<!---
			6.09.2012
			Pobieram listę typów dokumentów. Lista jest generowana na podstawie grup, do których należy użytkownik.
			--->
			<cfset types = model("type").getUserTypes(userid=session.userid) />

			<cfif IsAjax()>

				<cfset renderWith(data='workflowstep,workflowstepstatuses,users,workflowpaststeps,workflowstepdescription,documentattributes,contractor,mpkautocomplete,projectsautocomplete,defaultinvoicenumber,types',layout=false)>

			</cfif>

		<!--- Jeśli przechwyciłem wyjątek to generuje planszę informacyjną i wyświetlam komunikat --->
		<cfcatch type="any">

			<cfset error = cfcatch.message />
			<cfset renderWith(data=error,layout=false,template="/apperror")/>

		</cfcatch>

		</cftry>

	</cffunction>--->


	<!---
	actionStep
	---------------------------------------------------------------------------------------------------------------
	Zapisanie notatki użytkownika dla danego kroku obiegu dokumentów.
	Stworzenie nowego kroku dla dokumentu. Aktualizacja poprzedniego kroku i zmiana jego statusu.

	1.02.2012
	Jeśli dokument jest w opisie to tworzona jest tabelka mpk, projekt, netto.
	Kiedy istnieje definicja tabelki mpk, projekt, … w przesłanych danych to tworzę w bazie odpowiednie powiązanie
	i zapisuje dane.

	Kolejność nowego obiegu dokumentów na dzień 1.02.2012:
	- Sprawdzam czy są przesłane dane do tabelki mpk, projekt, nettp. Jeśli tak to tworzę wpis i dodaje dane.
	- Aktualizacja aktualnego kroku obiegu dokumentów
	- Zapisanie daty wprowadzenia opisu
	- Usunięcie powiadomienia z tabeli wiadomości do wysłania
	- Stworzenie nowego kroku obiegu dokumentów
	- Dodanie nowego wpisu do tabeli wiadomości do wysłania

	6.09.2012
	Dodałem typy dokumentu, które są widoczne tylko dla pierwszego etapu obiegu dokumentów. Typy są pobierane w zależności
	od grup do któryh należy zalogowany użytkownik

	24.04.2013
	Zmieniłem sposób akceptacji kroku obiegu dokumentów.
	--->
	<cffunction name="actionStep" hint="Zaakceptowanie kroku obiegu dokumentów i przesłanie go dalej.">
		<cfset wasAutomated = false />

		<!---
			Pobieram wszystkie definicje automatycznego obiegu dokumentów.
		--->
		<cfset myAutomators = model("workflow_automator").getAutomators() />

		<!---
			Przechodzę przez wszystkie definicje i uruchamiam maszynkę...
		--->
		<cfloop query="myAutomators">

			<!---
				Pobieram niezbędne informacje aby zbudować odpowiednie zapytanie
				do automatycznego obiegu dok.

				Wyciągam tabelę, z której mam sprawdzać warunki.
				Wyciągam warunki.
				Buduje odpowiednie zapytanie.
			--->
			<cfset myConditions = ListToArray(automator_conditions, ":", false) />
 			<cfset myWorkflowConditions = model("workflow_automator").checkConditions(
				workflowid = params.workflowid,
				conditionTable = automator_conditions_table,
				conditions = myConditions) />

			<cfset wsCheck = model("workflowStep").findByKey(params.workflowstepid) />

				<!---
					Jeżeli faktura spełnia warunki automatycznego
					obiegu to startuje...
				--->
				<cfif wasAutomated is false AND myWorkflowConditions.c NEQ 0 AND wsCheck.workflowstepstatusid EQ 1>

					<cfset w = model("workflow").updateByKey(key=params.workflowid,is_automated=1) />
					<cfset wasAutomated = true />
					<cfset currentTime = Now() />

					<!---
						Zamykam aktualny krok.
					--->
					<cfset ws = model("workflowStep").findByKey(params.workflowstepid) />
					<cfset ws.workflowstepended = currentTime />
					<cfset ws.workflowstatusid = 2 />

					<cfif StructKeyExists(params, "workflowstepnote")>
						<cfset ws.workflowstepnote = params.workflowstepnote />
					</cfif>

					<cfset ws.workflowsteptransfernote = params.workflowsteptransfernote & "(#params.workflow_edit_form_submit#)" />
					<cfset ws.save(callbacks=false) />
					<!---
						Aktualny krok został zamknięty. Teraz symuluje
						cały obieg dokumentu.
					--->

					<cfset myStepsDelay = ListToArray(automator_steps_delay, ":", false) />
					<cfset myStepsUser = ListToArray(automator_steps_user, ":", false) />

					<!---
						Przechodzę przez wszystkie etapy ze
						zdefiniowanymi użytkownikami i sumuluje obieg dokumentu.
					--->
					<cfloop array="#myStepsUser#" index="msu">

						<!---
							Parsuje każdy wiersz aby otrzymać etap i użytkownika.
							1: etap
							2: użytkownik
						--->
						<cfset stepUser = ListToArray(msu, "=", false) />
						<cfloop array="#myStepsDelay#" index="i">

							<!---
								Tutaj przechodzę przez wszystkie opóźnienia,
								które mają być dodane do dokumentu. Sprawdzam
								czy na danym etapie mam ustawione opóźnienie.
								1: krok
								2: opóźnienie
							--->
							<cfset stepDelay = ListToArray(i, "=", false) />

							<!---
								Znalazłem pasujące do siebie wartości.
								Aktualizuje obieg dokumentu.
							--->
							<cfif stepUser[1] EQ stepDelay[1]>

								<cfset newWorkflowStep = model("workflowStep").new() />
								<cfset newWorkflowStep.workflowstepcreated = currentTime />
								<cfset newWorkflowStep.workflowstepended = DateAdd("n", stepDelay[2], currentTime) />
								<cfset newWorkflowStep.userid = stepUser[2] />
								<cfset newWorkflowStep.workflowstatusid = 2 />
								<cfset newWorkflowStep.workflowstepnote = "" />
								<cfset newWorkflowStep.workflowstepstatusid = stepUser[1] />
								<cfset newWorkflowStep.workflowid = params.workflowid />
								<cfset newWorkflowStep.documentid = params.documentid />
								<cfset newWorkflowStep.token = CreateUUID() />
								<cfset newWorkflowStep.workflowsteptransfernote = "" />
								<cfset newWorkflowStep.isdraft = 0 />
								<cfset newWorkflowStep.iscompleted = 0 />
								<cfset newWorkflowStep.moveto = 0 />
								<cfset newWorkflowStep.save(callbacks=false) />

								<cfset currentTime = DateAdd("n", stepDelay[2], currentTime) />

							</cfif>

						</cfloop>

					</cfloop>

				</cfif>

		</cfloop>


		<cfif wasAutomated is true>
			<cfset redirectTo(controller="Users",action="getUserActiveWorkflow",key=session.user.id,success="Obieg dokumentu został zakończony.") />
		</cfif>

		<!---
			Tabelka z MPK i Projekt jest już zapisana. To co muszę zrobić to
			zamknąć dany etap i utworzyć kolejny.

			Pierwszą rzeczą jest aktualizacja aktualnego kroku.
		--->
		<!---<cfset ws = model("workflowStep").findByKey(params.workflowstepid) />--->		
		<cfset ws = model("workflowStep").findOne(where="workflowid=#params.workflowid#", order="workflowstepcreated DESC") />
		<cfset ws.workflowstepended = Now() />
		<cfset ws.workflowstatusid = 2 />

		<cfif StructKeyExists(params, "workflowstepnote")>
			<cfset ws.workflowstepnote = params.workflowstepnote />
		</cfif>

		<cfset ws.workflowsteptransfernote = params.workflowsteptransfernote & " (#params.workflow_edit_form_submit#)" />
		<cfset ws.save(callbacks=false) />

		<!---
			Kolejną rzeczą jest usunięcie starego powiadomienia mailowego i
			dodanie nowego dla nowego użytkownika na nowym etapie.
		--->
		<cfset oldMailToSend = model("workflowToSendMail").deleteAll(where="workflowid=#params.workflowid#") />

		<!---
			Dodaje nowy krok obiegu dokumentu.
			Jeżeli istnieje kolejny krok obiegu dokumentu to tworzę go.
		--->
		<cfif Len(params.next)>
			<cfset token = CreateUUID() />
			<cfset newWorkflowStep = model("workflowStep").new() />
			<cfset newWorkflowStep.documentid = ws.documentid />
			<cfset newWorkflowStep.workflowid = ws.workflowid />
			<cfset newWorkflowStep.workflowstepstatusid = params.next />
			
			<cfset newUser = "" />
			<cfif structKeyExists(params, "chairmanid")>
				<cfset newUser = params.chairmanid />
				<!---<cfset newWorkflowStep.userid = params.chairmanid />--->
			<cfelse>
				<cfset newUser = params.userid />
				<!---<cfset newWorkflowStep.userid = params.userid />--->
			</cfif>
			<cfset newWorkflowStep.userid = newUser />
			<!---
			<cfset tmp = ListToArray(params.userid, ",") />
			<cfif ArrayLen(tmp) GT 1>
				<cfset newWorkflowStep.userid = tmp[2] />
			<cfelse>
				<cfset newWorkflowStep.userid = tmp[1] />
			</cfif>
			--->
			
			<cfset newWorkflowStep.workflowstepcreated = Now() />
			<cfset newWorkflowStep.token = token />
			<cfset newWorkflowStep.workflowstatusid = 1 />
			<cfset newWorkflowStep.save(callbacks=false) />

			<cfset workflowToSendMail = model("workflowToSendMail").new()>
			<cfset workflowToSendMail.userid = newUser>
			<cfset workflowToSendMail.workflowid = params.workflowid>
			<cfset workflowToSendMail.workflowstepstatusid = params.next>
			<cfset workflowToSendMail.workflowtosendmailcreated = Now()>
			<cfset workflowToSendMail.workflowtosendmailtoken = token>
			<cfset workflowToSendMail.workflowstepid = newWorkflowStep.id>
			<cfset workflowToSendMail.save()>
		</cfif>

		<!--- 
			19.01.2014
			Dodaje informację, do której faktury to jest korekta.
		--->

		<!---<cfif IsDefined("FORM.ARCHIVEID") and Len(FORM.ARCHIVEID) GT 0 and isNumeric(FORM.ARCHIVEID)>
			<cfset ustawKorekteDo = model("document_archive").ustawKorekte(documentid=FORM.DOCUMENTID,archiveid=FORM.ARCHIVEID) />
		</cfif>--->

		<cfset redirectTo(controller="Users",action="getUserActiveWorkflow",key=session.user.id,success="Etap obiegu dokumentu został zamknięty") />

	</cffunction>

	<cffunction
		name="rejectStep"
		hint="Odrzucenie kroku obiegu dokumentu">

		<!---
			Tabelka z MPKami i Projektami jest już zapisana więc nie trzeba się
			nią więcej martwić. To co robi metoda to odrzuca dany krok i tworzy
			poprzedni.

			Aktualizuje dany krok.
		--->
		<cfset workflowStep = model("workflowStep").findByKey(params.workflowstepid) />
		<cfset workflowStep.workflowstepended = Now() />
		<cfset workflowStep.workflowstatusid = 3 />
		<cfset workflowStep.workflowsteptransfernote = params.workflowsteptransfernote />
		<cfset workflowStep.save(callbacks=false) />

		<!---
			Kolejną rzeczą jest usunięcie starego powiadomienia mailowego i
			dodanie nowego dla nowego użytkownika na nowym etapie.
		--->
		<cfset oldMailToSend = model("workflowToSendMail").deleteAll(where="workflowid=#params.workflowid#") />

		<!---
			Dodaje nowy krok obiegu dokumentu.
			Jeżeli istnieje poprzedni krok krok obiegu dokumentu to tworzę go.
		--->
		<cfif Len(params.prev) or (IsDefined("params.custom_stepstatusid") and Len(params.custom_stepstatusid)) >
			
			<cfset token = CreateUUID() />
			<cfset newWorkflowStep = model("workflowStep").new() />
			<cfset newWorkflowStep.documentid = params.documentid />
			<cfset newWorkflowStep.workflowid = params.workflowid />
			
			<cfset newStep = "" />
			<cfif StructKeyExists(params, "custom_stepstatusid") and Len(params.custom_stepstatusid)>
				<cfset newStep = params.custom_stepstatusid />
				<!---<cfset newWorkflowStep.workflowstepstatusid = params.custom_stepstatusid />--->
			<cfelse>
				<cfset newStep = params.prev />
				<!---<cfset newWorkflowStep.workflowstepstatusid = params.prev />--->
			</cfif>
			<cfset newWorkflowStep.workflowstepstatusid = newStep />
			<!---
			<cfset tmp = ListToArray(params.userid, ",") />
			<cfif ArrayLen(tmp) GT 1>
				<cfset newWorkflowStep.userid = tmp[2] />
			<cfelse>
				<cfset newWorkflowStep.userid = tmp[1] />
			</cfif>
			--->
			<cfset newUser = "" />
			<cfif StructKeyExists(params, "userid") and Len(params.userid)>
				<cfset newUser = params.userid />
			<cfelse>
				<cfset newUser = model("workflow").getStepUser(
					workflowid = params.workflowid,
					stepid = newStep) />
			</cfif>
			<cfset newWorkflowStep.userid = newUser />
			
			<cfset newWorkflowStep.workflowstepcreated = Now() />
			<cfset newWorkflowStep.token = token />
			<cfset newWorkflowStep.workflowstatusid = 1 />
			<cfset newWorkflowStep.save(callbacks=false) />

			<cfset workflowToSendMail = model("workflowToSendMail").new()>
			<cfset workflowToSendMail.userid = newUser>
			<cfset workflowToSendMail.workflowid = params.workflowid>
			<cfset workflowToSendMail.workflowstepstatusid = params.prev>
			<cfset workflowToSendMail.workflowtosendmailcreated = Now()>
			<cfset workflowToSendMail.workflowtosendmailtoken = token>
			<cfset workflowToSendMail.workflowstepid = newWorkflowStep.id>
			<cfset workflowToSendMail.save()>
		</cfif>

		<cfset redirectTo(controller="Users",action="getUserActiveWorkflow",key=session.user.id,success="Etap obiegu dokumentu został odrzucony") />

	</cffunction>

	<!---
	ajaxMove
	---------------------------------------------------------------------------------------------------------------
	Przekazanie dokumentu do innego użytkownika.

	--->
	<!---<cffunction name="ajaxMove" hint="Formularz przekazania dokumentu">

		<!--- Jeśli wywołanie było AJAXowe --->
		<cfif isAjax()>

			<!--- Pobieram aktualny krok obiegu dokumentów --->
			<cfset workflowstep = model("workflowStep").findOne(where="id=#params.workflowstepid#",include="")>

			<!--- Pobieram listę użytkowników, do których mogę przekazać dokument --->
			<cfset users = model("workflowStepStatusUser").findAll(where="workflowstepstatusid=#workflowstep.workflowstepstatusid#",include="user")>

			<cfset renderWith(data='',layout=false)>
		</cfif>
	</cffunction>--->

	<!---
	ajaxRefuse
	---------------------------------------------------------------------------------------------------------------
	Odrzucenie kroku dokumentu i przekazanie go do innej osoby.

	--->
	<!---<cffunction name="ajaxRefuse" hint="Formularz odrzucenia kroku obiegu dokumentów">

		<cfif isAjax()>

			<!--- Pobieram aktualny krok obiegu dokumentów --->
			<cfset workflowstep = model("workflowStep").findOne(where="id=#params.workflowstepid#",include="") />

			<!--- Pobieram listę użytkowników, do których mogę przekazać dokument --->
			<cfset users = model("workflowStepStatusUser").findAll(where="workflowstepstatusid=#workflowstep.workflowstepstatusid#",include="user") />

			<cfset renderWith(data="",layout=false) />

		</cfif>

	</cffunction>--->

	<!---
	actionRefuse
	---------------------------------------------------------------------------------------------------------------
	Kolejne operacje:
	- zmiana statusu aktualnego kroku,
	- stworzenie nowego kroku,
	- usunięcie informacji o wysłaniu maila,
	- dodanie nowej informacji o wysłaniu maila,
	- przekierowanie do profilu użytkownika.
	--->
	<!---<cffunction name="actionRefuse" hint="Odrzucenie dokumentu i przekazanie go do innego użytkownika">

		<!--- Pobieram krok dokumentu, który odrzucam --->
		<cfset workflowstep = model("workflowStep").findOne(where="id=#params.workflow.workflowstepid#") />

		<!--- Struktura z danymi do aktualizacji w danym kroku --->
		<cfset variable.loc = {} />
		<cfset variable.loc.workflowstepended = Now() />
		<cfset variable.loc.workflowstatusid = 3 /> <!--- Identyfikator statusu Odrzucowy dla dokumentu --->
		<cfset workflowstep.update(properties=variable.loc,callbacks=false) />

		<!--- Tworzę nowy krok obiegu dokumentów --->
		<cfset token = createUUID() /> <!--- Token kroku obiegu dokumentów --->
		<cfset newworkflowstep = model("workflowStep").new()>
		<cfset newworkflowstep.documentid = workflowstep.documentid>
		<cfset newworkflowstep.workflowid = workflowstep.workflowid>
		<cfset newworkflowstep.workflowstepstatusid = workflowstep.workflowstepstatusid>
		<cfset newworkflowstep.userid = params.workflow.workflowstepuser>
		<cfset newworkflowstep.workflowstepcreated = Now()>
		<cfset newworkflowstep.token = token>
		<cfset newworkflowstep.workflowstatusid = 1>
		<cfset newworkflowstep.workflowsteptransfernote = params.workflow.workflowtransfernote /> <!--- Notatka przy odrzuceniu kroku --->
		<cfset newworkflowstep.save(callbacks=false)>

		<!--- Kasuje informacje o wysłaniu maila --->
		<cfset workflowtosendmail = model("workflowToSendMail").deleteAll(where="workflowtosendmailtoken='#params.workflow.workflowtoken#'") />

		<!--- Dodaje nowy wpis o mailu do wysłania --->
		<cfset workflowtosendmail = model("workflowToSendMail").new() />
		<cfset workflowtosendmail.userid = params.workflow.workflowstepuser />
		<cfset workflowtosendmail.workflowid = newworkflowstep.workflowid>
		<cfset workflowtosendmail.workflowstepstatusid = newworkflowstep.workflowstepstatusid>
		<cfset workflowtosendmail.workflowtosendmailcreated = Now()>
		<cfset workflowtosendmail.workflowtosendmailtoken = token>
		<cfset workflowtosendmail.workflowstepid = newworkflowstep.id>
		<cfset workflowtosendmail.save()>

		<cfset redirectTo(controller="Users",action="view",key=session.userid,success="Dokument został odrzucony") />

	</cffunction>--->

	<!---
	actionMove
	---------------------------------------------------------------------------------------------------------------
	Kolejne operacje:
	a) Pobranie aktualnego kroku
	b) Zmiana statusu aktualnego kroku na "Przekazano"
	c) Stworzenie nowego kroku obiegu dokumentu
	d) Dodanie informacji dla użytkownika do tabeli wiadomości do wysłania
	e) Przekierowuje użytkownika do jego profilu

	--->
	<!---<cffunction name="actionMove" hint="Akcja przekazywania dokumentu innemu użytkownikowi">

		<!--- Pobieram aktualny krok dokumentu --->
		<cfset workflowstep = model("workflowStep").findOne(where="id=#params.workflow.workflowstepid#")>

		<!--- Zmieniam aktualny status kroku obiegu dokumentów --->
		<cfset variable.loc = {}>
		<cfset variable.loc.workflowstepended = Now()>
		<!---
		Identyfikator przekazania dokumentu
		TODO
		20.01.2012
		Dorobić przekazywanie identyfikatora jako argumentu do metody!
		--->
		<cfset variable.loc.workflowstatusid = 4>
		<cfset workflowstep.update(properties=variable.loc,callbacks=false)>

		<!--- Tworzę nowy krok obiegu dokumentów --->
		<cfset token = CreateUUID()>
		<cfset newworkflowstep = model("workflowStep").new()>
		<cfset newworkflowstep.documentid = workflowstep.documentid>
		<cfset newworkflowstep.workflowid = workflowstep.workflowid>
		<cfset newworkflowstep.workflowstepstatusid = workflowstep.workflowstepstatusid>
		<cfset newworkflowstep.userid = params.workflow.workflowstepuser>
		<cfset newworkflowstep.workflowstepcreated = Now()>
		<cfset newworkflowstep.token = token>
		<cfset newworkflowstep.workflowstatusid = 1>
		<cfset newworkflowstep.workflowsteptransfernote = params.workflow.workflowtransfernote /> <!--- Notatka przy przekazywaniu dokumentu dalej --->
		<cfset newworkflowstep.save()>

		<!--- Usuwam powiadomienie z tabeli wiadomości do wysłania --->
		<cftry>

			<cfset mailtosend = model("workflowToSendMail").findOne(where="workflowtosendmailtoken='#params.workflow.workflowtoken#'")>
			<cfset mailtosend.delete()>

		<cfcatch type="any"></cfcatch>

		</cftry>

		<!--- Dodaje nowe powiadomienie do tabeli wiadomości do wysłania --->
		<cfset workflowtosendmail = model("workflowToSendMail").new()>
		<cfset workflowtosendmail.userid = params.workflow.workflowstepuser>
		<cfset workflowtosendmail.workflowid = newworkflowstep.workflowid>
		<cfset workflowtosendmail.workflowstepstatusid = newworkflowstep.workflowstepstatusid>
		<cfset workflowtosendmail.workflowtosendmailcreated = Now()>
		<cfset workflowtosendmail.workflowtosendmailtoken = token>
		<cfset workflowtosendmail.workflowstepid = newworkflowstep.id>
		<cfset workflowtosendmail.save()>

		<cfset redirectTo(controller="Users",action="view",key=session.userid,success="Zadanie zostało przekazane")>

	</cffunction>--->

	<!---
		04.02.2013
		Zmieniłem sposób odawania wierszy do faktury. Teraz przy każdym dodaniu
		wiersza jest on od razu zapisywany w bazie. Pozwoli to zaoszczędzić
		stresu pracownika, kiedy faktura się nie zapisze.

		24.04.2013
		Wiersze są zapisywane i zwracany jest rekord z bazy. Aktualizacja
		wprowadzonych danych odbywa się Ajaxowo.
	--->
<!---	<cffunction
		name="getTableRow"
		hint="Metoda zwracająca wiersz tabelki z MPK, Projektem i Netto."
		description="Metoda tworzy nowy wiersz opisujący fakturę i zwraca
				pusty rekord. Widok Ajaxowo aktualizuje dane w tabelce.">

		<!---
			Tworzę nowy wiersz opisujący fakturę.
		--->
		<cfset my_workflow_description = model("workflowStepDescription").new() />
		<cfset my_workflow_description.workflowstepid		=	params.workflowstepid />
		<cfset my_workflow_description.workflowstepdescriptionuserid	=	session.user.id />
		<cfset my_workflow_description.workflowid			=	params.workflowid />
		<cfset my_workflow_description.save(callbacks=false) />

		<!---<cfset json = my_workflow_description >
		<cfset renderWith(data="json",layout=false,template="json") />--->

		<!---
			Jako losową liczbę zwracam ID wiersza opisującego fakturę.
		--->
		<!---<cfset rand = randomText(length=4) />--->
		<cfset rand = my_workflow_description.id />

		<cfset mpks = model("mpk").findAll(select="id,mpknumber,mpkname") />
		<cfset projects = model("project").findAll(select="id,projectname") />

		<cfset renderWith(data="rand,mpks,projects",layout=false) />


	</cffunction>--->
	<cffunction
		name="getTableRow2"
		hint="Metoda zwracająca wiersz tabelki z MPK, Projektem i Netto."
		description="Metoda tworzy nowy wiersz opisujący fakturę i zwraca
				pusty rekord. Widok Ajaxowo aktualizuje dane w tabelce.">

		<!---
			Tworzę nowy wiersz opisujący fakturę.
		--->
		<cfset my_workflow_description = model("workflowStepDescription").new() />
		<cfset my_workflow_description.workflowstepid		=	params.workflowstepid />
		<cfset my_workflow_description.workflowstepdescriptionuserid	=	session.user.id />
		<cfset my_workflow_description.workflowid			=	params.workflowid />
		<cfset my_workflow_description.save(callbacks=false) />

		<cfset json = my_workflow_description >
		<cfset renderWith(data="json",layout=false,template="json") />

	</cffunction>

	<!---
	documentHistory
	---------------------------------------------------------------------------------------------------------------
	Metoda pobierająca historię dokumentu w obiegu. Historia może być prezentowana zarówno dla aktywnego dokumentu
	jak i zamkniętego. Historię dokumentu widzą wszyscy użytkownicy, którzy mieli z nim styczność.

	Przekazywanym argumentem w params.key jest ID obiegu dokumentów - workflowid

	--->
	<!---<cffunction name="workflowHistory" hint="Pobieram historię dokumentu z obiegu">

		<cfset workflowhistory = model("workflowStep").findAll(where="workflowid=#params.key#",include="user,workflow Status,workflowStepStatus",order="workflowstepcreated asc") />

		<!---
			31.10.2012
			Wprowadziłem dziedziczenie i generowanie widoku dla AJAX w komponencie mc.
		--->
		<!---<cfset renderWith(data=workflowhistory,layout=false) />--->

	</cffunction>--->

	<!---
	getWorkflowsByStep
	---------------------------------------------------------------------------------------------------------------
	Metoda pobierająca historię dokumentu w obiegu. Historia może być prezentowana zarówno dla aktywnego dokumentu
	jak i zamkniętego. Historię dokumentu widzą wszyscy użytkownicy, którzy mieli z nim styczność.

	Przekazywanym argumentem w params.key jest ID obiegu dokumentów - workflowid

	--->
	<!---<cffunction name="getWorkflowsByStep" hint="Pobieranie dokumentów z danego etapu.
												Etap przesyłany jest jako argument params.key">

		<cfif StructKeyExists(params, "key")>

			<cfset loc.step = "all" />

			<cfswitch expression="#params.key#">

				<cfcase value="description">
					<cfset title = "Opisywane" />
				</cfcase>

				<cfcase value="controlling">
					<cfset title = "Controlling" />
				</cfcase>

				<cfcase value="commit">
					<cfset title = "Zatwierdzanie" />
				</cfcase>

				<cfcase value="approval">
					<cfset title = "Akceptacja" />
				</cfcase>

				<cfcase value="accounting">
					<cfset title = "Księgowość" />
				</cfcase>

				<cfcase value="archive">
					<cfset title = "Archiwum" />
				</cfcase>

				<cfdefaultcase>
					<cfset title = "Wszystkie aktywne" />
				</cfdefaultcase>

			</cfswitch>

		</cfif>

		<cfset workflows = model("workflow").getWorkflowByStep(step=params.key)/>

		<cfif IsAjax()>

			<cfset renderWith(data="workflows,title",layout=false) />

		</cfif>

	</cffunction>--->

	<!---
	getWorkflowByStep
	---------------------------------------------------------------------------------------------------------------
	Lista dokumentów w obiegu z podziałem na etap.

	21.05.2012
	Metoda została zmieniona. Jest nowy format tabelki z dokumentami w obiegu.

	--->
	<!---<cffunction name="getWorkflowByStep">
		<!---
<cfset workflowbystep = model("workflow").getWorkflowByStep(step=params.key)/>
		<cfdump var="#workflowbystep#" />
		<cfabort />
		<cfset renderWith(data="workflowbystep",layout=false)/>
--->
	</cffunction>--->

	<!---
	preview
	---------------------------------------------------------------------------------------------------------------
	Podgląd dokumentu w obiegu. Nie ma możliwośco edycji (zatwierdzania, odrzucenia) dokumentu. Można tylko
	zobaczyć opis i historię.

	Widok jest pusty. Zawiera w sobie instrukcje JS, które pobierają dane AJAXowo.

	--->
	<!---<cffunction name="preview" hint="Podgląd dokumentu w obiegu. Nie ma możliwości edycji danych.">

		<cfset workflowstep = model("workflowStep").findAll(where="workflowid=#params.key# AND workflowstatusid=1 AND userid=#session.userid#",include="workflow,workflowStepStatus,document(documentInstance)")>

		<cfif workflowstep.RecordCount neq 0>

			<cfif IsAjax()>

				<cfset redirectTo(controller="Workflows",action="descriptionPreview",key=params.key,layout=false) />

			<cfelse>

				<cfset redirectTo(controller="Workflows",action="descriptionPreview",key=params.key) />

			</cfif>

		</cfif>

		<cfif IsAjax()>

			<cfset renderWith(data="workflowstep",layout=false) />

		</cfif>

	</cffunction>--->

	<!---
	descriptionPreview
	---------------------------------------------------------------------------------------------------------------
	Podgląd dokumentu w obiegu. Nie ma możliwośco edycji (zatwierdzania, odrzucenia) dokumentu. Można tylko
	zobaczyć opis i historię.

	8.05.2012
	Dodanie warunku, który nie pokazuje faktury dla użytkownika nie biorącego udziału w jej obiegu.

	--->
	<!---<cffunction name="descriptionPreview" hint="Podgląd dokumentu w obiegu. Nie ma możliwości edycji danych.">

		<cftry>

			<cfset userworkflowsteps = model("workflowStep").findAll(where="workflowid=#params.key# AND userid=#session.userid#",include="")>

			<cfif (userworkflowsteps.RecordCount neq 0) OR
					checkUserGroup(userid=session.userid,usergroupname="root") OR
					checkUserGroup(userid=session.userid,usergroupname="Controlling") OR
					checkUserGroup(userid=session.userid,usergroupname="Księgowość") OR
					checkUserGroup(userid=session.userid,usergroupname="recepcja")>

				<cfset workflowstepdescription = model("workflowStepDescription").findAll(where="workflowid=#params.key#",include="project,mpk")/>

				<cfset documentid = model("workflow").findOne(where="id=#params.key#") />

				<!--- Pobieram informacje o dokumencie (id kontrahenta) --->
				<cfset document = model("document").findOne(where="id=#documentid.documentid#") />

				<cfset documentattributes = model("documentAttributeValue").findAll(select="documentid,attributename,documentattributetextvalue,attributeid",include="attribute,documentAttribute",where="documentid=#documentid.documentid# AND documentattributevisible=1")/>

				<cfset workflowstep = model("workflowStep").findAll(where="workflowid=#params.key#",include="",select="documentid,workflowid",distinct=true)/>

				<!--- Notatka merytoryczna faktury --->
				<cfset workflowstepdecreenote = model("workflowStep").findAll(select="workflowstepnote",where="workflowid=#params.key# AND workflowstepstatusid=1 AND workflowstepended is not null",order="workflowstepcreated desc",maxRows=1) />

				<!--- Pobieranie Kontrahenta, który wystawił fakturę --->
				<cfset contractor = model("contractor").findOne(where="id=#document.contractorid#") />

				<cfif IsAjax()> <!--- Jeśli żądanie jest AJAXowe to renderuje bez widoku --->

					<cfset renderWith(data="documentattributes,workflowstepdescription,workflowstep,workflowstepdecreenote,contractor",layout=false,hideDebugInformation=true) />

				<cfelse>

					<cfset renderWith(data="documentattributes,workflowstepdescription,workflowstep,workflowstepdecreenote,contractor",hideDebugInformation=true) />

				</cfif>

			<cfelse>

				<cfthrow type="db" message="Nie masz uprawnień do tego etapu obiego dokumentu lub etap został zamknięty.">

			</cfif>

		<cfcatch type="any">

			<cfset error = cfcatch.message />
			<cfset renderWith(data=error,template="/apperror",layout=false)/>

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
	workflowPreviewHistory
	---------------------------------------------------------------------------------------------------------------
	Podgląd historii dokumentu.

	--->
	<!---<cffunction name="workflowPreviewHistory" hint="Podgląd historii dokumentu.">

		<cfset workflowhistory = model("workflowStep").findAll(where="workflowid=#params.key#",include="user,workflow Status,workflowStepStatus",order="workflowstepcreated asc") />

		<cfset renderWith(data="workflowhistory",layout=false,hideDebugInformation=true) />

	</cffunction>--->

	<!---
	getWorkflowStepUsers
	---------------------------------------------------------------------------------------------------------------
	Lista użytkowników dla kroku obiegu dokumentów. Widok generuje listę imion i nazwisk.

	--->
	<cffunction name="getWorkflowStepUsers" hint="Pobieram listę użytkowników dla kroku obiegu dokumentów.
													Widok generuje listę wyboru z użytkownikami.">

		<cfset users = model("workflowStepStatusUser").findAll(where="workflowstepstatusid=#params.key#",include="user") />
		<cfset renderWith(data="users",layout=false) />

	</cffunction>

	<!---
	getEndStepNote
	---------------------------------------------------------------------------------------------------------------
	Generowanie okienka do wpisania komunikatu dla kolejneg użytkownika.

	--->
	<!---<cffunction name="getEndStepNote" hint="Generowanie okienka do wpisania komunikatu dla kolejneg użytkownika.">
		<cfset renderWith(data="",layout=false) />
	</cffunction>--->

	<!---
	getOkButton
	---------------------------------------------------------------------------------------------------------------
	Generowanie guzika OK dla obiegu dokumentów.

	--->
	<!---<cffunction name="getOkButton" hint="Generowanie guzika OK dla obiegu dokumentów">
		<cfset renderWith(data="",layout=false) />
	</cffunction>--->

	<!---
		Usunięcie wpisu opisującedo fakturę. Argumentem jest ID opisu
		przekazywany w params.key

		23.03.2012
		Utworzona została procedura na bazie, która kopiuje dane do tabeli del_.
		Jest wtedy pełna historia dokumentu.

		24.04.2013
		Zmieniłem odrobine procedure (kosmetyka) aby pasowała do nowej konwencji.
		Wywaliłem rzucanie strony błedu aby nie pokazywać głupiej planszy
		z errorem, której pracownicy mają dosyć.
	--->
	<cffunction name="ajaxDeleteDescriptionById"
		hint="Usunięcie wpisu z opisem faktury."
		description="Opis jest usuwany na podstawie jego ID z bazy.">

		<cftry>

			<!--- Wywołanie procedury zdefiniowanej na bazie, która usuwa dokument z obiegu --->
			<cfstoredproc
				procedure="delete_workflowstepdescription"
				datasource="#get('loc').datasource.intranet#">

				<cfprocparam
				    cfsqltype="CF_SQL_INTEGER"
				    value="#params.key#">

				<cfprocparam
				    cfsqltype="CF_SQL_INTEGER"
				    value="#session.userid#">

				<cfprocparam
				    cfsqltype="CF_SQL_VARCHAR"
				    value="#CGI.REMOTE_ADDR#">

			</cfstoredproc>

			<cfset json = params.key />
			<cfset renderWith(data="json",layout=false,template="json") />

		<cfcatch type="any"> <!--- Komunikat błędu aplikacji --->

			<cfset json = "ERROR" />
			<cfset renderWith(data="json",layout=false,template="json") />

		</cfcatch>

		</cftry>

	</cffunction>

	<!---
		setNewInvoiceCounter
		Zerowanie licznika faktur dla pierwszego dnia każdego miesiąca. Metoda wywoływna jest przez serwer ColdFusion

		14.05.2013
		Metoda pozostała. Do zrobienia jest moduł wykonywania zadań cyklicznych
		w ramach samego intranetu.
	--->
	<cffunction
		name="setNewInvoiceCounter"
		hint="Zerowanie licznika faktur dla pierwszego dnia każdego miesiąca.
				Metoda wywoływana jest okresowo co miesiąc przez serwer ColdFusion">

		<cfset workflowsetting = model("workflowSetting").findOne(where="workflowsettingname='invoicenumber'") />
		<cfset workflowsetting.update(workflowsettingvalue=1) />

		<cfset renderNothing() />

	</cffunction>

	<!---
	saveDescription
	---------------------------------------------------------------------------------------------------------------
	Zapisanie opisu dokumentu/faktury w bazie i wygenerowanie widoku z listą użytkowników, do których
	zostanie przekazany dokument.

	--->
<!---	<cffunction name="saveDescription" hint="Zapisanie opisu dokumentu/faktury">

		<cftry>

			<!--- Przechodzę przez wszystkie opisy tabelki i zapisuje je w bazie. --->
			<cfloop collection="#params.workflow.table#" item="i">

				<cfset descriptiontmp = false />
				<cfset loc.description = {} /> <!--- Zmienna lokalna do aktualizacji opisu faktury --->

				<!--- Dodaje/aktualizuje MPKi i Projekty --->
				<cfset tmp = params.workflow.table[i] />
				<cfset tmpproject = ListToArray(tmp.project, "-") /> <!--- W pierwszym indeksie tabeli znajduje się nazwa projektu --->
				<cfset tmpmpk = ListToArray(tmp.mpk, "-") /> <!--- W pierwszym indeksie znajduje się numer mpk --->

				<!--- Wyszukuje projekt po nazwie z tabeli projects w intranecie --->
				<cfset project = model("project").findOne(where="projekt='#tmpproject[1]#'") /> <!--- Projekt --->
				<cfset mpk = model("mpk").findOne(where="mpk='#tmpmpk[1]#'") /> <!--- MPK --->

				<cfif not IsStruct(project)> <!--- Jeśli projektu nie ma to go dodaje --->
					<cfset singleproject = model("project").getSingleProject(search="#tmpproject[1]#") />
					<cfset singleproject.rows[1].p_opis = singleproject.rows[1].opis />
					<cfset singleproject.rows[1].p_nazwa = singleproject.rows[1].nazwa />
					<cfset newsingleproject = model("project").create(singleproject.rows[1]) /> <!--- Tutaj mają być trzymane dane nowego projektu --->
					<cfset loc.description.projectid = newsingleproject.id />

				<cfelse> <!--- Jeśli jest projekt to pobieram jego ID --->

					<cfset loc.description.projectid = project.id />

				</cfif>

				<cfif not IsStruct(mpk)> <!--- Jeśli mpku nie ma to go dodaje --->
					<cfset singlempk = model("mpk").getSingleMpk(search="#tmpmpk[1]#") />
					<cfset singlempk.rows[1].m_opis = singlempk.rows[1].opis />
					<cfset singlempk.rows[1].m_nazwa = singlempk.rows[1].nazwa />
					<cfset newsinglempk = model("mpk").create(singlempk.rows[1]) /> <!--- Tutaj mają być trzymane dane nowego projektu --->
					<cfset loc.description.mpkid = newsinglempk.id />

				<cfelse> <!--- Jeśli jest mpk to pobieram jego ID --->

					<cfset loc.description.mpkid = mpk.id />

				</cfif>

				<!--- Koniec dodawania/aktualizacji --->

				<cfif IsNumeric(i)>
					<cfset descriptiontmp = model("workflowStepDescription").findOne(where="id=#i#") />
				</cfif>

				<cfif IsStruct(descriptiontmp)> <!--- Jeśli istnieje opis to aktualizuje go --->

					<!--- <cfset loc.description.mpkid = params.workflow.table[i].mpk /> ---> <!--- Pola są zakomentowane bo wartości wstawiam wyżej, przy wyszukiwaniu mpk/projekt w bazie --->
					<!--- <cfset loc.description.projectid = params.workflow.table[i].project /> --->
					<cfset loc.description.workflowstepdescription = params.workflow.table[i].price />
					<cfset descriptiontmp.update(properties=loc.description,callbacks=false) />

				<cfelse> <!--- Jeśli opis nie istnieje to dodaje nowy --->

					<cfset workflowstepdescription = model("workflowStepDescription").new() />
					<cfset workflowstepdescription.workflowid = params.workflow.workflowid />
					<cfset workflowstepdescription.workflowstepid = params.workflow.workflowstepid />
					<cfset workflowstepdescription.mpkid = loc.description.mpkid /> <!--- ID mpku w bazie intranetu --->
					<cfset workflowstepdescription.projectid = loc.description.projectid /> <!--- ID projektu w bazie intranetu --->
					<cfset workflowstepdescription.workflowstepdescription = params.workflow.table[i].price />
					<cfset workflowstepdescription.workflowstepdescriptioncreated = Now() />
					<cfset workflowstepdescription.workflowstepdescriptionuserid = session.userid />
					<cfset workflowstepdescription.save() />

				</cfif>

			</cfloop>

			<!--- Dodaję numer zewnętrzny faktury --->
			<cfset invoicedefaultnumber = model("documentAttributeValue").findOne(where="documentid=#params.workflow.documentid# AND attributeid=108") />
			<cfset invoicedefaultnumber.documentattributetextvalue = params.workflow.invoicedefaultnumber />
			<cfset invoicedefaultnumber.save(callbacks=false) />
			<!--- Koniec dodawania zewnętrznego numeru faktury --->

			<!---
			6.09.2012
			Aktualizuję typ dokumentu. Te dane są zapisane w tabeli documents w kolumnie typeid.
			Po tym polu dyrektorzy mogą grupować faktury.
			--->
			<cfif StructKeyExists(params, "typeid")>

				<cfset document = model("document").findByKey(params.workflow.documentid) />
				<cfset document.update(typeid=params.typeid) />

			</cfif>

			<!--- Aktualizuje aktualny krok obiegu dokumentów. --->
			<cfset workflowstep = model("workflowStep").findByKey(params.workflow.workflowstepid) />
			<cfset loc.step = {} />
			<!--- <cfset loc.step.workflowstepended = Now() /> ---> <!--- Data nie jest aktualizowana bo srok jest zapisany jako draft --->
			<!--- <cfset loc.step.workflowstatusid = 2 /> ---> <!--- Ustawiam status na zaakceptowany --->
			<cfset loc.step.isdraft = 1 /> <!--- Ustawiam dany krok jako draft. Trzeba jeszcze wybrać osobę, do której zostanie przekazany --->
			<cfset loc.step.workflowstepnote = params.workflow.workflowstepnote />
			<!--- <cfset loc.step.workflowsteptransfernote = params.workflow.workflowsteptransfernote /> ---> <!--- Komunikat dla kolejnego użytkownika --->
			<cfset workflowstep.update(properties=loc.step,callbacks=false) />

			<cfset params.key = workflowstep.workflowid /> <!--- ID obiegu dokumentów --->

			<cfset renderWith(data="workflowstep",layout=false,template="selectnextuser") />

		<cfcatch type="any">

			<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu --->

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
	actionSelectNextUser
	---------------------------------------------------------------------------------------------------------------
	Wybór kolejnej osoby w obiegu dokumentu oraz dodanie informacji dla kolejnego użytkownika.
	Po wyborze użytkownika następuje przekierowanie do strony z profilem usera.

	--->
	<!---<cffunction name="actionSelectNextUser" hint="Wybór kolejnej osoby w obiegu dokumentu oraz dodanie informacji dla kolejnego użytkownika">

		<cftry>

			<cfset workflowstep = model("workflowStep").findOne(where="id=#params.workflow.workflowstepid#") />
			<cfset workflowsteptmp = workflowstep /> <!--- Tworzę kopię danych do nowego kroku --->
			<cfset workflowstetstatus = model("workflowStepStatus").findOne(where="id=#workflowstep.workflowstepstatusid#") />

			<!--- Aktualizacja danego kroku --->
			<cfset loc.step = {} />
			<cfset loc.step.workflowstatusid = 2 /> <!--- Zamykam dany krok --->
			<cfset loc.step.workflowstepended = Now() />
			<cfset loc.step.isdraft = 0 /> <!--- Krok został zamkniety więc nie jest już draftem --->
			<cfset loc.step.workflowsteptransfernote = params.workflow.workflowsteptransfernote />
			<cfset workflowstep.update(properties=loc.step,callbacks=false) />

			<cftry>

				<!--- Usuwam Wpis z tabeli maili do wysłania --->
				<cfset mailtosend = model("workflowToSendMail").findOne(where="workflowtosendmailtoken='#params.workflow.workflowtoken#'")>
				<cfset mailtosend.delete()>

			<cfcatch type="any"></cfcatch>

			</cftry>

			<!--- Tworzę nowy krok obiegu dokumentów --->
			<cfset token = CreateUUID()>
			<cfset newworkflowstep = model("workflowStep").new()>
			<cfset newworkflowstep.documentid = workflowstep.documentid>
			<cfset newworkflowstep.workflowid = workflowstep.workflowid>
			<cfset newworkflowstep.workflowstepstatusid = workflowstetstatus.next>
			<cfset newworkflowstep.userid = params.workflow.workflowstepuserid>
			<cfset newworkflowstep.workflowstepcreated = Now()>
			<cfset newworkflowstep.token = token>
			<cfset newworkflowstep.workflowstatusid = 1>
			<cfset newworkflowstep.save()>

			<!--- Dodaje nowe powiadomienie do tabeli wiadomości do wysłania --->
			<cfset workflowtosendmail = model("workflowToSendMail").new()>
			<cfset workflowtosendmail.userid = params.workflow.workflowstepuserid>
			<cfset workflowtosendmail.workflowid = newworkflowstep.workflowid>
			<cfset workflowtosendmail.workflowstepstatusid = newworkflowstep.workflowstepstatusid>
			<cfset workflowtosendmail.workflowtosendmailcreated = Now()>
			<cfset workflowtosendmail.workflowtosendmailtoken = token>
			<cfset workflowtosendmail.workflowstepid = newworkflowstep.id>
			<cfset workflowtosendmail.save()>

			<cfset redirectTo(controller="Users",action="view",key=session.userid,success="Zadanie zostało przekazane")>

		<cfcatch type="any">

			<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu --->

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
	acceptDecree
	---------------------------------------------------------------------------------------------------------------
	Zatwierdzenie dekretu

	--->
	<!---<cffunction name="acceptDecree" hint="Zatwierdzenie dekretu">

		<cftry>

			<!--- Przechodzę przez wszystkie opisy tabelki i zapisuje je w bazie. --->
			<cfloop collection="#params.workflow.table#" item="i">

				<cfset descriptiontmp = false />
				<cfset loc.description = {} /> <!--- Zmienna lokalna do aktualizacji opisu faktury --->

				<!--- Dodaje/aktualizuje MPKi i Projekty --->
				<cfset tmp = params.workflow.table[i] />
				<cfset tmpproject = ListToArray(tmp.project, "-") /> <!--- W pierwszym indeksie tabeli znajduje się nazwa projektu --->
				<cfset tmpmpk = ListToArray(tmp.mpk, "-") /> <!--- W pierwszym indeksie znajduje się numer mpk --->

				<!--- Wyszukuje projekt po nazwie z tabeli projects w intranecie --->
				<cfset project = model("project").findOne(where="projekt='#tmpproject[1]#'") /> <!--- Projekt --->
				<cfset mpk = model("mpk").findOne(where="mpk='#tmpmpk[1]#'") /> <!--- MPK --->

				<cfif not IsStruct(project)> <!--- Jeśli projektu nie ma to go dodaje --->
					<cfset singleproject = model("project").getSingleProject(search="#tmpproject[1]#") />
					<cfset singleproject.rows[1].p_opis = singleproject.rows[1].opis />
					<cfset singleproject.rows[1].p_nazwa = singleproject.rows[1].nazwa />
					<cfset newsingleproject = model("project").create(singleproject.rows[1]) /> <!--- Tutaj mają być trzymane dane nowego projektu --->
					<cfset loc.description.projectid = newsingleproject.id />

				<cfelse> <!--- Jeśli jest projekt to pobieram jego ID --->

					<cfset loc.description.projectid = project.id />

				</cfif>

				<cfif not IsStruct(mpk)> <!--- Jeśli mpku nie ma to go dodaje --->
					<cfset singlempk = model("mpk").getSingleMpk(search="#tmpmpk[1]#") />
					<cfset singlempk.rows[1].m_opis = singlempk.rows[1].opis />
					<cfset singlempk.rows[1].m_nazwa = singlempk.rows[1].nazwa />
					<cfset newsinglempk = model("mpk").create(singlempk.rows[1]) /> <!--- Tutaj mają być trzymane dane nowego projektu --->
					<cfset loc.description.mpkid = newsinglempk.id />

				<cfelse> <!--- Jeśli jest mpk to pobieram jego ID --->

					<cfset loc.description.mpkid = mpk.id />

				</cfif>

				<!--- Koniec dodawania/aktualizacji --->

				<cfif IsNumeric(i)>
					<cfset descriptiontmp = model("workflowStepDescription").findOne(where="id=#i#") />
				</cfif>

				<cfif IsStruct(descriptiontmp)> <!--- Jeśli istnieje opis to aktualizuje go --->

					<!--- <cfset loc.description.mpkid = params.workflow.table[i].mpk /> ---> <!--- Pola są zakomentowane bo wartości wstawiam wyżej, przy wyszukiwaniu mpk/projekt w bazie --->
					<!--- <cfset loc.description.projectid = params.workflow.table[i].project /> --->
					<cfset loc.description.workflowstepdescription = params.workflow.table[i].price />
					<cfset descriptiontmp.update(properties=loc.description,callbacks=false) />

				<cfelse> <!--- Jeśli opis nie istnieje to dodaje nowy --->

					<cfset workflowstepdescription = model("workflowStepDescription").new() />
					<cfset workflowstepdescription.workflowid = params.workflow.workflowid />
					<cfset workflowstepdescription.workflowstepid = params.workflow.workflowstepid />
					<cfset workflowstepdescription.mpkid = loc.description.mpkid /> <!--- ID mpku w bazie intranetu --->
					<cfset workflowstepdescription.projectid = loc.description.projectid /> <!--- ID projektu w bazie intranetu --->
					<cfset workflowstepdescription.workflowstepdescription = params.workflow.table[i].price />
					<cfset workflowstepdescription.workflowstepdescriptioncreated = Now() />
					<cfset workflowstepdescription.workflowstepdescriptionuserid = session.userid />
					<cfset workflowstepdescription.save() />

				</cfif>

			</cfloop>

			<!--- Aktualizuje aktualny krok obiegu dokumentów. --->
			<cfset workflowstep = model("workflowStep").findByKey(params.workflow.workflowstepid) />
			<cfset loc.step = {} />
			<!--- <cfset loc.step.workflowstepended = Now() /> ---> <!--- Ustawiam krok jako draft. Dlatego nie ma daty --->
			<!--- <cfset loc.step.workflowstatusid = 2 /> ---> <!--- Ustawiam status na zaakceptowany --->
			<cfset loc.step.isdraft = 1 /> <!--- Ustawiam dany krok jako draft. Trzeba jeszcze wybrać osobę, do której zostanie przekazany --->
			<cfset loc.step.workflowstepnote = "Dekret był prawidłowy" />
			<!--- <cfset loc.step.workflowsteptransfernote = params.workflow.workflowsteptransfernote /> ---> <!--- Komunikat dla kolejnego użytkownika --->
			<cfset workflowstep.update(properties=loc.step,callbacks=false) />

			<cfset params.key = workflowstep.workflowid /> <!--- ID obiegu dokumentów --->

			<cfset renderWith(data="workflowstep",layout=false,template="selectnextuser") />

		<cfcatch type="any">

			<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu --->

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
	modifiedDecree
	---------------------------------------------------------------------------------------------------------------
	Dekret był poprawiony i może przejść dalej.

	--->
	<!---<cffunction name="modifiedDecree" hint="Zatwierdzenie dekretu">

		<cftry>

			<!--- Przechodzę przez wszystkie opisy tabelki i zapisuje je w bazie. --->
			<cfloop collection="#params.workflow.table#" item="i">

				<cfset descriptiontmp = false />
				<cfset loc.description = {} /> <!--- Zmienna lokalna do aktualizacji opisu faktury --->

				<!--- Dodaje/aktualizuje MPKi i Projekty --->
				<cfset tmp = params.workflow.table[i] />
				<cfset tmpproject = ListToArray(tmp.project, "-") /> <!--- W pierwszym indeksie tabeli znajduje się nazwa projektu --->
				<cfset tmpmpk = ListToArray(tmp.mpk, "-") /> <!--- W pierwszym indeksie znajduje się numer mpk --->

				<!--- Wyszukuje projekt po nazwie z tabeli projects w intranecie --->
				<cfset project = model("project").findOne(where="projekt='#tmpproject[1]#'") /> <!--- Projekt --->
				<cfset mpk = model("mpk").findOne(where="mpk='#tmpmpk[1]#'") /> <!--- MPK --->

				<cfif not IsStruct(project)> <!--- Jeśli projektu nie ma to go dodaje --->
					<cfset singleproject = model("project").getSingleProject(search="#tmpproject[1]#") />
					<cfset singleproject.rows[1].p_opis = singleproject.rows[1].opis />
					<cfset singleproject.rows[1].p_nazwa = singleproject.rows[1].nazwa />
					<cfset newsingleproject = model("project").create(singleproject.rows[1]) /> <!--- Tutaj mają być trzymane dane nowego projektu --->
					<cfset loc.description.projectid = newsingleproject.id />

				<cfelse> <!--- Jeśli jest projekt to pobieram jego ID --->

					<cfset loc.description.projectid = project.id />

				</cfif>

				<cfif not IsStruct(mpk)> <!--- Jeśli mpku nie ma to go dodaje --->
					<cfset singlempk = model("mpk").getSingleMpk(search="#tmpmpk[1]#") />
					<cfset singlempk.rows[1].m_opis = singlempk.rows[1].opis />
					<cfset singlempk.rows[1].m_nazwa = singlempk.rows[1].nazwa />
					<cfset newsinglempk = model("mpk").create(singlempk.rows[1]) /> <!--- Tutaj mają być trzymane dane nowego projektu --->
					<cfset loc.description.mpkid = newsinglempk.id />

				<cfelse> <!--- Jeśli jest mpk to pobieram jego ID --->

					<cfset loc.description.mpkid = mpk.id />

				</cfif>

				<!--- Koniec dodawania/aktualizacji --->

				<cfif IsNumeric(i)>
					<cfset descriptiontmp = model("workflowStepDescription").findOne(where="id=#i#") />
				</cfif>

				<cfif IsStruct(descriptiontmp)> <!--- Jeśli istnieje opis to aktualizuje go --->

					<!--- <cfset loc.description.mpkid = params.workflow.table[i].mpk /> ---> <!--- Pola są zakomentowane bo wartości wstawiam wyżej, przy wyszukiwaniu mpk/projekt w bazie --->
					<!--- <cfset loc.description.projectid = params.workflow.table[i].project /> --->
					<cfset loc.description.workflowstepdescription = params.workflow.table[i].price />
					<cfset descriptiontmp.update(properties=loc.description,callbacks=false) />

				<cfelse> <!--- Jeśli opis nie istnieje to dodaje nowy --->

					<cfset workflowstepdescription = model("workflowStepDescription").new() />
					<cfset workflowstepdescription.workflowid = params.workflow.workflowid />
					<cfset workflowstepdescription.workflowstepid = params.workflow.workflowstepid />
					<cfset workflowstepdescription.mpkid = loc.description.mpkid /> <!--- ID mpku w bazie intranetu --->
					<cfset workflowstepdescription.projectid = loc.description.projectid /> <!--- ID projektu w bazie intranetu --->
					<cfset workflowstepdescription.workflowstepdescription = params.workflow.table[i].price />
					<cfset workflowstepdescription.workflowstepdescriptioncreated = Now() />
					<cfset workflowstepdescription.workflowstepdescriptionuserid = session.userid />
					<cfset workflowstepdescription.save() />

				</cfif>

			</cfloop>

			<!--- Aktualizuje aktualny krok obiegu dokumentów. --->
			<cfset workflowstep = model("workflowStep").findByKey(params.workflow.workflowstepid) />
			<cfset loc.step = {} />
			<!--- <cfset loc.step.workflowstepended = Now() /> ---> <!--- Modyfikuje dekret i ustawiam to jako draft --->
			<!--- <cfset loc.step.workflowstatusid = 2 /> ---> <!--- Ustawiam status na zaakceptowany --->
			<cfset loc.step.isdraft = 1 /> <!--- Ustawiam dany krok jako draft. Trzeba jeszcze wybrać osobę, do której zostanie przekazany --->
			<cfset loc.step.workflowstepnote = "Dekret został poprawiony" />
			<!--- <cfset loc.step.workflowsteptransfernote = params.workflow.workflowsteptransfernote /> ---> <!--- Komunikat dla kolejnego użytkownika --->
			<cfset workflowstep.update(properties=loc.step,callbacks=false) />

			<cfset params.key = workflowstep.workflowid /> <!--- ID obiegu dokumentów --->

			<cfset renderWith(data="workflowstep",layout=false,template="selectnextuser") />

		<cfcatch type="any">

			<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu --->

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
	refuseDecree
	---------------------------------------------------------------------------------------------------------------
	Dekret był niepoprawny i został odrzucony.

	--->
	<!---<cffunction name="refuseDecree" hint="Odruzcenie dekretu">

		<cftry>

						<!--- Przechodzę przez wszystkie opisy tabelki i zapisuje je w bazie. --->
			<cfloop collection="#params.workflow.table#" item="i">

				<cfset descriptiontmp = false />
				<cfset loc.description = {} /> <!--- Zmienna lokalna do aktualizacji opisu faktury --->

				<!--- Dodaje/aktualizuje MPKi i Projekty --->
				<cfset tmp = params.workflow.table[i] />
				<cfset tmpproject = ListToArray(tmp.project, "-") /> <!--- W pierwszym indeksie tabeli znajduje się nazwa projektu --->
				<cfset tmpmpk = ListToArray(tmp.mpk, "-") /> <!--- W pierwszym indeksie znajduje się numer mpk --->

				<!--- Wyszukuje projekt po nazwie z tabeli projects w intranecie --->
				<cfset project = model("project").findOne(where="projekt='#tmpproject[1]#'") /> <!--- Projekt --->
				<cfset mpk = model("mpk").findOne(where="mpk='#tmpmpk[1]#'") /> <!--- MPK --->

				<cfif not IsStruct(project)> <!--- Jeśli projektu nie ma to go dodaje --->
					<cfset singleproject = model("project").getSingleProject(search="#tmpproject[1]#") />
					<cfset singleproject.rows[1].p_opis = singleproject.rows[1].opis />
					<cfset singleproject.rows[1].p_nazwa = singleproject.rows[1].nazwa />
					<cfset newsingleproject = model("project").create(singleproject.rows[1]) /> <!--- Tutaj mają być trzymane dane nowego projektu --->
					<cfset loc.description.projectid = newsingleproject.id />

				<cfelse> <!--- Jeśli jest projekt to pobieram jego ID --->

					<cfset loc.description.projectid = project.id />

				</cfif>

				<cfif not IsStruct(mpk)> <!--- Jeśli mpku nie ma to go dodaje --->
					<cfset singlempk = model("mpk").getSingleMpk(search="#tmpmpk[1]#") />
					<cfset singlempk.rows[1].m_opis = singlempk.rows[1].opis />
					<cfset singlempk.rows[1].m_nazwa = singlempk.rows[1].nazwa />
					<cfset newsinglempk = model("mpk").create(singlempk.rows[1]) /> <!--- Tutaj mają być trzymane dane nowego projektu --->
					<cfset loc.description.mpkid = newsinglempk.id />

				<cfelse> <!--- Jeśli jest mpk to pobieram jego ID --->

					<cfset loc.description.mpkid = mpk.id />

				</cfif>

				<!--- Koniec dodawania/aktualizacji --->

				<cfif IsNumeric(i)>
					<cfset descriptiontmp = model("workflowStepDescription").findOne(where="id=#i#") />
				</cfif>

				<cfif IsStruct(descriptiontmp)> <!--- Jeśli istnieje opis to aktualizuje go --->

					<!--- <cfset loc.description.mpkid = params.workflow.table[i].mpk /> ---> <!--- Pola są zakomentowane bo wartości wstawiam wyżej, przy wyszukiwaniu mpk/projekt w bazie --->
					<!--- <cfset loc.description.projectid = params.workflow.table[i].project /> --->
					<cfset loc.description.workflowstepdescription = params.workflow.table[i].price />
					<cfset descriptiontmp.update(properties=loc.description,callbacks=false) />

				<cfelse> <!--- Jeśli opis nie istnieje to dodaje nowy --->

					<cfset workflowstepdescription = model("workflowStepDescription").new() />
					<cfset workflowstepdescription.workflowid = params.workflow.workflowid />
					<cfset workflowstepdescription.workflowstepid = params.workflow.workflowstepid />
					<cfset workflowstepdescription.mpkid = loc.description.mpkid /> <!--- ID mpku w bazie intranetu --->
					<cfset workflowstepdescription.projectid = loc.description.projectid /> <!--- ID projektu w bazie intranetu --->
					<cfset workflowstepdescription.workflowstepdescription = params.workflow.table[i].price />
					<cfset workflowstepdescription.workflowstepdescriptioncreated = Now() />
					<cfset workflowstepdescription.workflowstepdescriptionuserid = session.userid />
					<cfset workflowstepdescription.save() />

				</cfif>

			</cfloop>

			<!--- Aktualizuje aktualny krok obiegu dokumentów. --->
			<cfset workflowstep = model("workflowStep").findByKey(params.workflow.workflowstepid) />
			<cfset loc.step = {} />
			<!--- <cfset loc.step.workflowstepended = Now() /> ---> <!--- Ustawiam krok jako draft. --->
			<!--- <cfset loc.step.workflowstatusid = 3 /> ---> <!--- Ustawiam status na odrzucono --->
			<cfset loc.step.isdraft = 1 /> <!--- Ustawiam dany krok jako draft. Trzeba jeszcze wybrać osobę, do której zostanie przekazany --->
			<cfset loc.step.workflowstepnote = "Dekret został odrzucony" />
			<!--- <cfset loc.step.workflowsteptransfernote = params.workflow.workflowsteptransfernote /> ---> <!--- Komunikat dla kolejnego użytkownika --->
			<cfset workflowstep.update(properties=loc.step,callbacks=false) />

			<cfset params.key = workflowstep.workflowid /> <!--- ID obiegu dokumentów --->

			<cfset renderWith(data="workflowstep",layout=false,template="selectprevuser") />

		<cfcatch type="any">

			<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu --->

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
	actionSelectPrevUser
	---------------------------------------------------------------------------------------------------------------
	Przekazanie dokumentu do poprzedniego kroku.

	--->
	<!---<cffunction name="actionSelectPrevUser" hint="Wybór kolejnej osoby w obiegu dokumentu oraz dodanie informacji dla kolejnego użytkownika">

		<cftry>

			<cfset workflowstep = model("workflowStep").findOne(where="id=#params.workflow.workflowstepid#") />
			<cfset workflowsteptmp = workflowstep /> <!--- Tworzę kopię danych do nowego kroku --->
			<cfset workflowstetstatus = model("workflowStepStatus").findOne(where="id=#workflowstep.workflowstepstatusid#") />

			<!--- Aktualizacja danego kroku --->
			<cfset loc.step = {} />
			<cfset loc.step.workflowstatusid = 3 /> <!--- Zamykam dany krok --->
			<cfset loc.step.workflowstepended = Now() /> <!--- Wpisuje dane zamknięcia kroku --->
			<cfset loc.step.isdraft = 0 /> <!--- Usuwam informacje, że krok był zapisany jako draft --->
			<cfset loc.step.workflowsteptransfernote = params.workflow.workflowsteptransfernote />
			<cfset workflowstep.update(properties=loc.step,callbacks=false) />

			<cftry>

				<!--- Usuwam Wpis z tabeli maili do wysłania --->
				<cfset mailtosend = model("workflowToSendMail").findOne(where="workflowtosendmailtoken='#params.workflow.workflowtoken#'")>
				<cfset mailtosend.delete()>

			<cfcatch type="any"></cfcatch>

			</cftry>

			<!--- Tworzę nowy krok obiegu dokumentów --->
			<cfset token = CreateUUID()>
			<cfset newworkflowstep = model("workflowStep").new()>
			<cfset newworkflowstep.documentid = workflowstep.documentid>
			<cfset newworkflowstep.workflowid = workflowstep.workflowid>

			<cfif StructKeyExists(params.workflow, "workflowstepstatusid")> <!--- Jeśli odrzucał dyrektor to jest umieszczona informacja, do którego kroku zostało odrzucone --->
				<cfset newworkflowstep.workflowstepstatusid = params.workflow.workflowstepstatusid />
			<cfelse>
				<cfset newworkflowstep.workflowstepstatusid = workflowstetstatus.prev>
			</cfif>

			<cfset newworkflowstep.userid = params.workflow.workflowstepuserid>
			<cfset newworkflowstep.workflowstepcreated = Now()>
			<cfset newworkflowstep.token = token>
			<cfset newworkflowstep.workflowstatusid = 1>
			<cfset newworkflowstep.save()>

			<!--- Dodaje nowe powiadomienie do tabeli wiadomości do wysłania --->
			<cfset workflowtosendmail = model("workflowToSendMail").new()>
			<cfset workflowtosendmail.userid = params.workflow.workflowstepuserid>
			<cfset workflowtosendmail.workflowid = newworkflowstep.workflowid>
			<cfset workflowtosendmail.workflowstepstatusid = newworkflowstep.workflowstepstatusid>
			<cfset workflowtosendmail.workflowtosendmailcreated = Now()>
			<cfset workflowtosendmail.workflowtosendmailtoken = token>
			<cfset workflowtosendmail.workflowstepid = newworkflowstep.id>
			<cfset workflowtosendmail.save()>

			<cfset redirectTo(controller="Users",action="view",key=session.userid,success="Zadanie zostało przekazane")>

		<cfcatch type="any">

			<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu --->

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
	acceptInvoice
	---------------------------------------------------------------------------------------------------------------
	Akceptowanie faktury.

	--->
	<!---<cffunction name="acceptInvoice" hint="Akceptowanie faktury">

		<cftry>

			<!--- Aktualizuje aktualny krok obiegu dokumentów. --->
			<cfset workflowstep = model("workflowStep").findByKey(params.workflow.workflowstepid) />
			<cfset loc.step = {} />
			<!--- <cfset loc.step.workflowstepended = Now() /> --->
			<!--- <cfset loc.step.workflowstatusid = 2 /> ---> <!--- Ustawiam status na zaakceptowano --->
			<cfset loc.step.isdraft = 1 /> <!--- Ustawiam dany krok jako draft. Trzeba jeszcze wybrać osobę, do której zostanie przekazany --->

			<cfset loc.step.workflowstepnote = "" />

			<cfif workflowstep.workflowstepstatusid eq 3>

				<cfset loc.step.workflowstepnote = "Dokument został zatwierdzony" />

			<cfelse>

				<cfset loc.step.workflowstepnote = "Dokument został zaakceptowany" />

			</cfif>

			<!--- <cfset loc.step.workflowsteptransfernote = params.workflow.workflowsteptransfernote /> ---> <!--- Komunikat dla kolejnego użytkownika --->

			<cfset workflowstep.update(properties=loc.step,callbacks=false) />

			<cfset params.key = workflowstep.workflowid /> <!--- ID obiegu dokumentów --->

			<cfset renderWith(data="workflowstep",layout=false,template="selectnextuser") />

		<cfcatch type="any">

			<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu --->

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
	refuseInvoice
	---------------------------------------------------------------------------------------------------------------
	Odrzucenie faktury.

	--->
	<!---<cffunction name="refuseInvoice" hint="Odrzucenie faktury">

		<cftry>

			<!--- Aktualizuje aktualny krok obiegu dokumentów. --->
			<cfset workflowstep = model("workflowStep").findByKey(params.workflow.workflowstepid) />
			<cfset loc.step = {} />
			<!--- <cfset loc.step.workflowstepended = Now() /> --->
			<!--- <cfset loc.step.workflowstatusid = 3 /> ---> <!--- Ustawiam status na odrzucono --->
			<cfset loc.step.isdraft = 1 /> <!--- Ustawiam dany krok jako draft. Trzeba jeszcze wybrać osobę, do której zostanie przekazany --->
			<cfset loc.step.workflowstepnote = "Dokument został odrzucony" />
			<!--- <cfset loc.step.workflowsteptransfernote = params.workflow.workflowsteptransfernote /> ---> <!--- Komunikat dla kolejnego użytkownika --->
			<cfset workflowstep.update(properties=loc.step,callbacks=false) />

			<cfset params.key = workflowstep.workflowid /> <!--- ID obiegu dokumentów --->

			<cfset workflowstepstatuses = model("workflowStepStatus").findAll(where="id<#workflowstep.workflowstepstatusid#") />

			<cfset renderWith(data="workflowstep,workflowstepstatuses",layout=false,template="selectprevuser") />

		<cfcatch type="any">

			<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu --->

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
	closeInvoice
	---------------------------------------------------------------------------------------------------------------
	Zamykanie faktury przez prezesa. Po tym kroku obieg dokumentów się kończy.

	23.03.2012
	To jest ostatni krok obiegu dokumentów dostępny tylko dla prezesa. Tylko on może zamknąć obieg dokumentów.

	--->
	<!---<cffunction name="closeInvoice" hint="Zamykanie obiegu dokumentu. Opcja dostępna tylko dla Księgowości.">

		<cftry>

			<!--- Aktualizuje aktualny krok obiegu dokumentów. --->
			<cfset workflowstep = model("workflowStep").findByKey(params.workflow.workflowstepid) />
			<cfset loc.step = {} />
			<cfset loc.step.workflowstepended = Now() />
			<cfset loc.step.workflowstatusid = 2 /> <!--- Ustawiam status na Zaakceptowano --->
			<cfset loc.step.isdraft = 0 /> <!--- Usuwam informację o drafcie danego kroku --->
			<cfset loc.step.iscompleted = 1 /> <!--- Flaga mówiąca, że obieg tego dokumentu się skończył --->
			<cfset loc.step.workflowstepnote = "Zamknięto obieg dokumentu" />
			<cfset loc.step.workflowsteptransfernote = params.workflow.workflowsteptransfernote /> <!--- Komunikat dla kolejnego użytkownika --->
			<cfset workflowstep.update(properties=loc.step,callbacks=false) />

			<cfset params.key = workflowstep.workflowid /> <!--- ID obiegu dokumentów --->

			<cftry>

				<!--- Usuwam Wpis z tabeli maili do wysłania --->
				<cfset mailtosend = model("workflowToSendMail").findOne(where="workflowtosendmailtoken='#params.workflow.workflowtoken#'")>
				<cfset mailtosend.delete()>

			<cfcatch type="any"></cfcatch>

			</cftry>

			<!--- Tutaj pobieram kolejny dokument z obiegu aby pokazać go w okienku --->
			<cfset userworkflows = model("workflowStep").findOne(where="userid=#session.userid# AND workflowstepstatusid=5 AND workflowstatusid=1",order="workflowstepcreated desc") />

			<cfif IsStruct(userworkflows)>

				<cfset redirectTo(controller="Workflows",action="userStep",key=userworkflows.workflowid,layout=false) />

			<cfelse>

				<cfset renderWith(data="",layout=false,template="closeworkflow") />

			</cfif>

<!--- 			<cfset renderWith(data="",layout=false,template="closeworkflow") /> --->

		<cfcatch type="any">

			<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu --->

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
	moveDescription
	---------------------------------------------------------------------------------------------------------------
	Przekazanie faktury do innego użytkownika.

	--->
	<!---<cffunction name="moveDescription" hint="Przekazanie opisu dokumentu do innego użytkownika">

		<cftry>

			<!--- Aktualizuje aktualny krok obiegu dokumentów. --->
			<cfset workflowstep = model("workflowStep").findByKey(params.workflow.workflowstepid) />
			<cfset loc.step = {} />
			<!--- <cfset loc.step.workflowstepended = Now() /> --->
			<!--- <cfset loc.step.workflowstatusid = 2 /> ---> <!--- Ustawiam status na odrzucono --->
			<cfset loc.step.isdraft = 1 /> <!--- Ustawiam dany krok jako draft. Trzeba jeszcze wybrać osobę, do której zostanie przekazany --->
			<!--- <cfset loc.step.workflowstepnote = "Dokument został przekazany" /> --->
			<!--- <cfset loc.step.workflowsteptransfernote = params.workflow.workflowsteptransfernote /> ---> <!--- Komunikat dla kolejnego użytkownika --->
			<cfset workflowstep.update(properties=loc.step,callbacks=false) />

			<cfset params.key = workflowstep.workflowid /> <!--- ID obiegu dokumentów --->

			<cfset renderWith(data="workflowstep",layout=false,template="selectmoveuser") />

		<cfcatch type="any">

			<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu --->

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
	actionSelectMoveUser
	---------------------------------------------------------------------------------------------------------------
	Akcja przekazania dokumentu do innego użytkownika. Etap nie jest już draftem. Ta flaga zostanie zmieniona.
	Dokument otrzyma status Przekazano. Zostanie utworzony nowy krok obiegu dokumentów.

	--->
	<!---<cffunction name="actionSelectMoveUser" hint="Przypisanie dokumentu do innego użytkownika">

		<cftry>

			<cfset workflowstep = model("workflowStep").findOne(where="id=#params.workflow.workflowstepid#") />
			<cfset workflowsteptmp = workflowstep /> <!--- Tworzę kopię danych do nowego kroku --->
			<cfset workflowstetstatus = model("workflowStepStatus").findOne(where="id=#workflowstep.workflowstepstatusid#") />

			<!--- Aktualizacja danego kroku --->
			<cfset loc.step = {} />
			<cfset loc.step.workflowstatusid = 4 /> <!--- Przekazuje dany krok --->
			<cfset loc.step.workflowstepended = Now() />
			<cfset loc.step.isdraft = 0 /> <!--- Krok został zamkniety więc nie jest już draftem --->
			<cfset loc.step.workflowsteptransfernote = params.workflow.workflowsteptransfernote />
			<cfset workflowstep.update(properties=loc.step,callbacks=false) />

			<cftry>

				<!--- Usuwam Wpis z tabeli maili do wysłania --->
				<cfset mailtosend = model("workflowToSendMail").findOne(where="workflowtosendmailtoken='#params.workflow.workflowtoken#'")>
				<cfset mailtosend.delete()>

			<cfcatch type="any"></cfcatch>

			</cftry>

			<!--- Tworzę nowy krok obiegu dokumentów --->
			<cfset token = CreateUUID()>
			<cfset newworkflowstep = model("workflowStep").new()>
			<cfset newworkflowstep.documentid = workflowstep.documentid>
			<cfset newworkflowstep.workflowid = workflowstep.workflowid>
			<cfset newworkflowstep.workflowstepstatusid = workflowstep.workflowstepstatusid>
			<cfset newworkflowstep.userid = params.workflow.workflowstepuserid>
			<cfset newworkflowstep.workflowstepcreated = Now()>
			<cfset newworkflowstep.token = token>
			<cfset newworkflowstep.workflowstatusid = 1>
			<cfset newworkflowstep.save()>

			<!--- Dodaje nowe powiadomienie do tabeli wiadomości do wysłania --->
			<cfset workflowtosendmail = model("workflowToSendMail").new()>
			<cfset workflowtosendmail.userid = params.workflow.workflowstepuserid>
			<cfset workflowtosendmail.workflowid = newworkflowstep.workflowid>
			<cfset workflowtosendmail.workflowstepstatusid = newworkflowstep.workflowstepstatusid>
			<cfset workflowtosendmail.workflowtosendmailcreated = Now()>
			<cfset workflowtosendmail.workflowtosendmailtoken = token>
			<cfset workflowtosendmail.workflowstepid = newworkflowstep.id>
			<cfset workflowtosendmail.save()>

			<cfset redirectTo(controller="Users",action="view",key=session.userid,success="Zadanie zostało przekazane")>

		<cfcatch type="any">

			<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu --->

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
	moveToDescription
	---------------------------------------------------------------------------------------------------------------
	Bardzo ważna metoda w całym cyklu obiegu dokumentu. Tutaj księgowość przekazuje fakturę do ponownego
	opisu merytorycznego. Po zapisaniu nowego opisu faktura wraca do księgowości, już z pominięciem
	pozostałych kroków.

	--->
	<!---<cffunction name="moveToDescription" hint="Przekazanie do ponownego opisu przez księgowość">

		<cftry>

			<!---
			- ustawiam status na przekazano i zamykam krok
			- usuwam informację o powiadomieniu mailowym
			- tworzę nowy krok dla opisywania i dodaje dodatkową wartość w polu moveto - id kroku. pobieram z niego ustawienia

			--->


			<!--- Tworzę kopię kroku --->
			<cfset workflowstep = model("workflowStep").findOne(where="id=#params.workflow.workflowstepid#") />
			<cfset tmp = workflowstep />

			<!--- Pobieram id uzytkownika, który opisywał ten dokument --->
			<cfset userid = model("workflowStep").findAll(where="workflowid=#workflowstep.workflowid# AND workflowstatusid=2 AND workflowstepstatusid=1",order="workflowstepended DESC",maxRows=1) />

			<!--- Aktualizuje krok obiegu dokumentów --->
			<cfset loc.step = {} />
			<cfset loc.step.workflowstatusid = 4 /> <!--- Przekazuje dany krok --->
			<cfset loc.step.workflowstepended = Now() /> <!--- Data zamknięcia tego kroku i przesłania go dalej --->
			<cfset loc.step.isdraft = 0 /> <!--- Krok został zamkniety więc nie jest draftem --->
			<cfset loc.step.workflowsteptransfernote = params.workflow.workflowsteptransfernote />
			<cfset workflowstep.update(properties=loc.step,callbacks=false) />

			<cftry>

				<!--- Usuwam Wpis z tabeli maili do wysłania --->
				<cfset mailtosend = model("workflowToSendMail").findOne(where="workflowtosendmailtoken='#params.workflow.workflowtoken#'")>
				<cfset mailtosend.delete()>

			<cfcatch type="any"></cfcatch>

			</cftry>

			<!--- Dodaje nowy krok i umieszczam w nim informację moveto - id kroku z którego przyszło przekazanie --->
			<cfset token = CreateUUID() />
			<cfset newworkflowstep = model("workflowStep").new() />
			<cfset newworkflowstep.documentid = workflowstep.documentid>
			<cfset newworkflowstep.workflowid = workflowstep.workflowid>
			<cfset newworkflowstep.workflowstepstatusid = 1 /> <!--- Ponowne opisywanie dokumentu --->
			<cfset newworkflowstep.userid = userid.userid>
			<cfset newworkflowstep.workflowstepcreated = Now()>
			<cfset newworkflowstep.token = token>
			<cfset newworkflowstep.workflowstatusid = 1>
			<cfset newworkflowstep.moveto = workflowstep.id /> <!--- Identyfikator kroku, z którego przyszło przekazanie --->
			<cfset newworkflowstep.save()>

			<!--- Dodaje nowe powiadomienie do tabeli wiadomości do wysłania --->
			<cfset workflowtosendmail = model("workflowToSendMail").new()>
			<cfset workflowtosendmail.userid = userid.userid>
			<cfset workflowtosendmail.workflowid = newworkflowstep.workflowid>
			<cfset workflowtosendmail.workflowstepstatusid = newworkflowstep.workflowstepstatusid>
			<cfset workflowtosendmail.workflowtosendmailcreated = Now()>
			<cfset workflowtosendmail.workflowtosendmailtoken = token>
			<cfset workflowtosendmail.workflowstepid = newworkflowstep.id>
			<cfset workflowtosendmail.save()>

<!--- 			<cfset redirectTo(controller="Users",action="view",key=session.userid,layout=false,success="Zadanie zostało przekazane") /> --->

		<cfcatch type="any">
			<cfset error = cfcatch />
			<cfset renderWith(data=error,layout=false,template="/apperror") /> <!--- Komunikat błędu --->

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
	toAccounting
	---------------------------------------------------------------------------------------------------------------
	Przekazanie opisu dokumentu od razu do księgowości.

	--->
	<!---<cffunction name="toAccounting" hint="Przekazanie opisu do księgowości">

		<cftry>

			<!--- Tworzę kopię kroku --->
			<cfset workflowstep = model("workflowStep").findOne(where="id=#params.workflow.workflowstepid#") />
			<cfset tmp = workflowstep />

			<!--- Pobieram id uzytkownika, który opisywał ten dokument --->
			<cfset userid = model("workflowStep").findAll(where="id=#workflowstep.moveto#",maxRows=1) />

			<!--- Aktualizuje krok obiegu dokumentów --->
			<cfset loc.step = {} />
			<cfset loc.step.workflowstatusid = 2 /> <!--- Zamykam dany krok --->
			<cfset loc.step.workflowstepended = Now() /> <!--- Data zamknięcia tego kroku i przesłania go dalej --->
			<cfset loc.step.isdraft = 0 /> <!--- Krok został zamkniety więc nie jest draftem --->
			<cfset loc.step.workflowstepnote = params.workflow.workflowstepnote />
			<cfset loc.step.workflowsteptransfernote = "Poprawiono opis merytoryczny" />
			<cfset workflowstep.update(properties=loc.step,callbacks=false) />

			<cftry>

				<!--- Usuwam Wpis z tabeli maili do wysłania --->
				<cfset mailtosend = model("workflowToSendMail").findOne(where="workflowtosendmailtoken='#params.workflow.workflowtoken#'")>
				<cfset mailtosend.delete()>

			<cfcatch type="any"></cfcatch>

			</cftry>

			<!--- Dodaje nowy krok --->
			<cfset token = CreateUUID() />
			<cfset newworkflowstep = model("workflowStep").new() />
			<cfset newworkflowstep.documentid = workflowstep.documentid>
			<cfset newworkflowstep.workflowid = workflowstep.workflowid>
			<cfset newworkflowstep.workflowstepstatusid = 4 /> <!--- Ponownie do księgowości --->
			<cfset newworkflowstep.userid = userid.userid>
			<cfset newworkflowstep.workflowstepcreated = Now()>
			<cfset newworkflowstep.token = token>
			<cfset newworkflowstep.workflowstatusid = 1>
			<cfset newworkflowstep.save()>

			<!--- Dodaje nowe powiadomienie do tabeli wiadomości do wysłania --->
			<cfset workflowtosendmail = model("workflowToSendMail").new()>
			<cfset workflowtosendmail.userid = userid.userid>
			<cfset workflowtosendmail.workflowid = newworkflowstep.workflowid>
			<cfset workflowtosendmail.workflowstepstatusid = newworkflowstep.workflowstepstatusid>
			<cfset workflowtosendmail.workflowtosendmailcreated = Now()>
			<cfset workflowtosendmail.workflowtosendmailtoken = token>
			<cfset workflowtosendmail.workflowstepid = newworkflowstep.id>
			<cfset workflowtosendmail.save()>

<!--- 			<cfset redirectTo(controller="Users",action="view",key=session.userid,layout=false,success="Zadanie zostało przekazane") /> --->

		<cfcatch type="any">

			<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu aplikacji --->

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
		Pobieranie notki dekretacyjnej faktury.
		Wygenerowany jest widok notki dekretacyjnej z mośliwością zapisania do pliku PDF.

		20.05.2013
		Metoda ostała się przy zmianach wyglądu Intranetu.
	--->
	<cffunction
		name="decreeNote"
		hint="Pobieranie notki dekretacyjnej faktury">

		<cftry>

			<!--- Informacja, kto i kiedy dodał dokument do obiegu --->
			<cfset workflowcreated = model("workflow").findAll(where="id=#params.key#",include="user") />

			<!--- Kolejne kroki obiegu dokumentu --->
			<cfset workflowsteps = model("workflowStep").getDecree(workflowid=params.key) />

			<!--- MPKi i projekty dokumentu --->
			<cfset workflowstepdescription = model("workflowStepDescription").findAll(where="workflowid=#params.key#",include="project,mpk")/>

			<!--- Identyfikator dokumentu --->
			<cfset documentid = model("workflow").findOne(where="id=#params.key#") />

			<!--- Dane dokumentu (identyfikator kontrahenta) --->
			<cfset document = model("document").findOne(where="id=#documentid.documentid#") />

			<!--- Informacje wprowadzone przez osobę dodającą dokument do obiegu --->
			<cfset documentattributes = model("documentAttributeValue").findAll(select="documentid,attributename,documentattributetextvalue,attributeid",include="attribute,documentAttribute",where="documentid=#documentid.documentid# AND documentattributevisible=1")/>

			<!--- Dane kontrahenta do umieszczenia w notce dekretacyjnej --->
			<cfset contractor = model("contractor").findOne(where="id=#document.contractorid#") />

			<!---
			6.07.2012
			Łączę się z bazą danych Asseco i pobieram linijki dowodu do faktury.
			Pobieram numer korespondencyjny faktury (numer intranetowy).
			--->
			<cfset correspondnumb = model("triggerWorkflowStepList").findOne(where="documentid=#documentid.documentid#") />
			<cfset assecodecreenote = model("workflow").getNote(karta_korespondencji="#correspondnumb.documentname#") />

			<cfif IsAjax()>

				<cfset renderWith(data='workflowcreated,workflowstep,workflowstepdescription,documentattributes,contractor,assecodecreenote',layout=false)>

			<cfelse>

				<cfset renderWith(data='workflowcreated,workflowstep,workflowstepdescription,documentattributes,assecodecreenote')>

			</cfif>

		<cfcatch type="any">

			<cfif IsAjax()>

				<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu aplikacji --->

			<cfelse>

				<cfset renderWith(data="",template="/apperror") /> <!--- Komunikat błędu aplikacji --->

			</cfif>

		</cfcatch>

		</cftry>

	</cffunction>

	<!---
	moveWorkflowStep
	---------------------------------------------------------------------------------------------------------------
	Lista faktur, które zostaną przekazane do innego użytkownika.

	--->
	<!---<cffunction name="moveWorkflowStep" hint="Przekazanie wielu dokumentów z obiegu do innego użytkowniak">

		<cftry>

			<!--- Parsuje przesłane identyfikatory kroku obiegu dokumentów. --->
			<cfset workflowsArray = ListToArray(params.workflowid, ",") />

			<!--- Usuwam ostatni przecinek aby zbudować zapytanie do bazy --->
			<cfset workflowids = model("triggerWorkflowStepList").findAll(where="workflowid in (#Left(params.workflowid, Len(params.workflowid)-1)#)",select="workflowid,documentname,id,workflowcreated") />

			<cfif isAjax()>

				<cfset renderWith(data="workflowids",layout=false,template="moveworkflowstep") />

			<cfelse>

				<cfset renderWith(data="workflowids",template="moveworkflowstep") />

			</cfif>

		<cfcatch type="any"> <!--- Komunikat błędu aplikacji --->

			<cfif IsAjax()> <!--- Jeśli wywołanie było ajazowe to błąd będzie też zwracany Ajaxowo --->

				<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu aplikacji --->

			<cfelse> <!--- Wyrenderowanie komunikatu błędu --->

				<cfset renderWith(data="",template="/apperror") /> <!--- Komunikat błędu aplikacji --->

			</cfif>

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
	actionMoveWorkflowStep
	---------------------------------------------------------------------------------------------------------------
	Przekazanie dokumentów do innego użytkownika. Można przekazać więcej niż jeden dokument.

	Kolejne kroki przekazywania dokumentów:
	- Pobranie aktualnego kroku mając id obiegu dokumentów
	- Zmieniam status kroku obiegu dokumentów
	- Usunięcie powiadomienia mailowego
	- Tworzę nowy krok obiegu dokumentów
	- Przypisuje użytkownika do nowego kroku
	- Pobieram następny id i wracam do początku

	--->
	<!---<cffunction name="actionMoveWorkflowStep" hint="Przekazanie dokumentów do innego użytkownika">

		<cftry>

			<cfloop collection="#params.workflowids#" item="i">

				<!--- Pobieram aktualny krok obiegu dokumentów --->
				<cfset workflow = model("workflowStep").findOne(where="workflowid=#i# AND workflowstatusid=1 AND userid=#session.userid#") />


				<cfset variables.loc = {} />
				<cfset variables.loc.workflowstepended = Now() /> <!--- Data zakończenia kroku --->
				<cfset variables.loc.workflowstatusid = 4 /> <!--- Ustawienie statusu przekazano --->
				<!---
				06.08.2012
				Nie nadpisuje opisu merytorycznego faktury
				--->
				<!--- <cfset variables.loc.workflowstepnote = "Dokument został przekazany" /> ---> <!--- Informacja o przekazaniu dokumentu --->
				<cfset variables.loc.workflowsteptransfernote = "Dokument został przekazany" />

				<cfset workflow.update(properties=variables.loc,callbacks=false) />

				<cfset workflowtosendmail = model("workflowToSendMail").deleteAll(where="workflowtosendmailtoken='#workflow.token#'") /> <!--- Usunięcie powiadomienia mailowego --->

				<!--- Dodanie nowego kroku / przekazanie --->
				<cfset tmptoken = CreateUUID() /> <!--- Token dla kroku obiegu dokumentów i powiadomienia mailowego --->

				<cfset newworkflow = model("workflowStep").new() />
				<cfset newworkflow.workflowstepcreated = Now() />
				<cfset newworkflow.userid = params.workflow.workflowstepuserid />
				<cfset newworkflow.workflowstatusid = 1 /> <!--- Status "W trakcie" dla nowego kroku --->
				<cfset newworkflow.workflowstepstatusid = workflow.workflowstepstatusid />
				<cfset newworkflow.workflowid = i />
				<cfset newworkflow.documentid = workflow.documentid />
				<cfset newworkflow.token = tmptoken />
				<cfset newworkflow.save(callbacks=false) />

				<!--- Nowa wiadomość do wysłania dla użytkownika --->
				<cfset newmailtosend = model("workflowToSendMail").new() />
				<cfset newmailtosend.userid = params.workflow.workflowstepuserid />
				<cfset newmailtosend.workflowid = i />
				<cfset newmailtosend.workflowstepstatusid = newworkflow.workflowstepstatusid />
				<cfset newmailtosend.workflowtosendmailcreated = Now() />
				<cfset newmailtosend.workflowstepid = newworkflow.id />
				<cfset newmailtosend.workflowtosendmailtoken = tmptoken />
				<cfset newmailtosend.save(callbacks=false) />

			</cfloop>

			<cfset redirectTo(controller="Users",action="view",key=session.userid) />

		<cfcatch type="any"> <!--- Komunikat błędu aplikacji --->

			<cfif IsAjax()> <!--- Jeśli wywołanie było ajazowe to błąd będzie też zwracany Ajaxowo --->

				<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu aplikacji --->

			<cfelse> <!--- Wyrenderowanie komunikatu błędu --->

				<cfset renderWith(data="",template="/apperror") /> <!--- Komunikat błędu aplikacji --->

			</cfif>

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
		Usunięcie dokumentu z obiegu.
		Dokument jest usunięty z głównych tabel obiegu dok i przenoszony do tabel del_.
		Jest zdefiniowana procedura na bazie danych, która usuwa dokument z obiegu - delete_workflow.

		Procedura przyjmuje 3 parametry:
		- workflow_id identyfikator obiegu dokumentów do usunięcia
		- user_id identyfikator uzytkownika usuwająego dokument z obiegu
		- ip ip komputera, z którego przyszło żadanie

		16.05.2013
		Aby przyspieszyć usuwanie faktur, cały proces usuwania z Intranetu
		umieściłem w osobnym wątpku.
		
		11.09.2013
		Ilość faktur przekracza już 37tys Przy takiej ilości oraz przy zapisywaniu
		plików PDF w bazie, każda operacja na fakturze jest wolna.
		Zmieniłem sposób usuwania faktur. Metoda delete ustawia flagę todelete = 1
		W nocy we wskazanym przeze mnie przedziale czasowym serwer przechodzi
		przez wszystkie faktury do usunięcia i przenosi je do tabel z usuniętymi danymi.
	--->
	<cffunction
		name="delete"
		hint="Usunięcie dokumentu z obiegu. Dokument jest usuwany w tabeli
				obiegu i przenoszony do tabel del_">

		
		<cfset toDelete = model("workflow").markToDelete(params.key, params.documentid) />
		
		
		<!---<cfthread
			action="run"
			name="deleteDocument#TimeFormat(Now(), 'HHmm')#"
			priority="HIGH" >

			<cftry>
				
				<!--- Usunięcie dokumentu z obiegu --->
				<cfset deletedWorkflow = model("workflow").delete(
					workflowid = params.key,
					documentid = params.documentid,
					userid = session.user.id,
					ip = cgi.remote_addr) />

				<cfcatch type="any"> <!--- Komunikat błędu aplikacji --->
					<cfsavecontent variable="myMail" >
						<cfdump var="#cfcatch#" />
					</cfsavecontent>
					
					<cfset sender = APPLICATION.cfc.email.init() />
					<cfset sender.setTo(
						model("user").findAll(where="id=2")
					).setSubject(subject="Usunięcie faktury").setBody(body=myMail).send() />
					
				</cfcatch>

			</cftry>

		</cfthread>--->

		<cfset redirectTo(controller="Users",action="getUserActiveWorkflow",key=session.user.id) />

	</cffunction>

	<!---
	toAccount
	---------------------------------------------------------------------------------------------------------------
	Metoda dodana 23.03.2012 po spotkaniu z Prezesem (20.03.2012). Trzeba zamienić kolejnością księgowość z Prezesem.
	Teraz ostatnim krokiem będzie akceptacja przez Prezesa.

	Kroki metody:
	- pobieram aktualny krok
	- zamknięcie aktualnego kroku
	- zmiana statusu
	- usunięcie powiadomienia email
	- wyszukanie id prezesa
	- dodanie nowego kroku obiegu dokumentów
	- przypisanie nowego kroku do prezesa
	- dodanie powiadomienia mailowego o nowym kroku
	--->
	<!---<cffunction
		name="toAccount"
		hint="Księgowanie faktury"
		description="Metoda zmieniająca status dokumentu w obiegu na zaksięgowany">

		<cftry>

			<cfset workflowstep = model("workflowStep").findOne(where="id=#params.workflow.workflowstepid#") /> <!--- Aktualny kook obiegu dokumentów. --->

			<!--- Struktura z danymi, które aktualizuje w danym kroku obiegu dokumentów --->
			<cfset loc.toupdate = {} />
			<cfset loc.toupdate.workflowstepended = Now() /> <!--- Data zakończenia kroku --->
			<cfset loc.toupdate.workflowstatusid = 2 /> <!--- Zmieniam status na Zaakceptowano --->
			<cfset loc.toupdate.workflowstepnote = "Dokument został zaksięgowany" /> <!--- Informacja o zaksięgowaniu dokumentu --->
			<cfset loc.toupdate.workflowsteptransfernote = params.workflow.workflowsteptransfernote />

			<!--- Aktualizacja aktualnego kroku obiegu dokumentów --->
			<cfset workflowstep.update(properties=loc.toupdate,callbacks=false) />

			<!--- Usuwam Wpis z tabeli maili do wysłania --->
			<cftry>

				<cfset mailtosend = model("workflowToSendMail").findOne(where="workflowtosendmailtoken='#params.workflow.workflowtoken#'")>
				<cfset mailtosend.delete()>

			<cfcatch type="any"></cfcatch>

			</cftry>

			<!--- Wyszukuje id prezesa --->
			<cfset workflowsettings = model("workflowSetting").findOne(where="workflowsettingname='chairman'") />
			<!--- Parsuje otrzymane dane i wyciągam identyfikatory --->
			<cfset valuesArray = listToArray(workflowsettings.workflowsettingvalue, ":", false, true) /> <!--- W pierwszym wierszu jest id Prezesa --->

			<cfset token = CreateUUID() />
			<cfset step = model("workflowStep").new() />
			<cfset step.workflowstepcreated = Now() />
			<cfset step.userid = valuesArray[1] /> <!--- id Prezesa --->
			<cfset step.workflowstatusid = 1 /> <!--- Status W trakcie --->
			<cfset step.workflowstepstatusid = params.workflow.next /> <!--- Następny krok obiego dokumentów --->
			<cfset step.workflowid = params.workflow.workflowid /> <!--- Id obiegu dokumentów --->
			<cfset step.documentid = params.workflow.documentid /> <!--- Id dokumentu --->
			<cfset step.token = token />
			<cfset step.save(callbacks=false) /> <!--- Zapisuje nowy krok obiegu dok --->

			<cfset tosend = model("workflowToSendMail").new () /> <!--- Nowy email z powiadomieniem --->
			<cfset tosend.userid = step.userid />
			<cfset tosend.workflowid = step.workflowid />
			<cfset tosend.workflowstepstatusid = step.workflowstepstatusid />
			<cfset tosend.workflowtosendmailcreated = Now() />
			<cfset tosend.workflowstepid = step.id />
			<cfset tosend.workflowtosendmailtoken = token />
			<cfset tosend.save(callbacks=false) /> <!--- Zapisanie w bazie nowego maila do wysłania --->

			<cfset redirectTo(controller="Users",action="getUserActiveWorkflow",key=session.userid) />

		<cfcatch type="any"> <!--- Jeśli jest błąd do wyświetlam stronę z komunikatem --->

			<cfif IsAjax()> <!--- Jeśli wywołanie było ajaxowe to błąd będzie też zwracany Ajaxowo --->

				<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu aplikacji --->

			<cfelse> <!--- Wyrenderowanie komunikatu błędu --->

				<cfset renderWith(data="",template="/apperror") /> <!--- Komunikat błędu aplikacji --->

			</cfif>

		</cfcatch>

		</cftry>

	</cffunction>--->

	<!---
	14.05.2012
	Nowa metoda pozwalająca na zamknięcie obiegu dokumentu z poziomu tabelki Prezesa.

	--->
	<!---<cffunction
		name="closeInvoiceRow"
		hint="Zamknięcie obiego dokumentów"
		description="Metoda zamykająca obieg dokumentów. Wywołanie tej metody odbywa się z poziomu tabelki z listą dokumentów Prezesa">

		<cftry>

			<!--- Aktualizuje krok obiegu dokumentu --->
			<cfset workflowstep = model("workflowStep").findOne(where="workflowid=#params.key# AND workflowstepstatusid=5 AND workflowstatusid=1 AND userid=#session.userid#") />
			<cfset workflowstep.workflowstepended = Now() />
			<cfset workflowstep.isdraft = 0 />
			<cfset workflowstep.iscompleted = 1 />
			<cfset workflowstep.workflowstatusid = 2 /> <!--- Zmieniam staus na zamknięto --->
			<cfset workflowstep.workflowstepnote = "Zamknięto obieg dokumentów" />
			<cfset workflowstep.save(callbacks=false) />

			<!--- Usuwam powiadomienie email --->
			<cfset mailtosend = model("workflowToSendMail").findOne(where="workflowtosendmailtoken='#workflowstep.token#'")>
			<cfset mailtosend.delete()>

			<cfset renderWith(data="workflowstep",layout=false) />

		<cfcatch type="any">

			<cfset renderWith(data="",layout=false,tmplate="/apperror") />

		</cfcatch>

		</cftry>

	</cffunction>--->

<!---	<cffunction
		name="closeInvoiceRows"
		hint="Zamknięcie obiegu wielu dokumentów"
		description="Metoda zamykająca obieg wielu dokumentów na raz. Trzeba zanaczyc opcje checkbox przy dokumencie.">

		<cfdump var="#params#" />
		<cfabort />

	</cffunction>--->

	<cffunction
		name="previewByHr"
		hint="Metoda pozwalająca na podgląd faktury przez Personalny"
		description="Metoda pozwalająca na podgląd faktury przez departament Personalny">

		<cfif 	checkUserGroup(userid=session.userid,usergroupname="root") OR
				checkUserGroup(userid=session.userid,usergroupname="Departament Personalny")>

			<cfset userworkflowsteps = model("workflowStep").findAll(where="workflowid=#params.key#",include="")>

			<cfset workflowstepdescription = model("workflowStepDescription").findAll(where="workflowid=#params.key#",include="project,mpk")/>

			<cfset documentid = model("workflow").findOne(where="id=#params.key#") />

			<!--- Pobieram informacje o dokumencie (id kontrahenta) --->
			<cfset document = model("document").findOne(where="id=#documentid.documentid#") />

			<!---
				Jeśli ktoś wywołał tą metodę i nie jest z Personalnego to
				przekierowuje go do podglądu faktury. Tam skrypt zdecyduje, czy
				ma dostęp czy nie ma.
			--->
			<cfif document.delegation eq 0>

				<cfset redirectTo(controller="Workflows",action="step",key=params.key) />

			</cfif>

			<cfset documentattributes = model("documentAttributeValue").findAll(select="documentid,attributename,documentattributetextvalue,attributeid",include="attribute,documentAttribute",where="documentid=#documentid.documentid# AND documentattributevisible=1")/>

			<cfset workflowstep = model("workflowStep").findAll(where="workflowid=#params.key#",include="",select="documentid,workflowid",distinct=true)/>

			<!--- Notatka merytoryczna faktury --->
			<cfset workflowstepdecreenote = model("workflowStep").findAll(select="workflowstepnote",where="workflowid=#params.key# AND workflowstepstatusid=1 AND workflowstepended is not null",order="workflowstepcreated desc",maxRows=1) />

			<!--- Pobieranie Kontrahenta, który wystawił fakturę --->
			<cfset contractor = model("contractor").findOne(where="id=#document.contractorid#") />

			<cfset renderPartial(partial="preview",layout="/layout") />

		<cfelse>

			<cfset redirectTo(controller="Workflows",action="step",key=params.key) />

		</cfif>

	</cffunction>

	<!---
		28.01.2013
		Widok do grupowego akceptowania faktur w Intranecie.
	--->
	<!---<cffunction
		name="acceptGroup"
		hint="Grupowe akceptowanie faktur">

		<!---
			Tutaj pobieram listę faktur, które chcę zaakceptować.
		--->
		<cfset my_workflows = model("viewWorkflowSearch").findAll(where="workflowid IN (#Left(params.workflowid, Len(params.workflowid)-1)#)") />

	</cffunction>--->

	<!---<cffunction
		name="actionAcceptGroup"
		hint="Metoda akceptująca liste faktur."
		description="Faktury do akceptacji są przesłane  ukrytych polach formularza.
				W pętli muszę przejść przez wszystkie wartości. Pobrać każdą z nich
				i utworzyć kolejny krok obiegu dokumentów.">

		<!---
			28.01.2013
			W pętli przechodzę przez wszystkie faktury i akceptuje je.
		--->

		<cftry>

			<!---
				Ustawiam domyślne wartości, które będą widziane przy
				zaakceptowanych fakturach.
				Domyślnie ustawiam datę, użytkownika i status.
			--->
			<cfset variables.accept_workflow = structNew() />
 			<cfset variables.accept_workflow.workflowstepended = Now() />
			<cfset variables.accept_workflow.workflowstatusid = 2 />
			<cfset variables.accept_workflow.isdraft = 0 />
			<cfset variables.accept_workflow.workflowsteptransfernote = "Dokument został zaakceptowany grupowo." />

			<cfloop collection="#params.workflowids#" item="i" >

				<!---
					Pobieram aktualny krok pierwszego dokumentu.
				--->
				<cfset my_workflow_step = model("workflowStep").findOne(where="workflowid=#i# AND workflowstatusid=1 AND userid=#session.userid#") />

				<cfif not structIsEmpty(my_workflow_step)>

					<!---
						Akceptuje dany krok obiegu dokumentu.
					--->
					<cfset my_workflow_step.update(
						properties		=		variables.accept_workflow,
						callbacks		=		false) />

					<!---
						Usuwam wiadomość email do wysłania.
					--->
					<cfset workflow_to_send_mail = model("workflowToSendMail").deleteAll(where="workflowtosendmailtoken='#my_workflow_step.token#'") />

					<!---
						Pobieram kolejny krok obiegu dokumentów
					--->
					<cfset next_step = model("workflowStepStatus").findByKey(my_workflow_step.workflowstepstatusid) />

					<!---
						Generuje token dla nowego kroku.
					--->
					<cfset tmptoken = CreateUUID() />

					<!---
						Tworzę nowy krok obiegu dokumentów.
					--->
					<cfset new_workflow_step = model("workflowStep").New() />
					<cfset new_workflow_step.workflowstepcreated = Now() />
					<cfset new_workflow_step.userid = params.workflow.workflowstepuserid />
					<cfset new_workflow_step.workflowstatusid = 1 /> <!--- Status "W trakcie" dla nowego kroku --->
					<cfset new_workflow_step.workflowstepstatusid = next_step.next />
					<cfset new_workflow_step.workflowid = i />
					<cfset new_workflow_step.documentid = my_workflow_step.documentid />
					<cfset new_workflow_step.token = tmptoken />
					<cfset new_workflow_step.save(callbacks=false) />

					<!---
						Tworzę nową wiadomość email do wysłania.
					--->
					<cfset newmailtosend = model("workflowToSendMail").new() />
					<cfset newmailtosend.userid = params.workflow.workflowstepuserid />
					<cfset newmailtosend.workflowid = i />
					<cfset newmailtosend.workflowstepstatusid = new_workflow_step.workflowstepstatusid />
					<cfset newmailtosend.workflowtosendmailcreated = Now() />
					<cfset newmailtosend.workflowstepid = new_workflow_step.id />
					<cfset newmailtosend.workflowtosendmailtoken = tmptoken />
					<cfset newmailtosend.save(callbacks=false) />

				</cfif>

			</cfloop>

			<!---
				Po wszystkim przekierowuje na stronę z listą aktywnych dokumentów.
			--->
			<cfset redirectTo(controller="Users",action="getUserActiveWorkflow",key=session.userid) />

			<cfcatch type="any" >
				<cfset redirectTo(controller="Users",action="getUserActiveWorkflow",key=session.userid,error=cfcatch.message) />
			</cfcatch>

		</cftry>

	</cffunction>--->

	<!---<cffunction
		name="updateDescriptionRow"
		hint="Aktualizacja wiersza opisu faktury"
		description="Do metody jest przekazywany ID wiersza opisu faktury oraz
			wartość do zaktualizowania">

		<cfset my_row = model("workflowStepDescription").findByKey(params.workflowstepdescriptionid) />
		<cfset val_to_insert = "" />

		<!---
			Sprawdzam, czy aktualizuje MPK.
			Jak tak to parsuje dane i zapisuje.
		--->
		<cfif structKeyExists(params, "mpk") >

			<cfset tmpmpk = ListToArray(params.mpk, "-") /> <!--- W pierwszym indeksie znajduje się numer mpk --->
			<cfset mpk = model("mpk").findOne(where="mpk='#tmpmpk[1]#'") /> <!--- Wyszukuje mpk po nazwie --->

			<cfif not IsStruct(mpk)> <!--- Jeśli mpku nie ma to go dodaje --->
				<cfset singlempk = model("mpk").getSingleMpk(search="#tmpmpk[1]#") />
				<cfset singlempk.rows[1].m_opis = singlempk.rows[1].opis />
				<cfset singlempk.rows[1].m_nazwa = singlempk.rows[1].nazwa />
				<cfset newsinglempk = model("mpk").create(singlempk.rows[1]) /> <!--- Tutaj mają być trzymane dane nowego projektu --->
				<cfset val_to_insert = newsinglempk.id />

			<cfelse> <!--- Jeśli jest mpk to pobieram jego ID --->

				<cfset val_to_insert = mpk.id />

			</cfif>

			<cfset my_row.mpkid = val_to_insert />

		<!---
			Sprawdzam, czy aktualizuje projekt.
			Jak tak to parsuje dane (podobnie jak w mpk) i zapisuje.
		--->
		<cfelseif structKeyExists(params, "project") >

			<cfset tmpproject = ListToArray(params.project, "-") /> <!--- W pierwszym indeksie tabeli znajduje się nazwa projektu --->

			<cfset project = model("project").findOne(where="projekt='#tmpproject[1]#'") /> <!--- Wyszukuje projekt po nazwie z tabeli projects w intranecie --->

			<cfif not IsStruct(project)> <!--- Jeśli projektu nie ma to go dodaje --->
				<cfset singleproject = model("project").getSingleProject(search="#tmpproject[1]#") />
				<cfset singleproject.rows[1].p_opis = singleproject.rows[1].opis />
				<cfset singleproject.rows[1].p_nazwa = singleproject.rows[1].nazwa />
				<cfset newsingleproject = model("project").create(singleproject.rows[1]) /> <!--- Tutaj mają być trzymane dane nowego projektu --->
				<cfset val_to_insert = newsingleproject.id />

			<cfelse> <!--- Jeśli jest projekt to pobieram jego ID --->

				<cfset val_to_insert = project.id />

			</cfif>

			<cfset my_row.projectid = val_to_insert />

		<!---
			Sprawdzam, czy aktualizuje kwotę w opisie faktury.
		--->
		<cfelseif structKeyExists(params, "price") >

			<cfset my_row.workflowstepdescription = params.price />

		</cfif>

		<cfset my_row.save(callbacks=false) />

		<cfset renderWith(data="",layout=false) />

	</cffunction>--->

	<cffunction
		name="groupMove"
		hint="Formularz wyświetlany użytkowni przy przekazywaniu grupowym faktur">

		<!---
			25.04.2012
			Formularz wybierania użytkownika, do którego ma zostać
			przekazana faktura.
		--->
		<cfset usesLayout(false) />

	</cffunction>

	<cffunction
		name="groupAccept"
		hint="Formularz akceptacji grupowej faktur.">

		<!---
			25.04.2013
			Formularz wybierania użytkownika, do którego ma zostać przekazana
			zaakceptowana faktura.
		--->
		<cfset usesLayout(false) />

	</cffunction>

	<cffunction
		name="moveSingleInvoice"
		hint="Przekazanie pojedyńczego dokumentu do innego użytkownika">

		<cfset workflowStep = model("workflowStep").moveWorkflow(
			workflowid = params.workflowid,
			userid = params.userid) />

		<cfset json = params.workflowid />
		<cfset renderWith(data="json",template="json",layout=false) />

	</cffunction>

	<cffunction
		name="acceptSingleInvoice"
		hint="Zaakceptowanie pojedyńczego dokumentu i przesłanie go do
				następnego użytkownika.">

		<cfset workflowStep = model("workflowStep").acceptWorkflow(
			workflowid = params.workflowid,
			userid = params.userid) />

		<cfset json = params.workflowid />
		<cfset renderWith(data="json",template="json",layout=false) />

	</cffunction>

	<cffunction
		name="moveInvoice"
		hint="Przekazanie pojedynczego dokumentu."
		description="Metoda odpalana z widoku pojedyńczej faktury.
				Generowany jest formularz przekazywania dokumentu, taki sam
				jak przy przekazywaniu grupowym.">

		<cfset workflowid = params.key />
		<cfset usesLayout(false) />

	</cffunction>
	
	<cffunction
		name="acceptInvoice"
		hint="Formularz akceptacji pojedynczego dokumentu.">
		
		<cfif StructKeyExists(params, "key")>
			<cfset workflowstep = model("WorkflowStep").findOne(where="workflowid=#params.key# AND workflowstatusid=1", order="id DESC") />
			
			<cfset workflowDescription = model("workflowStepDescription").getDescription(workflowid = params.key) />
			
			<cfset workflowStepStatuses = model("workflowStepStatuses").findAll() />
			
			<cfset chairmanIdTmp = model("workflowSetting").findOne(where="workflowsettingname='chairman'") />
			<cfset chairmanId = listToArray(chairmanIdTmp.workflowsettingvalue, ":", false, true) />
			
			<cfif IsObject(workflowstep)>
				<cfset workflowstepstatus = model("WorkflowStepStatus").findByKey(workflowstep.workflowstepstatusid) />
				
				<cfset workflowid = params.key /> 
				<cfset documentid = workflowstep.documentid />
				<cfset id = workflowstep.id />
				<cfset prev = workflowstepstatus.prev />
				<cfset next = workflowstepstatus.next />
				
				<!---<cfif StructKeyExists(params, "workflowstep")>
					<cfset renderPage(template="/workflows/steps/#params.workflowstep#") />
				<cfelse>
					<cfset renderNothing() />
				</cfif>--->
				
			<cfelse>
				<cfset renderNothing() />
			</cfif>
			
		<cfelse>
			<cfset renderNothing() />
		</cfif>
		
		<cfset usesLayout(false) />
		<!---<cfset variable = workflowstep />
		<cfset renderWith(data="variable",template="/dump",layout=false) />--->

	</cffunction>
	
	<cffunction
		name="rejectInvoice"
		hint="Formularz odrzucania pojedynczego dokumentu.">
		
		<cfif StructKeyExists(params, "key")>
			<cfset workflowstep = model("WorkflowStep").findOne(where="workflowid=#params.key# AND workflowstatusid=1", order="id DESC") />
			
			<cfset workflowDescription = model("workflowStepDescription").getDescription(workflowid = params.key) />
			
			<cfset workflowStepStatuses = model("workflowStepStatuses").findAll() />
			
			<cfif IsObject(workflowstep)>
				<cfset workflowstepstatus = model("WorkflowStepStatus").findByKey(workflowstep.workflowstepstatusid) />
				
				<cfset workflowid = params.key /> 
				<cfset documentid = workflowstep.documentid />
				<cfset id = workflowstep.id />
				<cfset prev = workflowstepstatus.prev />
				<cfset next = workflowstepstatus.next />
				
				<!---<cfif StructKeyExists(params, "workflowstep")>
					<cfset renderPage(template="/workflows/steps/#params.workflowstep#") />
				<cfelse>
					<cfset renderNothing() />
				</cfif>--->
				
			<cfelse>
				<cfset renderNothing() />
			</cfif>
			
		<cfelse>
			<cfset renderNothing() />
		</cfif>
		
		<cfset usesLayout(false) />
		<!---<cfset variable = workflowstep />
		<cfset renderWith(data="variable",template="/dump",layout=false) />--->

	</cffunction>
	
	<cffunction
		name="acceptInvoiceToChairman"
		hint="Zaksięgowanie pojedyńczego dokumentu i przesłanie go do prezesa.">

		<cfset workflowStep = model("workflowStep").acceptWorkflowToChairman(
			workflowid = params.workflowid) />

		<cfset json = params.workflowid />
		<cfset renderWith(data="json",template="json",layout=false) />

	</cffunction>

	<cffunction
		name="closeInvoice"
		hint="Zamknięcie obiegu dokumentu"
		description="Zamknięcie obiegu dokumentu. Metoda jest dostępna tylko
				dla Prezesa aby mógł zamykać dokument grupowo.">

		<cfset workflowStep = model("workflowStep").close(
			workflowid = params.workflowid,
			userid = params.userid) />

		<cfset json = params.workflowid />
		<cfset renderWith(data="json",template="json",layout=false) />

	</cffunction>

	<cffunction name="edit" hint="Edycja dokumentu w obiegu." description="Metoda generująca formularz edycji dokumentu. Ma ona zastąpić dotychczasową metodę userStep i wyeliminować problemy przy opisywaniu faktur.">

			
		<cfset ws = model("workflowGetUserStep").getUserStep(
			userid = session.user.id,
			workflowid = params.key) />

		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
			<cfinvokeargument name="groupname" value="Wszystkie dokumenty" />
		</cfinvoke>

		<cfif (ws.RecordCount EQ 0) and (priv is not true)>
			<cfset renderNothing() />
		</cfif>

		<!--- Pobranie ID Prezesa. --->
		<cfset chairmanIdTmp = model("workflowSetting").findOne(where="workflowsettingname='chairman'") />
		<cfset chairmanId = listToArray(chairmanIdTmp.workflowsettingvalue, ":", false, true) />

		<!--- Podstawowe informacje o fakturze. --->
		<cfset workflow = model("viewWorkflowSearch").findOne(where="workflowid=#params.key#") />

		<!--- Dane o kontrahencie. --->
		<cfset contractor = model("contractor").findByKey(workflow.contractorid) />

		<!--- Dane o dokumencie --->
		<cfset document = model("document").findByKey(workflow.documentid) />
		
		<cfif isNumeric(document.archiveid) and document.archiveid NEQ 0>
			<cfset archiwum = model("document_archive").pobierzElement(document.archiveid) />
		</cfif>

		<!--- Pobieram podstawowe informacje o wprowadzeniu dokumentu --->
		<cfset basicInformations = model("document").getBasicInformations(workflow.documentid) />
		
		<!--- Pobieram informację o ilości podpiętych załącnzików --->
		<cfset numberOfAttachments = model("document_attachment").pobierzIloscPlikow(workflow.documentid) />
		
		<!--- Pobieram wszystkie kroki obiegu dokumentu. --->
		<cfset workflowSteps = model("workflowGetUserStep").getSteps(
			workflowid = params.key) />

		<!--- Pobieram listę MPK i Projekt --->
		<cfset workflowDescription = model("workflowStepDescription").getDescription(
			workflowid = params.key) />

		<!--- Typy dokumentów --->
		<cfset types = model("type").getTypes() />
		
		<!--- Kategorie faktur ---> 
		<cfset categories = model("tree_groupworkflowcategory").getCategories(session.user.id) />

		<cfset workflowStepStatuses = model("workflowStepStatuses").findAll() />

		<cfset usesLayout(false) />

	</cffunction>

	<!---
		13.05.2013
		Okienko informacyjne przygotowane na prośbę Controllingu.
	--->
	<cffunction
		name="tooltip"
		hint="Okienko zawierające listę MPKów, projektów i kwot">

		<cfset description = model("workflowStepDescription").findAll(where="workflowid=#params.key#",include="mpk,project") />

	</cffunction>

	<cffunction
		name="autocompleteMpk"
		hint="Metoda zwracająa listę mpków do podpowiedzi."
		description="Dane są zwracane w postaci JSON. JavaScript parsuje wyniki">

		<!---
			24.04.2013
			Pobranie listy MPKów do autocomplete.
			Metode używam w nowym widoku opisywania faktur.
		--->

		<cfset json = model("mpk").getMpks(
			search = params.search) />

		<cfset renderWith(data="json",template="json",layout=false) />

	</cffunction>

	<cffunction
		name="updateMpk"
		hint="Aktualizuje wartość MPKu opisującego fakturę."
		description="AKtualizuję wartość MPKu opisującego fakturę. Metoda
				wyszukuje MPK w lokalnej bazie. Jeżeli go nie ma to dodaje i
				zwraca ID. Jeżeli jest to zwracam od razu ID.">

		<!---
			24.04.2013
			Aktualizacja wartości pola MPK opisującego fakturę.
		--->
		<cftry>
			<cfset myMpk = model("workflowStepDescription").updateMpk(
				mpk = params.field_value,
				id = params.id) />

			<cfset json = {status = "OK"} />
			<cfset renderWith(data="json",template="json",layout=false) />

			<cfcatch type="any">

				<cfset sender = APPLICATION.cfc.email.init() />
			
				<cfsavecontent 
					variable="myMessage">
					<cfdump var="#cfcatch#" />
				</cfsavecontent>
			
				<cfset sender.setTo(
					users=model("user").findAll(where="id=2")
				).setSubject(subject="Błąd przy opisywaniu faktury").setBody(body=myMessage).send() />
	
				<cfset json = {status = "ERROR"} />
				<cfset renderWith(data="json",template="json",layout=false) />

			</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="autocompleteProject"
		hint="Autouzupełnianie projektów."
		description="Metoda pobierająca listę projektów do autouzupełnienia
				przy opisywaniu faktury">

		<!---
			24.04.2013
			Pobranie listy Projektów do autocomplete.
			Metode używam w nowym widoku opisywania faktur.
		--->

		<cfset json = model("project").getProjects(
			search = params.search) />

		<cfset renderWith(data="json",template="json",layout=false) />

	</cffunction>

	<cffunction
		name="updateProject"
		hint="Aktualizuje projekt opisujący fakturę.">

		<cftry>
			<cfset myProject = model("workflowStepDescription").updateProject(
				project = params.field_value,
				id = params.id) />

			<cfset json = {status = "OK"} />
			<cfset renderWith(data="json",template="json",layout=false) />

			<cfcatch type="any">

				<cfset json = {status = "ERROR"} />
				<cfset renderWith(data="json",template="json",layout=false) />

			</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="updatePrice"
		hint="Aktualizuje kwotę netto opisującą fakturę">

		<cftry>

			<cfset price = model("workflowStepDescription").updatePrice(
				price = params.field_value,
				id = params.id) />

			<cfset json = {status = "OK"} />
			<cfset renderWith(data="json",template="json",layout=false) />

			<cfcatch type="any">

				<cfset json = {status = "ERROR"} />
				<cfset renderWith(data="json",template="json",layout=false) />

			</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="updateDescription"
		hint="Autozapisywanie notki dekretacyjnej" >

		<cftry>

			<cfset description = model("workflowStep").updateDescription(
				id = params.workflowstepid,
				description = params.content) />

			<cfset json = {status = "OK"} />
			<cfset renderWith(data="json",template="json",layout=false) />

		<cfcatch type="any">
			
			<cfmail
				to="admin@monkey.xyz"
				from="Zapisanie opisu faktury - Monkey<intranet@monkey.xyz>"
				replyto="#get('loc').intranet.email#"
				subject="Zapisanie opisu faktury"
				type="html">
					
				<cfdump var="#cfcatch#" />
				<cfdump var="#session#" />

			</cfmail>
			
			<cfset json = {status = "Błąd przy zapisaniu opisu. Przed chwilą dostałem maila i rozwiązuję problem :)"} />
			<cfset renderWith(data="json",template="json",layout=false) />

		</cfcatch>

		</cftry>

	</cffunction>

	<cffunction
		name="validateInvoiceExistence"
		hint="Sprawdzanie, czy faktura o takim numerze jest już dodana" >

		<cfset json = model("workflow").findSimilarInstance(
			logo = params.logo, <!--- numer logo kontrahenta --->
			invoice = params.invoice, <!--- numer zewnętrzny faktury --->
			nazwa1 = params.nazwa1, <!--- nazwa1 kontrahenta --->
			nip = params.nip <!--- numer nip kontrahenta --->) />
		<cfset json = QueryToStruct(Query=json) />
		<cfset renderWith(data="json",template="json",layout=false) />

	</cffunction>

	<cffunction
		name="widgetUserWorkflow"
		hint="Widget prezentujący listę ostatnich 12 faktur przypisanych użytkownikowi"
		description="Lista ostatnich 12 faktur przypisanych do użytkownika.
			Widget zastępuje standardową listę z fakturami, która była dostępna
			w starej wersji interfejsu.">

		<!---
			9.04.2013
			Widget z listą faktur przypisanych do użytkownika.
			Docelowo trzeba dorobić paginację z widgecie i wyświetlać go w
			cfdiv aby lista odświeżała się w ramce bez przeładowania.
		--->

		<cfset qUWidgets = model("workflow").widgetUserWorkflow(userid = session.user.id) />

		<cfset renderWith(data="qUWidgets",layout=false) />

	</cffunction>

	<!---
		20.05.2013
		Automatyczny obieg dokumentów zrobiony na prośbę Patrycjusza.
		Do metody musi być przekazany ID obiegu dokumentów!
		Obieg działa następująco:

		FV ->
		-> Sekretariat (skan) ->
		-> odpowiedni użytkownik DH ->
		-> jeżeli MPK 201 i projekt C99999 to po 47 min auto-zatwierdzenie
		Controlling (Mateusz Synoradzki) ( jeżeli MPK i Projekt inny niż
		wymieniony to normalny obieg ręczny) ->
		-> po 43 min auto-zatwierdzenie Artur Czerniejewski ->
		-> po 44 min auto-zatwierdzenie Małgorzata Kubisiak ->
		-> po 53 min auto-zatwierdzenie Maciej Szturemski i proces się zamyka
	--->
	<cffunction
		name="automator"
		hint="Metoda automatycznego obiegu dokumentów">

		<cfif not StructKeyExists(params, "key")>
			<cfabort />
		</cfif>

		<!---
			Pobieram wszystkie definicje automatycznego obiegu dokumentów.
		--->
		<cfset myAutomators = model("workflow_automator").getAutomators() />



		<cfabort />

	</cffunction>

	<!---
		15.04.2013
		Raport do widgetu, który prezentuje ilość na każdym etapie.
		Widget ma być dostępny głównie dla Zarządu.
	--->
	<cffunction
		name="widgetWorkflowByStep"
		hint="Liczba faktur na każdym z etapów"
		description="Lista faktur dodanych na każdym etapie. Widget ma być
				dostępny głównie dla Zarządu.">

		<cfset qSWorkflows = model("workflow").widgetWorkflowByStep() />

		<cfset renderWith(data="qSWorkflows",layout=false) />

	</cffunction>

	<!---
		16.04.2013
		Raport do widgetu, który prezentuje ilość faktur przypisaną do pracownika
		departamentu. Widget jest dostępny dla dyrektorów aby mieli wgląd w faktury,
		które są aktualnie w ich departamencie.
	--->
	<cffunction
		name="widgetWorkflowByDepartmentMember"
		hint="Liczba faktur przypisana do pracownika departamentu"
		description="Lista faktur przypisana do pracownika departamentu.
			Metoda generuje widget widoczny dla dyrektorów.">

		<cfset qWorkflow = model("workflow").widgetWorkflowByDepartmentMember(
			userid = session.user.id) />

		<cfset renderWith(data="qWorkflow",layout=false) />

	</cffunction>

</cfcomponent>