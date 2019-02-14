<cfcomponent
	extends="Controller">

	<cffunction
		name="init">

		<cfset super.init() />
		<cfset filters(through="privilege",type="before") />
		<cfset filters(through="loadJS",type="before",only="getInstanceForm") />

	</cffunction>

	<cffunction
		name="privilege"
		hint="Nadanie uprawnień do nieruchomości">

		<!---<cfif not StructKeyExists(session, "placestepprivileges") OR
			not StructKeyExists(session, "placeformprivileges") OR
			not StructKeyExists(session, "placecollectionprivileges") OR
			not StructKeyExists(session, "placephototypeprivileges") OR
			not StructKeyExists(session, "placefiletypeprivileges") OR
			not StructKeyExists(session, "placereportprivileges")>

			<cfset super.modulePlacePrivileges() />

		</cfif>--->
		
		<cfset usesLayout(template="/layout") />

	</cffunction>

	<cffunction
		name="loadJS">

		<!---
			Dodaje obsługę autozapisywania pól formularza.
		--->
		<cfset APPLICATION.bodyImportFiles &= ",autosave" />

	</cffunction>

	<cffunction
		name="index"
		hint="Lista nieruchomości"
		description="Metoda generująca listę nieruchomości w systemie. Nieruchomości są wyświetlane na podstawie uprawnień użytkownika.">

		<!---
			TODO
			5.10.2012
			Dorobić poziomy uprawnień do wyświetlania nieruchomości.
		--->

		<cfparam name="status" type="numeric" default="1" />
		<cfparam name="stepid" type="any" default="0" />
		<cfparam name="page" type="numeric" default="1" />
		<cfparam name="elements" type="numeric" default="25" />
		<cfparam name="instancereasonid" type="numeric" default="0" />
		<cfparam name="placesearch" type="string" default="" />
		<cfparam name="sort" type="string" default="desc" />
		<cfparam name="step_order" type="string" default="desc" />
		<cfparam name="destination" type="string" default="0" />

		<!---
			Sprawdzam, czy przekazano odpowiednie dane do filtrowania.
		--->
		<cfif structKeyExists(session, "places_filter")>
			<cfset status = session.places_filter.status />
		</cfif>
		
		<cfif structKeyExists(session, "places_filter") and
			structKeyExists(session.places_filter, "stepid")>
			<cfset stepid = session.places_filter.stepid />
		</cfif>

		<cfif structKeyExists(session, "places_filter")>
			<cfset instancereasonid = session.places_filter.instancereasonid />
		</cfif>

		<cfif structKeyExists(session, "places_filter")>
			<cfset placesearch = session.places_filter.placesearch />
		</cfif>
		
		<cfif structKeyExists(session, "places_filter") and
			structKeyExists(session.places_filter, "sort")>
			<cfset sort = session.places_filter.sort />
		</cfif>
		
		<cfif structKeyExists(session, "places_filter") and
			structKeyExists(session.places_filter, "step_order")>
			<cfset step_order = session.places_filter.step_order />
		</cfif>
		
		<cfif structKeyExists(session, "places_filter") and
			structKeyExists(session.places_filter, "destination")>
			<cfset destination = session.places_filter.destination />
		</cfif>

		<cfif StructKeyExists(params, "statusid")>
			<cfset status = params.statusid />
		</cfif>

		<cfif structKeyExists(params, "stepid") and Len(params.stepid)>
			<cfset stepid = params.stepid />
		</cfif>

		<cfif structKeyExists(params, "page")>
			<cfset page = params.page />
		</cfif>

		<cfif structKeyExists(params, "elements")>
			<cfset elements = params.elements />
		</cfif>

		<cfif structKeyExists(params, "instancereasonid")>
			<cfset instancereasonid = params.instancereasonid />
		</cfif>

		<cfif structKeyExists(params, "placesearch")>
			<cfset placesearch = params.placesearch />
		</cfif>
		
		<cfif structKeyExists(params, "sort")>
			<cfset sort = params.sort />
		</cfif>
		
		<cfif structKeyExists(params, "step_order")>
			<cfset step_order = params.step_order />
		</cfif>
		
		<cfif structKeyExists(params, "destination")>
			<cfset destination = params.destination />
		</cfif>

		<!---
			Zapisuje ustawienia paginacji w sesji
		--->
		<cfset session.places_filter = {
			status		=	status,
			stepid		=	stepid,
			page		=	page,
			elements	=	elements,
			instancereasonid	=	instancereasonid,
			placesearch	=	placesearch,
			sort 		= sort,
			step_order 	= step_order,
			destination	=	destination 
		} />
		
		<cfinvoke
			component="controllers.Tree_groupusers"
			method="checkUserTreeGroup"
			returnvariable="priv" >

			<cfinvokeargument
				name="groupname"
				value="Wszystkie nieruchomości" />

		</cfinvoke>

		<cfif priv is true>
			
			<cfset places = model("place_instance").getAllPlaces(
				statusid			=	status,
				stepid				=	stepid,
				page				=	page,
				elements			=	elements,
				instancereasonid	=	instancereasonid,
				placesearch			=	placesearch,
				sort 				= 	sort,
				step_order 			= 	step_order,
				destination 		= 	destination) />

			<cfset myplaces_count 	= model("place_instance").getAllPlacesCount(
				statusid			=	status,
				stepid				=	stepid,
				instancereasonid	=	instancereasonid,
				placesearch			=	placesearch,
				destination 		= 	destination) />
			
		<cfelse>
			
			<cfset places = model("place_instance").getPlaces(
				statusid 			= status,
				userid 				= session.user.id,
				stepid				= stepid,
				page 				= page,
				elements 			= elements,
				instancereasonid 	= instancereasonid,
				placesearch 		= placesearch,
				sort 				= sort,
				step_order 			= step_order,
				destination			= destination) />
			
			<!---<cfset places = model("place_instance").getAllPlaces(
				statusid		=	status,
				userid			=	session.user.id,
				stepid			=	step,
				page			=	page,
				elements		=	elements,
				instancereasonid	=	instancereasonid,
				placesearch		=	placesearch,
				sort = sort,
				step_order = step_order) />--->

			<!---<cfset myplaces_count = model("place_instance").getAllPlacesCount(
				statusid		=	status,
				stepid			=	step,
				userid			=	session.userid,
				instancereasonid	=	instancereasonid,
				placesearch		=	placesearch) />--->
				
			<cfset myplaces_count = model("place_instance").getPlacesCount(
				statusid			=	status,
				stepid				=	stepid,
				userid				=	session.userid,
				instancereasonid	=	instancereasonid,
				placesearch			=	placesearch,
				destination			=	destination) />

		</cfif>

		<cfset stats = model("place_instance").getStats() />
		<cfset steps = model("place_step").getSepsToSelectBox() />
		<cfset reasons = model("place_instancereason").findAll() />
		<cfset selectBoxValues = model("place_fieldvalue").getValues(fieldid = 167) />
		
		<cfif IsDefined("URL.sort")>
			<cfset renderPartial(partial="_place_index_table") />
		</cfif>

	</cffunction>

	<cffunction name="add" hint="Dodanie nowej nieruchomości">

		<cfset myinstance = model("place_instance").New() />
		<cfset myinstance.userid = session.userid />
		<cfset myinstance.instancecreated = Now() />
		<cfset myinstance.save(callbacks=false) />
		
		<!--- 
			W osobnym wątku uruchamiam tabelkę, która 
			przebudowywuje tabele cache nieruchomości 
		--->
		<cfthread action="run" name="t#TimeFormat(Now(), 'HHmmss')#"> 
			<cfinvoke component="controllers.Unrestricted" method="cacheNieruchomosci" rturnvariable="cacheNieruchomosci" >
			</cfinvoke>
		</cfthread> 

		<!--- Wyszukuje domyślny formularz, który ma się pojawić po dodaniu nowej nieruchomości --->
		<cfset default_form = model("place_form").findOne(where="def=1") />
		<cfif StructIsEmpty(default_form)>

			<cfset redirectTo(controller="place_instances",action="index",success="Nowa nieruchomość została dodana") />

		<cfelse>

			<!--- Jeżeli istnieje domyślny formularz, to sprawdzam, czy był on przypisany do jakiegoś kroku obiegu nieruchomości --->
			<cfset step = model("place_stepform").count(where="formid=#default_form.id#") />
			<!--- Jeżeli domyślny formularz nie jest przypisany do zadnego kroku, to przekierowuje na listę wszystkich nieruchomości --->
			<cfif not step gt 0>
				<cfset redirectTo(controller="place_instances",action="index",success="Nowa nieruchomość została dodana pomyślnie") />
			</cfif>

			<!--- Przekierowanie na stronę z domyślnym formularzem --->
			<cfset redirectTo(controller="Place_instances",action="getInstanceForm",key=myinstance.id,params="formid=#default_form.id#") />

		</cfif>

	</cffunction>

	<cffunction
		name="getSteps"
		hint="Pobranie listy kroków obiegu nieruchomości">

		<cfset placesteps = model("place_instance").getInstanceWorkflow(instanceid=params.key) />
		<cfset instanceId = params.key />
		<cfset usesLayout(false) />

	</cffunction>

	<!---
		Do metody jest przekazany ID wpisu zawierającego krok obiegu nieruchomości.
		Na podstawie tego ID muszę dopiero pobrać wszystkie dane instancji.
	--->
	<cffunction
		name="getInstanceStepElements"
		hint="Pobranie listy elementów nieruchomości dostępnych dla danego etapu nieruchomości">
		
		<cfinclude template="../views/include/place_privileges.cfm" /> <!--- Cache z uprawnieniami --->

		<cfset myworkflow = model("place_workflow").findByKey(params.key) />
		<cfset forms = model("place_form").getFormsByStepSummary(instanceid=myworkflow.instanceid,stepid=myworkflow.stepid) />
		<cfset collections = model("place_collection").getCollectionsByStepSummary(instanceid=myworkflow.instanceid,stepid=myworkflow.stepid) />
		<cfset files = model("place_file").getFilesByStepSummary(instanceid=myworkflow.instanceid,stepid=myworkflow.stepid) />
		<cfset photos = model("place_photo").getPhotosByStepSummary(instanceid=myworkflow.instanceid,stepid=myworkflow.stepid) />
		<cfset reports = model("place_report").getReportsByStepSummary(instanceid=myworkflow.instanceid,stepid=myworkflow.stepid) />
		
		<cfset defaultForms = model("place_stepform").getDefaultForms( 
			instanceid = myworkflow.instanceid,
			stepid = myworkflow.stepid ) />
			
		<cfset defaultReports = model("place_report").getDefaultReports(
			instanceid = myworkflow.instanceid,
			stepid = myworkflow.stepid
		) />

		<cfset usesLayout(false) />

		<cfif not checkAccess(privileges=myPrivilege.placestepprivileges.rows,itemname="stepid",itemvalue=myworkflow.stepid,accessname="readprivilege") >
			<cfset renderWith(data="",template="/place_step_elements_access") />
		</cfif>

	</cffunction>

	<!---
		Metoda generująca formularz dla nieruchomości.
		TODO
		Dorobić okienka z podpowiedziami.
	 --->
	 <cffunction
	 	name="getInstanceForm"
		hint="Metoda generująca formularz do nieruchomości" >

		<cfset myform = model("place_form").findByKey(params.formid) />
		<cfset myfields = model("place_form").getFormFields(instanceid=params.key,formid=params.formid) />
		<!--- Tworzę listę z opcjami do selectbox --->
		<cfset myoptions = StructNew() />
		<cfloop query = myfields>
			<cfset myoptions[fieldid] = model("place_fieldvalue").getValues(fieldid=fieldid) />
		</cfloop>

		<cfparam name="myinstance" default="#params.key#" type="any" />

		<cfif StructKeyExists(params, "format")>

			<cfset myinstance = model("place_instance").getInstanceById(instanceid=params.key) />
			<cfset mynotes = model("place_form").getFormNotes(formid=params.formid,instanceid=params.key) />
			<cfset myuser = model("user").findByKey(myinstance.userid) />
			<cfset renderWith(data="myform,myfields,myoptions,myinstance,myuser",layout=false) />

		</cfif>
		
		<cfif structKeyExists( params, "window" )>
			<cfset renderWith(data="myform,myfields,myoptions,myinstance",layout="/layout_cfwindow") />
		</cfif>

	 </cffunction>

	 <!---
	 	Zapisywanie pól formularza.
	 --->
	 <cffunction
	 	name="submitForm"
		hint="Zapisanie formularza" >

	 	<cfloop collection="#params.field#" item="i">
	 		<cfset myfield = model("place_instanceform").findByKey(i) />
			<cfset myfield.update(
				formfieldvalue=params.field[i],
				userid=session.userid,
				callbacks=false) />
	 	</cfloop>

		<!---
			Po zapisaniu formularza przekierowuje usera do formularza dodawania komentarza.
		--->
		<cfset redirectTo(controller="Place_forms",action="addFormNote",params="formid=#params.formid#&instanceid=#params.instanceid#") />
		<!---<cfset redirectTo(controller="Place_instances",action="index",success="Formularz został prawidłowo zapisany.") />--->

	 </cffunction>

	 <cffunction
	 	name="autosave"
		hint="Autozapisywanie pól formularza"
		description="Metoda zapisująca na bieżąco dane, wpisane w formularzu">

		<!---
			Sprawdzam, czy przesłano niezbędny parametry do autozapisywania.
		--->
		<cfif StructKeyExists(params, "content") AND StructKeyExists(params, "name")>

			<!---
				W drugim elemencie tablicy powinien być ID pola w
				bazie do aktualizacji.
			--->
			<cfset arrayFieldName = ListToArray(params.name, "-[]") />
			<cfset myField = model("place_instanceform").updateByKey(
				key = arrayFieldName[2],
				formfieldvalue = params.content) />

			<cfset json.status = "ok" />

		<cfelse>

			<cfset json.status = "Not enough parameters passed to method autosave." />

		</cfif>

		<cfset renderWith(data="json",template="/json",layout=false) />

	 </cffunction>

	 <!---
	 	Bardzo ważna procedura akceptująca etap obiegu nieruchomości i tworząca kolejny krok.
	 --->
	 <cffunction
	 	 name="acceptStep" >

	 	<!---
	 		Jako parametr jest przesłany id wpisu z obiegiem dokumentu. Zmiana kroku odbywa się w kilku etapach:
	 		- pobieram dany krok obiegu nieruchomości
	 		- pobieram wpis z następnym i poprzednim krokiem obiegu nieruchomości
	 		- aktualizuje dany wpis obiegu nieruchomości
	 		- dodaje nowy krok obiegu nieruchomości
	 	--->
	 	<!--- Krok obiegu nieruchomości --->
	 	<cfset myworkflow = model("place_workflow").findByKey(params.key) />

		<!--- Dane kroku obiegu nieruchomości --->
		<cfset mysteps = model("place_step").findByKey(myworkflow.stepid) />

		<!---
			25.10.2012
			Generuje formularz, w którym dodaję notatkę oraz wybieram powód (jeżeli go nie ma to nie podane).
			Dodatkowo wybieram status z listy dostępnych.
		--->
		<cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#myworkflow.instanceid#") />

	 </cffunction>

	 <!---
	 	25.10.2012
		Akceptacja kroku obiegu nieruchmości.
	--->
	<cffunction
		name="actionAcceptStep"
		hint="Akceptacja kroku obiegu nieruchomości">

		<!--- Krok obiegu nieruchomości --->
	 	<cfset myworkflow = model("place_workflow").findByKey(params.key) />
		<cfset myworkflow.update(
			stop=Now(),
			statusid=2,
			workflownote=params.workflownote,
			user2=session.userid,
			callbacks=false) />

		<!--- Dane kroku obiegu nieruchomości --->
		<cfset mysteps = model("place_step").findByKey(myworkflow.stepid) />

		<!---
			Sprawdzam, czy istnieje kolejny krok obiegu nieruchomości.
			Jeżeli krok istnieje to dodaje wpis do tabeli z obiegiem. Jeżeli
			krok nie istnieje to nic nie dodaje.
		--->
		<cfif Len(mysteps.next) >

			<cfset newworkflow = model("place_workflow").New() />
			<cfset newworkflow.start = Now() />
			<cfset newworkflow.userid = session.userid />
			<cfset newworkflow.instanceid = myworkflow.instanceid />
			<cfset newworkflow.stepid = mysteps.next />
			<cfset newworkflow.statusid = 1 />
			<cfset newworkflow.save(callbacks=false) />
			
			<!---
				Specyficzne akcje dla każdego etapu nieruchomości.
				Akcje są wykonywane dopiero po dodaniu nowego etapu nieruchomości.
			--->
			<cfswitch expression="#mysteps.next#" >
				<cfcase value="7" > <!--- Etap Komitet --->
					
					<!--- Wysyłanie specjalnych maili, że nieruchomość trafiła na etap Komitetu --->
					<cfthread action="run" name="#mysteps.next#-instanceStep" priority="LOW" >
						<!--- Wysyłam maile do odpowiednich osób --->
						<cfset users = model("tree_groupuser").getGroupByNameUsers(groupName="Etap komitetu") />
						<cfset sender = APPLICATION.cfc.email.init() />
						
						<cfsavecontent variable="myMessage">
							<!---<cfprocessingdirective pageencoding="utf-8" />--->
							<cfoutput>
								<html>
								<head>
								<title>NIERUCHOMOŚCI - Monkey</title>
								<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
								<style type="text/css"> 
									body { background: transparent url("../images/page.png"); font: normal 12px "Lucida Sans Unicode", sans-serif; color: ##444; }
									a { color: ##3B5998; text-decoration: none; }
									.clear { float: none; clear: both; }
									dl { margin: 0; }
									dl dt { background: ##d7d7d7; color: ##000; font-weight: normal; float: left; padding: 5px; width: 150px; clear: both; margin: 0 10px 0 0; }
									dl dd { float: left; padding: 5px 0; margin: 0 0 1px 10px; width: 150px; }
									dl .header { font-weight: bold; }
								</style>
								</head>
								<body>
								Witaj,<br />
								Na etapie Komitetu pojawiła się nowa nieruchomość.
								<br /><br />
								Pozdrawiamy,<br />
								Monkey Group
								</body>
								</html>
							</cfoutput>	
						</cfsavecontent>
						
						<cfloop query="users">
							<cfset sender.setTo(
								users=model("user").findAll(where="id=#userid#")
							).setSubject(subject="Nieruchomość na etapie Komitetu").setBody(body=myMessage).send() />
						</cfloop>
						
					</cfthread>
					
				</cfcase>
			</cfswitch>
			

		</cfif>

		<cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#myworkflow.instanceid#") />
		<cfset myemail = model("email").placeAcceptStep(mystep=mysteps,myinstance=myinstance,myworkflow=myworkflow) />

		<!---
	 		6.11.2012
	 		Wysyłanie wiadomości email z informacją o zmianie statysu nieruchomosci.
	 	--->
	 	<!---<cfset emailusers = model("place_instance").getUsers(myworkflow=instanceid) />
		<cfset emails = model("email").changePlaceStatus(users=emailusers,oldstep=myworkflow,newstep=newworkflow) />--->

		<cfset redirectTo(controller="Place_instances",action="index",success="Etap został pomyślnie zamknięty.") />

	</cffunction>

	 <!---
	 	Metoda odrzucająca krok obiegu nieruchomości
	 	- pobieram dany krok obiegu nieruchomości
	 	- aktualizuje status kroku
	 	- przenoszę do listy wszystkich nieruchomości
	 --->
	 <cffunction
	 	 name="refuseStep"
		 hint="Metoda odrzucająca dany krok obiegu nieruchomości" >


		 <!---
		 	25.10.2012
		 	Dodanie powodu odrzucenia lokalizacji.
		 	Po odrzuceniu lokalizacja nie jest widoczna na liście nieruchomości w obiegu!
		 --->
		 <cfset myworkflow = model("place_workflow").findByKey(params.key) />
		 <cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#myworkflow.instanceid#") />
		 <cfset myreasons = model("place_instancereason").findAll() />

	 </cffunction>

	 <cffunction
	 	name="actionRefuseStep"
		hint="Odrzucenie kroku obiegu nieruchomości" >

	 	<cfset myworkflow = model("place_workflow").findByKey(params.key) />
		<cfset myworkflow.update(
			instancereasonid=params.instancereasonid,
			workflownote=params.workflownote,
			statusid=3,
			stop=Now(),
			user2=session.userid,
			callbacks=false) />

		<cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#myworkflow.instanceid#") />
		<cfset myreason = model("place_instancereason").findByKey(params.instancereasonid) />
		<cfset mysteps = model("place_step").findByKey(myworkflow.stepid) />
		<cfset myemail = model("email").placeRefuseStep(
			mystep=mysteps,
			myinstance=myinstance,
			myworkflow=myworkflow,
			myreason=myreason) />

		<cfset redirectTo(controller="Place_instances",action="index",success="Nieruchomość została odrzucona.") />

	 </cffunction>

	 <cffunction
	 	name="getInstanceUsers"
		hint="Metoda listująca wszystkich użytkowników, którzy brali udział w obiegu nieruchomości">

		<cfset users = model("place_instance").getUsers(instanceid=params.key) />

	 </cffunction>

	 <cffunction
	 	name="delete"
		hint="Usunięcie instancji nieruchomości z bazy danych. Usunięcie jest permanentne">

		<!---
			Krok obiegu nieruchomości.
			Jest to niezbędne aby pobrać ID instancji a następnie usuwać wszystko co jest z nim związane...
		--->
	 	<cfset myworkflow = model("place_workflow").findByKey(params.key) />

		<!---
			Usunięcie nieruchomości
		--->
		<cfthread action="run" name="deletePlaceInstance" priority="HIGH" >
			
			<cfset mysteps = model("place_instance").del(instanceid=myworkflow.instanceid) />
			
		</cfthread>

		<cfset redirectTo(controller="Place_instances",action="index",success="Nieruchomość jest przetwarzana przez system. Może to potrwać kilka minut.") />

	 </cffunction>
	 
	 <cffunction
	 	name="unDelete"
		hint="Przywrócenie usuniętej nieruchomości">
			
		<cfthread action="run" name="undelete" priority="NORMAL">
			<cftry>
				
				<cfset undeleted = model("place_instance").unDel(instanceid = params.key) />
				<cfset sender = APPLICATION.cfc.email.init() />
			
				<cfsavecontent 
					variable="myMessage">
					
					<cfprocessingdirective pageencoding="utf-8" />
					<cfoutput>
					<html>
					<head>
						<title>NIERUCHOMOŚCI - Monkey</title>
						<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
						<style type="text/css"> 
							body { background: transparent url("../images/page.png"); font: normal 12px "Lucida Sans Unicode", sans-serif; color: ##444; }
							a { color: ##3B5998; text-decoration: none; }
							.clear { float: none; clear: both; }

							dl { margin: 0; }
							dl dt { background: ##d7d7d7; color: ##000; font-weight: normal; float: left; padding: 5px; width: 150px; clear: both; margin: 0 10px 0 0; }
							dl dd { float: left; padding: 5px 0; margin: 0 0 1px 10px; width: 150px; }
							dl .header { font-weight: bold; }
						</style>
					</head>
					<body>
		
						Witaj,<br />
						Nieruchomość została przywrócona.
						<br/><br/><br/>	
						Pozdrawiamy,<br />
						Monkey Group
		
					</body>
					</html>
					</cfoutput>	
				</cfsavecontent>
			
				<cfset sender.setTo(users=model("user").findAll(where="id=#session.user.id#")).setSubject(subject="Przywrócenie nieruchomości").setBody(body=myMessage).send() />
				
				<cfcatch type="any">
					
					<cfset sender = APPLICATION.cfc.email.init() />
			
					<cfsavecontent 
						variable="myMessage">
							
						<cfprocessingdirective pageencoding="utf-8" />
						<cfoutput>
						<html>
						<head>
							<title>NIERUCHOMOŚCI - Monkey</title>
							<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
							<style type="text/css"> 
								body { background: transparent url("../images/page.png"); font: normal 12px "Lucida Sans Unicode", sans-serif; color: ##444; }
								a { color: ##3B5998; text-decoration: none; }
								.clear { float: none; clear: both; }

								dl { margin: 0; }
								dl dt { background: ##d7d7d7; color: ##000; font-weight: normal; float: left; padding: 5px; width: 150px; clear: both; margin: 0 10px 0 0; }
								dl dd { float: left; padding: 5px 0; margin: 0 0 1px 10px; width: 150px; }
								dl .header { font-weight: bold; }
							</style>
						</head>
						<body>
			
							Witaj,<br />
							Błąd przy przywracaniu nieruchomości.
							<br/><br/><br/>	
							Pozdrawiamy,<br />
							Monkey Group
		
						</body>
						</html>
						</cfoutput>	
					</cfsavecontent>
			
					<cfset sender.setTo(users=model("user").findAll(where="id=#session.user.id#")).setSubject(subject="Błąd przy przywracaniu nieruchomości").setBody(body=myMessage).send() />
					
				</cfcatch>
			
			</cftry>
		</cfthread>
			
		<cfset redirectTo(controller="Place_instances",action="listDeleted",success="Nieruchomość jest przetwarzana przez system.") />
			
	 </cffunction>
	 
	 <cffunction
	 	name="listDeleted"
		hint="Lista usuniętych nieruchomości z możliwością ich przywrócenia."
		description="Przywracanie nieruchomości odbywa się z osobnym wątku.
				 Po przywróceniu instancji jest wysyłany email do osoby, która
				 przywracała z informacją, że cała operacja przebiegła prawidłowo.">
		
		<cfset steps = model("place_step").getSepsToSelectBox() />
		<cfset places = model("place_instance").getDeletedPlaces() />
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset renderPartial(partial="_place_index_table") />
		</cfif>
		
	 </cffunction>

	 <cffunction
	 	name="getReason"
		hint="Widok generujący powód odrzucenia nieruchomości">

		<cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#params.key#") />
		<cfset myuser = model("user").findByKey(myinstance.rejectuserid) />
		<cfset mystatus = model("place_status").findByKey(myinstance.instancestatusid) />
		<cfset myreason = model("place_instancereason").findByKey(myinstance.instancereasonid) />


	 </cffunction>

	 <cffunction
	 	name="archiveStep"
		hint="Pobranie formularza przekazania do archiwum">

		<cfset myworkflow = model("place_workflow").findByKey(params.key) />
		<cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#myworkflow.instanceid#") />
		<cfset myreasons = model("place_instancereason").findAll() />

	 </cffunction>

	 <cffunction
	 	name="actionArchiveStep"
		hint="Przesłanie nieruchomości do archiwum.">

		<cfset myworkflow = model("place_workflow").findByKey(params.key) />
		<cfset myworkflow.update(
			instancereasonid=params.instancereasonid,
			workflownote=params.workflownote,
			statusid=5,
			stop=Now(),
			user2=session.userid,
			callbacks=false) />

		<cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#myworkflow.instanceid#") />
		<cfset myreason = model("place_instancereason").findByKey(params.instancereasonid) />
		<cfset mysteps = model("place_step").findByKey(myworkflow.stepid) />
		<cfset myemail = model("email").placeArchiveStep(
			mystep=mysteps,
			myinstance=myinstance,
			myworkflow=myworkflow,
			myreason=myreason) />

		<cfset redirectTo(controller="Place_instances",action="index",success="Nieruchomość została przekazana do archiwum.") />

	 </cffunction>

	 <!---
	 	10.01.2013
	 	Pobieranie całęgo obiegu nieruchomości i generowanie formularza.
	 	Metoda jest podsumowaniem danego elementu. Komentarze muszą być posortowane.
	 --->
	 <cffunction name="getSummary" hint="Pobranie podsumowania nieruchomości." description="">
		<cfif not structKeyExists(params, "format")>
			<cfset redirectTo(controller="Place_instances",action="index") />
		<cfelse>
			<cfset placesteps = model("place_instance").getInstanceWorkflow(instanceid=params.key) />
			<cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#params.key#") />
			<cfset myuser = model("user").findByKey(myinstance.userid) />
			<cfset notatkiFormularzy = model("place_instanceform").getFormNotes(params.key) />
			<cfset renderWith(data="placesteps,myinstance",layout="false") />
		</cfif>
	 </cffunction>

	 <!---
	 	6.02.2013
	 	Metoda przywracająca nieruchomość na poprzedni etap
	 --->
	 <cffunction
	 	name="rollback"
		hint="Metoda przywracająca nieruchomość do poprzedniego etapu."
		description="Przywrócenie nieruchomości odbywa się poprzez zmianę
			statusu instancji.">

		<!---
			Pobieram instancje nieruchomości o odpowiednim ID i odpowiednim statusie.
		--->
		<cfset my_place_instance = model("trigger_place_instance").findOne(where="instanceid=#params.key# AND instancestatusid <> 1") />
		<cfset my_place_workflow = model("place_workflow").findOne(where="instanceid=#params.key#",order="start DESC") />

		<!---
			Aktualizuje informacje o kroku nieruchomości.
		--->
		<cfset wrkflwUpdate = model("place_workflow").updateByKey(
			key=my_place_workflow.id,
			instancereasonid = 0,
			user2 = "",
			workflownote = "",
			statusid = 1) />
		<!---<cfset my_place_workflow.instancereasonid		=	0 />
		<cfset my_place_workflow.workflownote			=	"" />
		<cfset my_place_workflow.user2					=	"" />
		<cfset my_place_workflow.statusid				=	1 />
		<cfset my_place_workflow.save(callbacks=false) />--->
		
		<!---
			Aktualizuje informacje o instancji nieruchomości.
		--->
		<cfset nstncUpdate = model("trigger_place_instance").updateByKey(
			key = my_place_instance.id,
			instancestatusid = 1,
			instancereasonid = 0,
			rejectreasonid = "",
			rejectnote = "",
			rejectuserid = "",
			rejectdatetime = 0,
			stepid = my_place_workflow.stepid) />
		

		<cfset redirectTo(back=true) />

	 </cffunction>

	 <!---
	 	6.02.2013
	 	Metoda pozwalająca na przeniesienie etapu obiegu nieruchomości. O co chodzi.
	 	Kiedy ktoś stwierdzi, że nieruchomość powinna wrócić na jakiś z poprzednich
	 	etapów, wystarczy, że kliknię w strzałkę a pojawi się formularz
	 	z wyborem nowego etapu, na którym ma byćnieruchomość.
	 --->
	 <cffunction
	 	name="move"
		hint="Metoda pozwalająca na przeniesienie nieruchomości na inny etap">

		<cfset myworkflow = model("place_workflow").findByKey(params.key) />
		<cfset myStep = model("place_step").findByKey(myworkflow.stepid) />
		<cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#myworkflow.instanceid#") />
		<cfset my_steps = model("place_step").findAll(where="ord < #myStep.ord#") />

	 </cffunction>

	 <cffunction
	 	name="actionMove"
		hint="Akcja przenosząca nieruchomość do innego etapu.">

		<cfset newstep = false />

		<!---
			Sprawdzam, czy wybrano krok, do którego ma zostać przeniesiona nieruchomość.
			Jeżeli takiego kroku nie ma to nic nie robię.
		--->
		<cfif structKeyExists(params, "stepid") and Len(params.stepid) >

			<!--- Krok obiegu nieruchomości --->
	 		<cfset myworkflow = model("place_workflow").findByKey(params.key) />

			<cfset myworkflow.update(
				stop=Now(),
				statusid=2,
				workflownote=params.workflownote,
				user2=session.userid,
				callbacks=false) />

			<cfset newstep = model("place_step").findByKey(params.stepid) />

			<cfset newworkflow = model("place_workflow").New() />
			<cfset newworkflow.start = Now() />
			<cfset newworkflow.userid = session.userid />
			<cfset newworkflow.instanceid = myworkflow.instanceid />
			<cfset newworkflow.stepid = newstep.id />
			<cfset newworkflow.statusid = 1 />
			<cfset newworkflow.save(callbacks=false) />

			<cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#myworkflow.instanceid#") />

			<!---
	 			6.11.2012
	 			Wysyłanie wiadomości email z informacją o zmianie statysu nieruchomosci.
	 		--->
			<cfset myemail = model("email").placeMoveStep(new=newstep,myinstance=myinstance,myworkflow=myworkflow) />

		</cfif>

		<cfset redirectTo(controller="Place_instances",action="index",success="Nieruchomość została przekazana do innego etapu.") />

	 </cffunction>
	 
	 <cffunction
	 	name="report"
		hint="Raport z nieruchomości przeznaczony dla centrali">
		
		<cfif isDefined("FORM.FieldNames")> <!--- Formularz został przesłany --->
			
			<cfset myReport = model("place_instance").getReport(
				date_from = params.report_date_from,
				date_to = report_date_to) />
				
			<cfswitch expression="#params.report_output#" >
				
				<cfcase value="xls" >
					<!---<cfset renderWith(data="myReport",layout=false,template="xls") />--->

					<!---
						Create and store the simple HTML data that you want
						to treat as an Excel file.
					--->
					<cfsavecontent variable="strExcelData">
						<cfprocessingdirective pageencoding="utf-8" />
						
						<style type="text/css">
							td, th {
								font-family:Arial;
								font-size: 11pt ;
								}
							th.header {
								background-color: yellow ;
								border-bottom: 0.5pt solid black ;
								}
						</style>
						
						<table>
							<thead>
								<tr>
									<th rowspan="2" class="header">Imię</th>
									<th rowspan="2" class="header">Nazwisko</th>
									<th colspan="5" class="header">Nieruchomości</th>
								</tr>
								<tr>
									<th class="header">Wprowadzone</th>
									<th class="header">Odrzucone</th>
									<th class="header">Archiwum</th>
									<th class="header">Zaakceptowane</th>
									<th class="header">Zaakceptowane warunkowo</th>
								</tr>
							</thead>
							<tbody>
								<cfloop query="myReport">
									<tr>
										<td><cfoutput>#givenname#</cfoutput></td>
										<td><cfoutput>#sn#</cfoutput></td>
										<td><cfoutput>#wprowadzone#</cfoutput></td>
										<td><cfoutput>#odrzucone#</cfoutput></td>
										<td><cfoutput>#archiwum#</cfoutput></td>
										<td><cfoutput>#zaakceptowane#</cfoutput></td>
										<td><cfoutput>#zaakceptowane_warunkowo#</cfoutput></td>
									</tr>
								</cfloop>
							</tbody>
						</table>
 
					</cfsavecontent>
 
					<!---
						Check to see if we are previewing the excel data. This
						will output the HTML/XLS to the web browser without
						invoking the MS Excel applicaiton.
					--->
					<cfif StructKeyExists(URL, "preview")>
 
						<!--- Output the excel data for preview. --->
						<html>
							<head>
								<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
								<title>Excel Data Preview</title>
							</head>
							<body>
								<cfset WriteOutput(strExcelData) />
							</body>
						</html>
						
						<!---
							Exit out of template so that the attachment
							does not process.
						--->
						
						<cfexit />
					</cfif>
					 
					<!---
						ASSERT: At this point, we are definately not previewing the
						data. We are planning on streaming it to the browser as
						an attached file.
					--->
 
 
					<!---
						Set the header so that the browser request the user
						to open/save the document. Give it an attachment behavior
						will do this. We are also suggesting that the browser
						use the name "phrases.xls" when prompting for save.
					--->
					<cfheader
						name="Content-Disposition"
						value="attachment; filename=#DateFormat(Now(), 'dd-mm-yyyy')#_raport_nieruchomosci.xls"
						charset="utf-8" />

					<!---
						There are several ways in which we can stream the file
						to the browser: 
						- Binary variable stream
						- Binary file stream
						- Text stream
						
						Check the URL to see which of these we are going to end
						up using.
					--->
					<cfif StructKeyExists(URL, "text")>
						
					<!---
						We are going to stream the excel data to the browser
						through the standard text output stream. The browser
						will then collect this data and execute it as if it
						were an attachment.
 
						Be careful to reset the content when streaming the
						text as you don't want white-space to be part of the
						streamed data.
					--->
					<cfcontent
						type="application/msexcel"
						reset="true"
						<!--- Write the output. --->
						/>
						<cfset WriteOutput(strExcelData.Trim())
						<!---
							Exit out of template to prevent unexpected data
							streaming to the browser (on request end??).
						--->
						/><cfexit />
						
					<cfelseif StructKeyExists(URL, "file")>
						
						<!---
							We are going to stream the excel data to the browser
							using a file stream from the server. To do this, we
							will have to save a temp file to the server.
						--->
						
						<!--- Get the temp file for streaming. --->
						<cfset strFilePath = GetTempFile(
							GetTempDirectory(),
							"excel_") />
							
						<!--- Write the excel data to the file. --->
						<cffile
							action="WRITE"
							file="#strFilePath#"
							output="#strExcelData.Trim()#" />
							
						<!---
							Stream the file to the browser. By doing this, the
							content buffer is automatically cleared and the file
							is streamed. We don't have to worry about anything
							after the file as no page content is taken into
							account any more.
							
							Additionally, we are requesting that the file be
							deleted after it is done streaming (deletefile). Now,
							we don't have to worry about cluttering up the server.
						--->
						<cfcontent
							type="application/msexcel"
							file="#strFilePath#"
							deletefile="true" />
							
					<cfelse>
						
						<!---
							Bey default, we are going to stream the text as a
							binary variable. By using the Variable attribute, the
							content of the page is automatically reset; we don't
							have to worry about clearing the buffer. In order to
							use this method, we have to convert the excel text
							data to base64 and then to binary.
 
							This method is available in ColdFusion MX 7 and later.
						--->
						<cfcontent
							type="application/msexcel"
							variable="#ToBinary(ToBase64(strExcelData.Trim()))#" />
 
					</cfif>
					
				</cfcase>
				
			</cfswitch>
			
		</cfif>
		
	 </cffunction>
	 
	 <cffunction
	 	name="controllingStep"
		hint="Metoda oznaczająca nieruchomość jako zawieszoną na etapie Controllingu"
		description="Oznaczenie nieruhomości jako zawieszona na etapie 
			Controllingu. Status został dodany na prośbę Wojtka Marka. Źle
			się czuje jak widzi nieruchomości na stoim etapie i nie może ich
			zamknąć">
			
		<!--- Krok obiegu nieruchomości --->
	 	<cfset myworkflow = model("place_workflow").findByKey(params.key) />

		<!--- Dane kroku obiegu nieruchomości --->
		<cfset mysteps = model("place_step").findByKey(myworkflow.stepid) />

		<!---
			25.10.2012
			Generuje formularz, w którym dodaję notatkę oraz wybieram powód (jeżeli go nie ma to nie podane).
			Dodatkowo wybieram status z listy dostępnych.
		--->
		<cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#myworkflow.instanceid#") />
			
		<cfif isDefined("FORM.FIELDNAMES")> <!--- Jeżeli formularz został przesłany --->
			
			<!---<cfset myworkflow = model("place_workflow").findByKey(params.key) />--->
			<cfset myworkflow.update(
				instancereasonid=0,
				workflownote=FORM.workflownote,
				statusid=6,
				stop=Now(),
				user2=session.user.id,
				callbacks=false) />
			
			<!--- Aktualizacja informacji w tabeli trigger_place_instances --->
			<cfset myTriggerPlace = model("trigger_placeinstance").updateOne(
				where="instanceid=#myworkflow.instanceid#",
				instancenote = FORM.WORKFLOWNOTE,
				instancestatusid = 6) />
				
			<!--- Zapisanie historii zmian nieruchomości --->
			<cfset myHistory = model("place_history").new() />
			<cfset myHistory.instanceid =  myworkflow.instanceid />
			<cfset myHistory.statusid = myworkflow.statusid />
			<cfset myHistory.stepid = myworkflow.stepid />
			<cfset myHistory.reasonid = myworkflow.instancereasonid />
			<cfset myHistory.note = myworkflow.workflownote />
			<cfset myHistory.create = Now() />
			<cfset myHistory.save() />
			
			<cfset emails = model("place_instance").getUsers(instanceid=myworkflow.instanceid) />
			<cfset sender = APPLICATION.cfc.email.init() />
			
			<cfsavecontent 
				variable="myMessage">
					
				<cfprocessingdirective pageencoding="utf-8" />
				<cfoutput>
				<html>
				<head>
					<title>NIERUCHOMOŚCI - Monkey</title>
					<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
					<style type="text/css"> 
						body { background: transparent url("../images/page.png"); font: normal 12px "Lucida Sans Unicode", sans-serif; color: ##444; }
						a { color: ##3B5998; text-decoration: none; }
						.clear { float: none; clear: both; }

						dl { margin: 0; }
						dl dt { background: ##d7d7d7; color: ##000; font-weight: normal; float: left; padding: 5px; width: 150px; clear: both; margin: 0 10px 0 0; }
						dl dd { float: left; padding: 5px 0; margin: 0 0 1px 10px; width: 150px; }
						dl .header { font-weight: bold; }
					</style>
				</head>
				<body>
		
					Witaj,<br />
					Nieruchomość, w obiegu której bierzesz udział, zmieniła status. Aby dowiedzieć się szczegółów proszę zalogować się na http://intranet.monkey.xyz i przejść do zakładki Nieruchomości.
					<br />
					<br />
			
					<div class="clear"></div>
			
					<dl class="workflow">
			
						<dt>Ulica i numer</dt>
						<dd>#myinstance.street# #myinstance.streetnumber#</dd>
				
						<dt>Miasto i kod pocztowy</dt>
						<dd>#myinstance.postalcode# #myinstance.city#</dd>
				
						<dt>Dodane przez</dt>
						<dd>#myinstance.givenname# #myinstance.sn#</dd>
				
					</dl>
			
					<div class="clear"></div>
		
					<br /><br />
			
					Pozdrawiamy,<br />
					Monkey Group
		
				</body>
				</html>
				</cfoutput>	
			</cfsavecontent>
			
			
			<cfthread 
				action="run" 
				name="controllingStepSender"
				priority="LOW" >
				
				<cfset sender.setTo(users=emails).setSubject(subject="Zawieszone na etapie Controlling").setBody(body=myMessage).send() />
				
			</cfthread>

			<cfset redirectTo(controller="Place_instances",action="index",success="Został zmieniony status nieruchomości. Powiadomienia są rozsyłane.") />
			
		</cfif>
			
	 </cffunction>
	 
	 <cffunction
	 	name="changeOwner"
		hint="Zmiała autora nieruchomości"
		description="Metoda pozwalająca na zmianę autora nieruchomości">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
				
			<cfthread action="run" name="changeOwnerThread">
				
				<cfset changed = model("place_instance").changeOwner(
					instanceid = FORM.instanceid,
					userid = FORM.userid) />
					
				<cfset sender = APPLICATION.cfc.email.init() />
			
				<cfsavecontent 
					variable="myMessage">
					
					<cfprocessingdirective pageencoding="utf-8" />
					<cfoutput>
					<html>
					<head>
						<title>NIERUCHOMOŚCI - Monkey</title>
						<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
						<style type="text/css"> 
							body { background: transparent url("../images/page.png"); font: normal 12px "Lucida Sans Unicode", sans-serif; color: ##444; }
							a { color: ##3B5998; text-decoration: none; }
							.clear { float: none; clear: both; }

							dl { margin: 0; }
							dl dt { background: ##d7d7d7; color: ##000; font-weight: normal; float: left; padding: 5px; width: 150px; clear: both; margin: 0 10px 0 0; }
							dl dd { float: left; padding: 5px 0; margin: 0 0 1px 10px; width: 150px; }
							dl .header { font-weight: bold; }
						</style>
					</head>
					<body>
		
						Witaj,<br />
						Zmienił się autor nieruchomości.
						<br/><br/><br/>	
						Pozdrawiamy,<br />
						Monkey Group
		
					</body>
					</html>
					</cfoutput>	
				</cfsavecontent>
			
				<cfset sender.setTo(
					users=model("user").findAll(where="id=#session.user.id#")
				).setSubject(subject="Zmiana autora nieruchomości").setBody(body=myMessage).send() />
				
			</cfthread>
			
			<cfset redirectTo(controller="Place_instances",action="index",success="Nieruchomość jest przetwarzana przez system.") />
			
		</cfif>

		<!---
			25.10.2012
			Generuje formularz, w którym dodaję notatkę oraz wybieram powód (jeżeli go nie ma to nie podane).
			Dodatkowo wybieram status z listy dostępnych.
		--->
		<cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#params.key#") />
			
	 </cffunction>
	
	<cffunction name="recallCommittee" access="public" output="false" hint="">

		<!---
			25.07.2013
			Nic nie generuje. Kliknięcie opcji zmiany statusy na komitet odwoławczy
			spowoduje aktualizacje statusów nieruchomości w Intranecie.
		--->
			
		<cfif isDefined("params.key")> <!--- Jeżeli przesłałem id nieruchomości --->
			
			<cfset recallPlace = model("place_instance").recallPlace(params.key) />
			
			<!--- Pobieram ostatni najbardziej aktualny krok obiegu nieruchomości --->
			<cfset myWorkflow = model("place_instance").getLastElement(params.key) />
				
			<!--- Zapisanie historii zmian nieruchomości --->
			<cfset myHistory = model("place_history").new() />
			<cfset myHistory.instanceid =  params.key />
			<cfset myHistory.statusid = recallPlace /> <!--- Status komitetu odwoławczego --->
			<cfset myHistory.stepid = myWorkflow.stepid />
			<cfset myHistory.create = Now() />
			<cfset myHistory.save() />
			
		</cfif>
		<cfset redirectTo(back=true) />
	</cffunction>
	
	<cffunction
	 	name="dtStep"
		hint="Metoda oznaczająca nieruchomość jako zawieszoną na etapie Controllingu"
		description="Oznaczenie nieruhomości jako zawieszona na etapie 
			Controllingu. Status został dodany na prośbę Wojtka Marka. Źle
			się czuje jak widzi nieruchomości na stoim etapie i nie może ich
			zamknąć">
			
		<!--- Krok obiegu nieruchomości --->
	 	<cfset myworkflow = model("place_workflow").findByKey(params.key) />

		<!--- Dane kroku obiegu nieruchomości --->
		<cfset mysteps = model("place_step").findByKey(myworkflow.stepid) />

		<!---
			25.10.2012
			Generuje formularz, w którym dodaję notatkę oraz wybieram powód (jeżeli go nie ma to nie podane).
			Dodatkowo wybieram status z listy dostępnych.
		--->
		<cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#myworkflow.instanceid#") />
			
		<cfif isDefined("FORM.FIELDNAMES")> <!--- Jeżeli formularz został przesłany --->
			
			<!---<cfset myworkflow = model("place_workflow").findByKey(params.key) />--->
			<cfset myworkflow.update(
				instancereasonid=0,
				workflownote=FORM.workflownote,
				statusid=8,
				stop=Now(),
				user2=session.user.id,
				callbacks=false) />
			
			<!--- Aktualizacja informacji w tabeli trigger_place_instances --->
			<cfset myTriggerPlace = model("trigger_placeinstance").updateOne(
				where="instanceid=#myworkflow.instanceid#",
				instancenote = FORM.WORKFLOWNOTE,
				instancestatusid = 8) />
				
			<!--- Zapisanie historii zmian nieruchomości --->
			<cfset myHistory = model("place_history").new() />
			<cfset myHistory.instanceid =  myworkflow.instanceid />
			<cfset myHistory.statusid = myworkflow.statusid />
			<cfset myHistory.stepid = myworkflow.stepid />
			<cfset myHistory.reasonid = myworkflow.instancereasonid />
			<cfset myHistory.note = myworkflow.workflownote />
			<cfset myHistory.create = Now() />
			<cfset myHistory.save() />
			
			<cfset emails = model("place_instance").getUsers(instanceid=myworkflow.instanceid) />
			<cfset sender = APPLICATION.cfc.email.init() />
			
			<cfsavecontent 
				variable="myMessage">
					
				<cfprocessingdirective pageencoding="utf-8" />
				<cfoutput>
				<html>
				<head>
					<title>NIERUCHOMOŚCI - Monkey</title>
					<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
					<style type="text/css"> 
						body { background: transparent url("../images/page.png"); font: normal 12px "Lucida Sans Unicode", sans-serif; color: ##444; }
						a { color: ##3B5998; text-decoration: none; }
						.clear { float: none; clear: both; }

						dl { margin: 0; }
						dl dt { background: ##d7d7d7; color: ##000; font-weight: normal; float: left; padding: 5px; width: 150px; clear: both; margin: 0 10px 0 0; }
						dl dd { float: left; padding: 5px 0; margin: 0 0 1px 10px; width: 150px; }
						dl .header { font-weight: bold; }
					</style>
				</head>
				<body>
		
					Witaj,<br />
					Nieruchomość, w obiegu której bierzesz udział, zmieniła status. Aby dowiedzieć się szczegółów proszę zalogować się na http://intranet.monkey.xyz i przejść do zakładki Nieruchomości.
					<br />
					<br />
			
					<div class="clear"></div>
			
					<dl class="workflow">
			
						<dt>Ulica i numer</dt>
						<dd>#myinstance.street# #myinstance.streetnumber#</dd>
				
						<dt>Miasto i kod pocztowy</dt>
						<dd>#myinstance.postalcode# #myinstance.city#</dd>
				
						<dt>Dodane przez</dt>
						<dd>#myinstance.givenname# #myinstance.sn#</dd>
				
					</dl>
			
					<div class="clear"></div>
		
					<br /><br />
			
					Pozdrawiamy,<br />
					Monkey Group
		
				</body>
				</html>
				</cfoutput>	
			</cfsavecontent>
			
			
			<cfthread
				action="run" 
				name="dtStepSender"
				priority="LOW" >
				
				<cfset sender.setTo(users=emails).setSubject(subject="Zawieszone na etapie Działu techn.").setBody(body=myMessage).send() />
				
			</cfthread>

			<cfset redirectTo(controller="Place_instances",action="index",success="Został zmieniony status nieruchomości. Powiadomienia są rozsyłane.") />
			
		</cfif>
			
	 </cffunction>
	 
	 <cffunction 
	 	 name="searchplace">
		 
		 <cfif StructKeyExists(params, "q")>
		 	 
		 	<cfset query = ListToArray(params.q, " ") />
			<cfset where='' />
			
			<!---<cfloop index="idx" array="#query#">
				<cfset where &= " OR city LIKE '%#idx#%' OR street LIKE '%#idx#%'" />
			</cfloop>--->
			
			<cfloop index="idx" from="1" to="#ArrayLen(query)#">
				<cfset query[idx] = Replace(query[idx], ",", "") />
			</cfloop>
			
			<cfif ArrayLen(query) eq 1>				
				<cfset where = "city LIKE '%#query[1]#%' OR street LIKE '%#query[1]#%'" />
			
			<cfelseif ArrayLen(query) gt 1>				
				<cfset where = "(city LIKE '%#query[1]#%' AND street LIKE '%#query[2]#%') OR (city LIKE '%#query[2]#%' AND street LIKE '%#query[1]#%')" />
			
			<cfelse>				
				<cfset where = "id IS NULL" />
			
			</cfif>
		 	 
		 	<cfset places = model("Trigger_placeinstance").findAll(
			 	select="instanceid, TRIM(city), TRIM(street), streetnumber, IF(CONCAT('',homenumber*1)=homenumber, homenumber*1, NULL) as homenumber, postalcode",
			 	where="#where#",
				maxRows="15") />
			 
			<cfset json = places />
		
		<cfelse>
			
			<cfset json = '' />
		
		</cfif>
		 
		 <cfset renderWith(data="json",template="/json",layout=false) />
		 
	 </cffunction>
				 

</cfcomponent>