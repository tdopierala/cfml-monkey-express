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
		name="index">
		hint="Pobieram listę użytkowników do uprawnień">

		<cfset users = model("place_filetypeprivilege").getUsersPrivileges() />

	</cffunction>

	<cffunction
		name="getUserFileTypes"
		hint="Pobranie listy z uprawnieniami dostępu do plików">

		<cfset filetypes = model("place_filetypeprivilege").getUserFileTypes(userid=params.key) />

	</cffunction>

	<cffunction
		name="updateReadPrivilege"
		hint="Aktualizacja uprawnienia do czytania pliku">

		<cfset myprivilege = model("place_filetypeprivilege").findByKey(params.filetypeprivilegeid) />

		<cfset myprivilege.update(
			readprivilege=1-myprivilege.readprivilege,
			callbacks=false) />

	</cffunction>

	<cffunction
		name="updateWritePrivilege"
		hint="Aktualizacja uprawnienia do zapisania nowego pliku">

		<cfset myprivilege = model("place_filetypeprivilege").findByKey(params.filetypeprivilegeid) />

		<cfset myprivilege.update(
			writeprivilege=1-myprivilege.writeprivilege,
			callbacks=false) />

	</cffunction>

	<cffunction
		name="updateDeletePrivilege"
		hint="Aktualizacja uprawnienia do usunięcia pliku">

		<cfset myprivilege = model("place_filetypeprivilege").findByKey(params.filetypeprivilegeid) />

		<cfset myprivilege.update(
			deleteprivilege=1-myprivilege.deleteprivilege,
			callbacks=false) />

		<cfset renderNothing() />

	</cffunction>

</cfcomponent>