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

		<cfset users = model("place_formprivilege").getUsersPrivileges() />

	</cffunction>

	<cffunction
		name="getUserForms"
		hint="Pobranie formularzy do których ma dostęp użytkownik">

		<cfset forms = model("place_formprivilege").getUserForms(userid=params.key) />

	</cffunction>

	<cffunction
		name="updateReadPrivilege"
		hint="Aktualizacja uprawnień użytkownika do czytania formularzy">

		<cfset myprivilege = model("place_formprivilege").findByKey(params.formprivilegeid) />

			<cfset myprivilege.update(
				readprivilege=1-myprivilege.readprivilege,
				callbacks=false) />

	</cffunction>

	<cffunction
		name="updateWritePrivilege"
		hint="Aktualizacja uprawnień użytkownika do modyfikacji formularzy">

		<cfset myprivilege = model("place_formprivilege").findByKey(params.formprivilegeid) />

			<cfset myprivilege.update(
				writeprivilege=1-myprivilege.writeprivilege,
				callbacks=false) />

	</cffunction>

	<cffunction
		name="updateAcceptPrivilege"
		hint="Aktualizacja uprawnień użytkownika do akceptacji formularzy">

		<cfset myprivilege = model("place_formprivilege").findByKey(params.formprivilegeid) />

			<cfset myprivilege.update(
				acceptprivilege=1-myprivilege.acceptprivilege,
				callbacks=false) />

	</cffunction>



</cfcomponent>