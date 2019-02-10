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
		hint="Wyświetlenie listy wszystkich kolekcji">

		<cfset mycollections = model("place_collection").getAllCollections() />

	</cffunction>

	<cffunction
		name="getCollectionFields"
		hint="Pobranie listy pól należących do zbioru">

		<cfset mycollectionfields = model("place_collection").getCollectionFields(collectionid=params.key) />

	</cffunction>

	<cffunction
		name="add"
		hint="Formularz dodający nowy zbiór">

		<cfset mycollections = model("place_collection").getAllCollections() />
		<cfset myfields = model("place_field").getAllFields() />

	</cffunction>

	<cffunction
		name="actionAdd"
		hint="Zapisanie nowego zbioru">

		<!---
			Tworzę nowy zbiór.
		--->
		<cfset mycollection = model("place_collection").New() />
		<cfset mycollection.collectionname = params.collectionname />
		<cfset mycollection.collectiondescription = params.collectiondescription />
		<cfset mycollection.userid = session.userid />
		<cfset mycollection.collectioncreated = Now() />
		<cfset mycollection.save(callbacks=false) />

		<!---
			Mając już zapisany zbiór przypisuje odpowiednie pola.
		--->
		<cfif StructKeyExists(params, "fields")>

			<cfloop collection="#params.fields#" item="i">

				<cfset mycollectionfield = model("place_collectionfield").New() />
				<cfset mycollectionfield.collectionid = mycollection.id />
				<cfset mycollectionfield.fieldid = i />
				<cfset mycollectionfield.fieldvisible = 1 />
				<cfset mycollectionfield.save(callbacks=false) />

			</cfloop>

		</cfif>

		<cfset redirectTo(controller="Place_collections",action="index",success="Nowy zbiór został dodany prawidłowo.") />

	</cffunction>

	<cffunction
		name="collectionFields"
		hint="Pobranie listy pól zbioru">

		<cfset myfields = model("place_collection").getCollectionFields(collectionid=params.key) />

	</cffunction>

	<cffunction
		name="assignToStep"
		hint="Przypisanie zbioru do etapu" >

		<cfset mycollections = model("place_collection").getAllCollections() />
		<cfset mysteps = model("place_step").getAllSteps() />
		<cfset steps = model("place_step").getSepsToSelectBox() />
		<cfset collections = model("place_collection").getCollectionsToSelectBox() />

	</cffunction>

	<cffunction
		name="actionAssignToStep"
		hint="Akcja przypisująca zbiór do etapu" >

		<cfset myconnection = model("place_stepcollection").Create(params) />
		<!---
			TODO
			11.10.2012
			Dorobić automatyczne tworzenie pól zbiorów, dla już istniejących  nieruhomości.
		--->
		<cfset redirectTo(controller="Place_collections",action="assignToStep",success="Powiązanie zostało poprawnie dodane.") />

	</cffunction>

	<cffunction
		name="stepCollections"
		hint="Lista zbiorów przypisanych do odpowiedniego etapu">

		<cfset mycollections = model("place_collection").getAllStepCollections(stepid=params.key) />

	</cffunction>

	<cffunction
		name="getInstanceCollections"
		hint="Pobranie listy instancji zbiorów">

		<cfset mycollection = model("place_collection").findByKey(params.collectionid) />
		<cfset mycollections = model("place_collection").getInstanceCollections(instanceid=params.key,collectionid=params.collectionid) />
		<cfset myinstance = model("place_instance").findByKey(params.key) />

		<cfif StructKeyExists(params, "format")>
			
			<cfswitch expression="#mycollection.id#" > <!--- Unikalne dla róznego typu zbiorów pola --->

				<cfcase value="1" >
					<cfset mycollections = model("place_collection").getInstanceCollectionsToPdf(instanceid=params.key,collectionid=params.collectionid) />
					<cfset myinstance = model("place_instance").getInstanceById(instanceid=params.key) />
					<cfset renderWith(data="mycollection,mycollections,myinstance",layout=false,template="getinstancecollections") />
				</cfcase>

				<cfcase value="2">
					<cfset myinstance = model("place_instance").getInstanceById(instanceid=params.key) />
					<cfset mycollections = model("place_collection").pobierzDostawcowInternetuPdf(instanceid=params.key,collectionid=params.collectionid) />
					<cfset renderWith(data="myinstance,mycollections,mycollection",layout=false,template="getinstancecollections2") />

				</cfcase>

			</cfswitch>


		</cfif>

	</cffunction>

	<cffunction
		name="newCollection"
		hint="Formularz dodania nowej instancji zbioru.">

		<cfset mycollectioninstance = model("place_collectioninstance").New() />
		<cfset mycollectioninstance.collectionid = params.collectionid />
		<cfset mycollectioninstance.instanceid = params.instanceid />
		<cfset mycollectioninstance.userid = session.userid />
		<cfset mycollectioninstance.instancecreated = Now() />
		<cfset mycollectioninstance.save(callbacks=false) />

		<cfset redirectTo(controller="Place_collections",action="getCollectionInstanceForm",key=mycollectioninstance.id) />

	</cffunction>

	<cffunction
		name="getCollectionInstanceForm"
		hint="Formularz definiujący instancje zbioru" >

		<cfset tmpcollection = model("place_collectioninstance").findByKey(params.key) />
		<cfset mycollection = model("place_collection").findByKey(tmpcollection.collectionid) />
		<cfset myinstance = model("place_collectioninstance").getCollectionInstanceFields(collectioninstanceid=params.key) />

		<cfset myoptions = StructNew() />
		<cfloop query = myinstance>
			<cfset myoptions[fieldid] = model("place_fieldvalue").getValues(fieldid=fieldid) />
		</cfloop>

	</cffunction>

	<cffunction
		name="saveCollectionInstance"
		hint="Zapisanie formularza tworzącego zbiór">

		<cfloop collection="#params.field#" item="i">
	 		<cfset myfield = model("place_collectioninstancevalue").findByKey(i) />
			<cfset myfield.update(fieldvalue=params.field[i],callbacks=false) />
	 	</cfloop>

	 	<!--- Zapisuje plik na serwerze --->
		<cfset myfile = APPLICATION.cfc.upload.SetDirName(dirName="collections") />

		<!--- Sprawdzam, czy zbiór plików został przesłany --->
		<cfif StructKeyExists(params, "file")>
			<cfloop collection="#params.file#" item="i">
				<cfset myfile = APPLICATION.cfc.upload.upload(file_field="file[#i#]") />

				<!--- Sprawdzam, czy plik został zapisany --->
				<cfif not StructIsEmpty(myfile)>

					<!--- Zapisuję plik --->
					<cfset myfield = model("place_collectioninstancevalue").findByKey(i) />
					<cfset myfield.update(
						fieldbinaryvalue=myfile.BINARYCONTENT,
						fieldbinarythumb=myfile.THUMBFILENAME,
						fieldbinarysrc=myfile.NEWSERVERNAME,
						callbacks=false) />

				</cfif>

			</cfloop>
		</cfif>

	 	<cfset redirectTo(controller="Place_instances",action="index",success="Nowy zbiór został dodany prawidłowo.") />

	</cffunction>

	<cffunction
		name="getInstance"
		hint="Pobranie wszystkich pół instancji zbioru">

		<cfset tmpcollection = model("place_collectioninstance").findByKey(params.key) />
		<cfset mycollection = model("place_collection").findByKey(tmpcollection.collectionid) />
		<cfset myinstance = model("place_collectioninstance").getCollectionInstanceFields(collectioninstanceid=params.key) />

	</cffunction>

	<cffunction
		name="assignField"
		hint="Przypisanie pola do już istniejącego zbioru" >

		<cfset mysteps = model("place_step").getAllSteps() />
		<cfset collections = model("place_collection").getCollectionsToSelectBox() />
		<cfset mycollections = model("place_collection").getAllCollections() />
		<cfset myfields = model("place_field").getAllFields() />
		<cfset fields = model("place_field").getFieldsToSelectBox() />

	</cffunction>

	<cffunction
		name="actionAssignField"
		hint="Akcja przypisująca pole do zbioru">

		<cfset myconnection = model("place_collectionfield").Create(params) />

		<cfset redirectTo(controller="Place_collections",action="assignField",success="Pole zostało poprawnie przypisane do zbioru.") />

	</cffunction>

	<cffunction
		name="getCollectionComments"
		hint="Pobranie komentarzy do zbioru">

		<cfset mycomments = model("place_collectioninstancecomment").getComments(collectioninstanceid=params.key) />
		<cfset myinstance = model("place_collectioninstance").findByKey(params.key) />

	</cffunction>

	<cffunction
		name="getCollectionInstanceValueComments"
		hint="Pobranie komentarzy do pól zbioru">

		<cfset myinstance = model("place_collectioninstancevalue").findByKey(params.key) />
		<cfset mycomments = model("place_collectioninstancevalue").getComments(collectioninstancevalueid=params.key) />

	</cffunction>

	<cffunction
		name="reorder"
		hint="Metoda sortująca pola z formularzu zbioru">

		<cfif IsAjax()>

			<cfset j = 1 />
			<cfloop list="#params.neworder#" index="i" delimiters=",">
				<cfset myfield = model("place_collectionfield").findByKey(i) />
				<cfset myfield.update(ord=j) />
				<cfset j++ />
			</cfloop>

			<cfset renderWith(data="",layout=false) />

		</cfif>

	</cffunction>

	<cffunction
		name="convertPhotos"
		hint="Unikalna metoda tworząca miniaturki ze zdjęć zapisanych w bazie">

			<cfset myinstances = model("place_collectioninstancevalue").findAll(where="fieldid=60 AND fieldbinarythumb is null") />

			<cfloop query="myinstances">

				<cfif Len(fieldbinarythumb) eq 0>

					<cftry>

					<cfset myImage = ImageNew(fieldbinaryvalue) />
					<cfset filename = randomText(length=13) & ".jpg" />
					<cfimage
						action="write"
						source="#myImage#"
						destination="#ExpandPath('files/places')#/#filename#" >

					<cfset ImageScaleToFit(myImage, "", "75") />

					<cfimage
						action="write"
						source="#myImage#"
						destination="#ExpandPath('files/places')#/thumb_#filename#" >

					<cfset my = model("place_collectioninstancevalue").findByKey(id) />
					<cfset my.update(
						fieldbinarythumb="thumb_#filename#",
						fieldbinarysrc=filename,
						callbacks=false) />

					<cfcatch type="any" ></cfcatch>

					</cftry>

				</cfif>

			</cfloop>

			<cfabort />

	</cffunction>

	<cffunction
		name="delete"
		output="false" >

		<cfset mycollection = model("place_collection").delete(params.key) />

	</cffunction>


</cfcomponent>