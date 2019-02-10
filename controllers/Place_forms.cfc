<cfcomponent
	extends="Controller">

	<cffunction
		name="init">

		<cfset super.init() />
		<cfset filters(through="privilege") />

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

	</cffunction>

	<cffunction
		name="index"
		hint="Pobranie listy wszystkich formularzy nieruchomości">

		<cfset forms = model("place_form").getAllForms() />

	</cffunction>

	<cffunction
		name="add"
		hint="Formularz dodawania nowego formularza do nieruchomości">

		<cfset fields = model("place_field").getAllFields() />

	</cffunction>

	<cffunction
		name="actionAdd"
		hint="Zapisanie formularza nowego formularza :)">

		<!---
			Tworzę nowy formularz.
		--->
		<cfset myform = model("place_form").New() />
		<cfset myform.formname = params.formname />
		<cfset myform.formdescription = params.formdescription />
		<cfset myform.userid = session.userid />
		<cfset myform.formcreated = Now() />
		<cfset myform.save(callbacks=false) />

		<!---
			Mając już zapisany formularz dodaje wszystkie pola formularza.
		--->
		<cfif StructKeyExists(params, "fields")>

			<cfloop collection="#params.fields#" item="i">

				<cfset myformfield = model("place_formfield").New() />
				<cfset myformfield.formid = myform.id />
				<cfset myformfield.fieldid = i />
				<cfset myformfield.fieldvisible = 1 />
				<cfset myformfield.save(callbacks=false) />

			</cfloop>

		</cfif>

		<cfset redirectTo(controller="Admins",action="index",success="Nowy formularz został dodany prawidłowo.") />

	</cffunction>

	<cffunction
		name="addField"
		hint="Dodanie nowego pola formularza">

		<cfset fieldtypes = model("place_fieldtype").getTypes() />
		<cfset fields = model("place_field").getAllFields() />

	</cffunction>

	<cffunction
		name="actionAddField"
		hint="Akcja zapisania nowego pola formularza">

		<cfset myfield = model("place_field").New(params) />
		<!---<cfset myfield.fieldname = params.fieldname />--->
		<!---<cfset myfield.fieldlabel = params.fieldlabel />--->
		<!---<cfset myfield.fieldtypeid = params.fieldtypeid />--->
		<cfset myfield.fieldcreated = Now() />
		<cfset myfield.userid = session.userid />
		<cfset myfield.save(callbacks=false) />

		<!---
		10.10.2012
		Dodawanie pól z wyborem do selectboxów.
		--->
		<cfif StructKeyExists(params, "selectboxname")>
			<cfloop collection="#params.selectboxname#" item="i" >
				<cfset myfieldvalue = model("place_fieldvalue").New() />
				<cfset myfieldvalue.fieldid = myfield.id />
				<cfset myfieldvalue.fieldvalue = params.selectboxname[i] />
				<cfset myfieldvalue.save(callbacks=false) />
			</cfloop>
		</cfif>

		<cfset redirectTo(controller="Place_forms",action="addField",success="Nowe pole zostało dodane pomyślnie.") />

	</cffunction>

	<cffunction
		name="fields"
		hint="Lista pól formularzy">

		<cfset fields = model("place_field").getAllFields() />

	</cffunction>

	<cffunction
		name="assignToStep"
		hint="Przypisanie formularza do etapu.">

		<cfset allsteps = model("place_step").getAllSteps() />
		<cfset forms = model("place_form").getFormsToSelectBox() />
		<cfset steps = model("place_step").getSepsToSelectBox() />

	</cffunction>

	<cffunction
		name="actionAssignToStep"
		hint="Apcja przypisania formularza do etapu">

		<cfset myconnection = model("place_stepform").Create(params) />
		<!---
			TODO
			11.10.2012
			Dorobić automatyczne tworzenie pól formularzy, dla już istniejących  nieruhomości.
		--->
		<cfset redirectTo(controller="Place_forms",action="assignToStep",success="Powiązanie zostało poprawnie dodane.") />

	</cffunction>

	<cffunction
		name="stepForms"
		hint="Pobieram listę formularzy przypisanych do etapu">

		<cfset forms = model("place_form").getFormsByStep(stepid=params.key) />

	</cffunction>

	<cffunction
		name="formFields"
		hint="Pobranie listy pól formularza">

		<cfset fields = model("place_field").getFieldsByForm(formid=params.key) />

	</cffunction>

	<cffunction
		name="assignField"
		hint="Przypisanie pola do formularza">

		<cfset allforms = model("place_form").getAllForms() />
		<cfset forms = model("place_form").getFormsToSelectBox() />
		<cfset fields = model("place_field").getFieldsToSelectBox() />

	</cffunction>

	<cffunction
		name="actionAssignField"
		hint="Akcja przypisania pola do formularza">

		<cfset form = model("place_formfield").Create(params) />
		<cfset redirectTo(controller="Place_forms",action="assignField",success="Pole zostało prawidłowo dodane do formularza.") />

	</cffunction>

	<!---
		Formularz dodający pola wyboru do SelecctBoxów
	--->
	<cffunction
		name="addSelectBoxForm"
		hint="Metoda generująca formularz dodawania pól wyboru" >

		<cfset elcnt = 1 />

	</cffunction>

	<cffunction
		name="addSelectBoxSingleForm"
		hint="Metoda dodająca pojedyńczy wiersz do tabelki z opcjami do selectbox" >

		<cfset elcnt = params.key+1 />

	</cffunction>

	<cffunction
		name="reorder"
		hint="Sortowanie pól formularza">

		<cfif IsAjax()>

			<cfset j = 1 />
			<cfloop list="#params.neworder#" index="i" delimiters=",">
				<cfset myfield = model("place_formfield").findByKey(i) />
				<cfset myfield.update(ord=j) />
				<cfset j++ />
			</cfloop>

			<cfset renderWith(data="",layout=false) />

		</cfif>

	</cffunction>

	<cffunction
		name="acceptForm"
		hint="Akceptowanie formularza przez użytkownika">

		<cfset recordsUpdated = model("place_instanceform").updateAll(accepted=1,where="formid=#params.formid# AND instanceid=#params.instanceid#") />

		<!---
			26.11.2012
			Przekierowuje do formularza z możliwością dodania komentarza do zaakceptowanego formularza.
			Opcja dodana na prośbę Joanny Kollat. Chciała mieć możliwość dodania rekomendacji/opinii.
		--->
		<cfset redirectTo(controller="Place_forms",action="addFormNote",params="formid=#params.formid#&instanceid=#params.instanceid#") />
		<!---<cfset redirectTo(back="true") />--->

	</cffunction>

	<cffunction
		name="updateRequired"
		hint="Ustawienie pola jako wymagane">

		<cfset myffield = model("place_formfield").findByKey(params.formfieldid) />
		<cfset myffield.update(
			required=1-myffield.required,
			callbacks=false) />


	</cffunction>

	<cffunction
		name="removeFromStep"
		hint="Usunięcie formularza z etapu obiegu nieruchomości">

		<cfset myform = model("place_stepform").deleteByKey(params.key) />

	</cffunction>

	<cffunction
		name="addFormNote"
		hint="Dodanie komentarza do całego formularza.">

		<!---
			Sprawdzam, czy przesłano formularz.
		--->
		<cfif (getHTTPRequestData().method is 'POST') and not structIsEmpty(FORM)>

			<cfset myformnote = model("place_forminstancenote").New() />
			<cfset myformnote.userid = session.userid />
			<cfset myformnote.formid = params.formid />
			<cfset myformnote.instanceid = params.instanceid />
			<cfset myformnote.formnote = params.formnote />
			<cfset myformnote.created = Now() />
			<cfset myformnote.save(callbacks=false) />

			<!---
			7.01.2013
				Wysyłanie maila do właściciela nieruchomości z informacją o komentarzu.
			--->
			<cfset myinstance = model("place_instance").findOne(where="id=#myformnote.instanceid#") />
			<cfset myuser = model("user").findOne(where="id=#myinstance.userid#") />
			<cfset mail = model("email").commentNotification(
				instance=myinstance,
				comment=myformnote.formnote,
				user=myuser) />
			<!---
				Koniec wysyłania maila do właściciela nieruchomości.
			--->

			<cfset redirectTo(controller="Place_instances",action="getInstanceForm",key=params.instanceid,params="formid=#params.formid#") />

		</cfif>

	</cffunction>

	<cffunction
		name="getFormNotes"
		hint="Pobranie notatki do formularza">

		<cfset mynotes = model("place_form").getFormNotes(formid=params.formid,instanceid=params.instanceid) />

	</cffunction>
	
	<cffunction
		name="defaultStepForm"
		hint="Ustawiam domyślne formularze dla etapu."
		description="Metoda ustawiająca domyślne formularze dla etapu. Przy 
			wchodzeniu w dany etap uzytkownikowi będą się otwierały formularze, 
			które musi wypełnić">
		
		<cfif IsDefined( "params.stepformid" ) and Len( params.stepformid )>
			
			<cfset myStepForm = model( "place_stepform" ).findByKey( params.stepformid ) />
			<cfset myStepForm.update( 
				defaultform=1-myStepForm.defaultform,
				callbacks=false ) />
			
		</cfif>
		
		<cfset renderNothing() />
		
	</cffunction>
	
	<cffunction name="removeFormField" output="false" access="public" hint="">
		<!--- Sprawdzam, czy przesłano id pola do usunięcia. Jak tak to usuwam je --->
		<cfif IsDefined("url.key")>
			<cfset toDelete = model("place_formfield").removeFormField(url.key) />
		</cfif>
		
		<cfset renderNothing() />
	</cffunction>

</cfcomponent>