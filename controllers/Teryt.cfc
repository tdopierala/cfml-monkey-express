<cfcomponent
	extends="no_login_check"
	output="false">

	<cffunction
		name="init">

		<cfset super.init() />

	</cffunction>

	<cffunction
		name="ulice"
		hint="Wyszukiwanie ulic z bazy TERYT">

		<cfset json = model("teryt_ulic").ulic(
			tosearch = params.name_startsWith) />

		<cfset renderWith(data="json",layout=false,template="json") />

	</cffunction>

	<cffunction
		name="miasta"
		hint="Autouzupełnianie listy miast">

		<cfset json = model("teryt_simc").simc(
			tosearch = params.name_startsWith) />

		<cfset renderWith(data="json",layout=false,template="json") />

	</cffunction>

</cfcomponent>