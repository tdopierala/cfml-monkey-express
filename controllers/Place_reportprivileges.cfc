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
		hint="Lista wszystkich użytkowników">

		<cfset myusers = model("place_reportprivilege").getUsersPrivileges() />

	</cffunction>

	<cffunction
		name="getUserReports"
		hint="Raporty użytkowników">

		<cfset myreports = model("place_reportprivilege").getUserReports(userid=params.key) />

	</cffunction>

	<cffunction
		name="updateReadPrivilege"
		hint="Aktualiacja uprawnienia do dostępu do raportu">

		<cfset myreport = model("place_reportprivilege").findByKey(params.readprivilegeid) />
		<cfset myreport.update(
			readprivilege=1-myreport.readprivilege,
			callbacks=false) />

	</cffunction>

</cfcomponent>