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
		hint="Lista plików w nieruchomościach">

		<cfset allsteps = model("place_step").getAllSteps() />
		<cfset steps = model("place_step").getSepsToSelectBox() />
		<cfset allfiles = model("place_file").getAllPlaceFileTypes() />
		<Cfset files = model("place_file").getAllPlaceFileTypeToSelectBox() />

	</cffunction>

	<cffunction
		name="stepFileTypes"
		hint="Pobranie listy typów plików dla etapu">

		<cfset filetypes = model("place_file").getAllFileTypesByStep(stepid=params.key) />

	</cffunction>

	<cffunction
		name="actionAdd"
		hint="Zapisanie nowego typu pliku">

		<cfset myfile = model("place_filetype").New() />
		<cfset myfile.filetypename = params.filetypename />
		<cfset myfile.filetypecreated = Now() />
		<cfset myfile.save(callbacks=false) />

		<cfset redirectTo(controller="Place_files",action="index",success="Dodanie now ego type pliku zakończyło się powodzeniem.") />

	</cffunction>

	<cffunction
		name="actionAssignToStep"
		hint="Przypisanie typu pliku do etapu">

		<cfset mystep = model("place_stepfiletype").Create(params) />
		<cfset redirectTo(controller="Place_files",action="index",success="Typ pliku został prawidłowo przypisany do etapu.") />

	</cffunction>

	<cffunction
		name="getInstanceFiles"
		hint="Pobranie listy plików do danej nieruchomości">

		<cfset files = model("place_file").getInstanceFilesByType(filetypeid=params.filetypeid,instanceid=params.key) />
		<cfset filetype = model("place_filetype").findByKey(params.filetypeid) />
		<cfset myinstance = model("trigger_placeinstance").findOne(where="instanceid=#params.key#") />

	</cffunction>

	<cffunction
		name="actionAddInstanceFile"
		hint="Zapisanie formularza z plikiem do nieruchomości">

		<!--- Zapisuje plik na serwerze --->
		<cfset var myfile = APPLICATION.cfc.upload.SetDirName(dirName="places") />
		<cfset myfile = APPLICATION.cfc.upload.upload(file_field="filebincontent") />

		<!---
			Jeżeli wystąpił bład przy dodawaniu pliku.
		--->
		<cfif not StructIsEmpty(myfile) AND StructKeyExists(myfile, "error")>

			<cfset redirectTo(back=true,error="#myfile.error#") />

		<cfelseif not StructIsEmpty(myfile) AND StructKeyExists(myfile, "SUCCESS")>

			<cfset myinstancefiletype = model("place_instancefiletype").New() />
			<cfset myinstancefiletype.instanceid = params.instanceid />
			<cfset myinstancefiletype.filetypeid = params.filetypeid />
			<cfset myinstancefiletype.filecreated = Now() />
			<cfset myinstancefiletype.userid = session.userid />
			<cfset myinstancefiletype.filetypedescription = params.filetypedescription />
			<cfset myinstancefiletype.save(callbacks=false) />

			<cfif StructKeyExists(myfile, "THUMBFILENAME")>

				<!--- Zapisuję plik --->
				<cfset myinstancefiletype.update(
					filebincontent=myfile.BINARYCONTENT,
					filename=myfile.CLIENTFILENAME & "." & myfile.CLIENTFILEEXT,
					filesrc=myfile.NEWSERVERNAME,
					filetypethumb=myfile.THUMBFILENAME,
					callbacks=false) />

			<cfelse>

				<!--- Zapisuję plik --->
				<cfset myinstancefiletype.update(
					filebincontent=myfile.BINARYCONTENT,
					filename=myfile.CLIENTFILENAME & "." & myfile.CLIENTFILEEXT,
					filesrc=myfile.NEWSERVERNAME,
					callbacks=false) />

			</cfif>

		</cfif>

		<cfset redirectTo(back=true,success="Plik został zapisany.") />

	</cffunction>

	<cffunction
		name="getInstanceFileComments"
		hint="Metoda pobierająca listę komentarzy do pliku.">

		<cfset myinstancefiletype = model("place_instancefiletype").findByKey(params.key) />
		<cfset mycomments = model("place_instancefiletypecomment").getComments(instancefiletypeid=params.key) />

	</cffunction>

	<cffunction
		name="actionAddComments"
		hint="Metoda zapisująca komentarz w bazie">

		<cfset mycomment = model("place_instancefiletypecomment").New(params) />
		<cfset mycomment.commentcreated = Now() />
		<cfset mycomment.userid = session.userid />
		<cfset mycomment.save(callbacks=false) />

		<cfset myuser = model("viewUser").findByKey(mycomment.userid) />

	</cffunction>

	<cffunction
		name="removeFromStep"
		hint="Usunięcie pliku z etapu obiegu nieruchomości" >

		<cfset myfiletype = model("place_stepfiletype").deleteByKey(params.key) />

	</cffunction>

	<cffunction
		name="delete"
		hint="Usunięcie pliku dodanego do nieruchomości">

		<!---
			Sprawdzam, czy wybrano ID pliku do usunięcia.
		--->
		<cfif StructKeyExists(params, "key")>

			<cfset myFile = model("place_instancefiletype").findByKey(params.key) />

			<!---
				Sprawdzam, czy istnieje plik na dysku i kasuje go.
			--->
			<cfif fileExists(ExpandPath("files/places/#myFile.filesrc#")) >

				<cffile action="delete" file="#ExpandPath("files/places/#myFile.filesrc#")#" />

			</cfif>

			<!---
				Sprawdzam, czy istnieje miniaturka na dysku i kasuje ją.
			--->
			<cfif fileExists(ExpandPath("files/places/#myFile.filetypethumb#")) >

				<cffile action="delete" file="#ExpandPath("files/places/#myFile.filetypethumb#")#" />

			</cfif>

			<cfset myFile.delete() />

		</cfif>

		<cfset redirectTo(back=true) />

	</cffunction>

</cfcomponent>