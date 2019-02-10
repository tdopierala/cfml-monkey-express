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
		hint="Lista uzytkowników, którzy mają uprawnienia do zdjęć w nieruchomościach">

		<cfset users = model("place_phototypeprivilege").getUsersPrivileges() />

	</cffunction>

	<cffunction
		name="getUserPhotoTypes"
		hint="Pobranie listy z uprawnieniami dla użytkownika.">

		<cfset phototypes = model("place_phototypeprivilege").getUserPhotoTypes(userid=params.key) />

	</cffunction>

	<cffunction
		name="updateReadPrivilege"
		hint="Aktualizacja uprawnień do odczytu zbioru">

		<cfset mycollection = model("place_phototypeprivilege").findByKey(params.phototypeprivilegeid) />
		<cfset mycollection.update(
			readprivilege=1-mycollection.readprivilege,
			callbacks=false) />

	</cffunction>

	<cffunction
		name="updateWritePrivilege"
		hint="Aktualizacja uprawnień do zapisu zbioru">

		<cfset mycollection = model("place_phototypeprivilege").findByKey(params.phototypeprivilegeid) />
		<cfset mycollection.update(
			writeprivilege=1-mycollection.writeprivilege,
			callbacks=false) />

	</cffunction>

</cfcomponent>