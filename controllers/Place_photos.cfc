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
		hint="Lista wszystkich kategorii zdjęć">

		<cfset allsteps = model("place_step").getAllSteps() />
		<cfset steps = model("place_step").getSepsToSelectBox() />
		<cfset allphotos = model("place_photo").getAllPhotoTypes() />
		<cfset photos = model("place_photo").getPhotoTypesToSelectBox() />

	</cffunction>

	<cffunction
		name="stepPhotoTypes"
		hint="Pobranie typów zdjęc dla danego etapu">

		<cfset phototypes = model("place_photo").getPhotoTypesByStep(stepid=params.key) />

	</cffunction>

	<cffunction
		name="actionAdd"
		hint="Zapisanie nowego typu zdjęcia">

		<cfset mytype = model("place_phototype").New() />
		<cfset mytype.phototypename = params.phototypename />
		<cfset mytype.phototypecreated = Now() />
		<cfset mytype.save(callbacks=false) />

		<cfset redirectTo(controller="Place_photos",action="index",success="Nowy typ został dodany prawidłowo.") />


	</cffunction>

	<cffunction
		name="actionAssignToStep"
		hint="Przypisanie typu zdjęcia do etapu">

		<cfset mystep = model("place_stepphototype").Create(params) />
		<cfset redirectTo(controller="Place_photos",action="index",success="Poprawnie przypisano typ zdjęcia do etapu.") />

	</cffunction>

	<cffunction
		name="getInstancePhotos"
		hint="Metoda listująca pliki danego typu przypisane do nieruchomości">

		<cfset myphototype = model("place_phototype").findByKey(params.phototypeid) />
		<cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#params.key#") />
		<cfset myphotos = model("place_photo").getInstancePhotoTypes(instanceid=params.key,phototypeid=params.phototypeid) />
		<cfset mystep = model("place_step").findByKey(params.stepid) />

		<!---
			21.11.2012
			Pobieram listę kategorii zdjęć i pokazuję ją w formularzu dodawania
			zdjęcia.
		--->

		<cfset i = 1 />

		<cfset mytypes = model("place_photo").getPhotosByStepSummary(instanceid=params.key,stepid=params.stepid) />

	</cffunction>

	<cffunction
		name="actionAddPhotoToInstance"
		hint="Zapisanie zdjęcia do odpowiedniej intancji">

		<cfset fileErrors = ArrayNew(1) />

		<!--- Zapisuje plik na serwerze --->
		<cfset myfile = APPLICATION.cfc.upload.SetDirName(dirName="places") />

		<!---
			11.03.2013
			Dodawanie zdjęć odbywa się w pętli.
			Formularz został wzbogacony o możliwość załączenia więcej niż
			jednego pliku.
		--->
		<cfset tmp_files = params.phototypefile />

		<cfloop collection="#tmp_files#" item="i">

			<cfset file_field = "phototypefile[#i#]" />
			<cfset myfile = APPLICATION.cfc.upload.upload(file_field="#file_field#") />

			<cfif isStruct(myfile) AND StructKeyExists(myfile, "SUCCESS") >

				<!--- Zapisuję instancję pliku w tabeli PLACE_INSTANCEFILETYPES --->
				<cfset myphoto = model("place_instancephototype").New() />
				<cfset myphoto.instanceid = params.instanceid />
				<cfset myphoto.phototypeid = params.phototypeid />
				<cfset myphoto.photobincontent = myfile.BINARYCONTENT />
				<cfset myphoto.phototypecreated = myfile.TIMECREATED />
				<cfset myphoto.phototypesrc = myfile.NEWSERVERNAME />
				<cfset myphoto.phototypename = myfile.CLIENTFILENAME & "." & myfile.CLIENTFILEEXT />
				<cfset myphoto.userid = session.userid />
				<cfset myphoto.phototypethumb = myfile.THUMBFILENAME />
				<cfset myphoto.save(callbacks=false) />

			<cfelseif IsStruct(myfile) AND StructKeyExists(myfile, "error")>

				<cfset flashInsert(fileErrors=myfile.error) />

			</cfif>

		</cfloop>

		<cfset redirectTo(back="true") />

	</cffunction>

	<cffunction
		name="photoReport"
		hint="Raport ze wszystkich zdjęć dodanych do nieruchomości.">

		<!---
			11.03.2013
			Metoda generująca plik PDF zawierający raport ze wszystkich zdjęć
			dodanych do nieruchomości. Zdjęcia są opisane ich kategorią.
		--->

		<cfset my_photos = model("place_photo").photoReport(
			instanceid = params.key) />

		<cfif structKeyExists(params, "format")>
			<cfset renderWith(data="my_photos",layout=false) />
		</cfif>

	</cffunction>

	<cffunction
		name="delete"
		hint="Usunięcie zdjęcia">

		<!---
			Metoda usuwająca zdjęcie permanentnie.
		--->
		<cfif structKeyExists(params, "key")>

			<cfset my_photo = model("place_instancephototype").findByKey(params.key) />

			<!---
				Sprawdzam, czy istnieje plik na dysku i kasuje go.
			--->
			<cfif fileExists(ExpandPath("files/places/#my_photo.phototypesrc#")) >

				<cffile action="delete" file="#ExpandPath("files/places/#my_photo.phototypesrc#")#" />

			</cfif>

			<!---
				Sprawdzam, czy istnieje miniaturka na dysku i kasuje ją.
			--->
			<cfif fileExists(ExpandPath("files/places/#my_photo.phototypethumb#")) >

				<cffile action="delete" file="#ExpandPath("files/places/#my_photo.phototypethumb#")#" />

			</cfif>

			<cfset my_photo.delete() />

		</cfif>

		<cfset redirectTo(back="true",success="Zdjęcie zostało usunięte.") />

	</cffunction>

	<cffunction
		name="addFileRow"
		hint="Dodanie nowego wiersza z plikiem do wgrania">

		<!---
			Inkrementuje licznik. Jak go nie ma to ustawiam na 1
		--->
		<cfif structKeyExists(params, "key")>

			<cfset i = params.key+1 />

		<cfelse>

			<cfset i = 1 />

		</cfif>

	</cffunction>

</cfcomponent>