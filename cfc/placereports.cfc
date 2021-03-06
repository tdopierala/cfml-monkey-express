<cfcomponent
	displayname="placereports"
	output="false" 
	hint="Komponent generujący raporty z bazy nieruchomości.">

	<cfparam 
		name="datasource"
		type="string" />
	
	<cfset THIS.datasource = "intranet" />
	
	<cffunction
		name="init">
	
		<cfargument name="datasource" type="string" default="#THIS.datasource#" required="false" />
		<cfset THIS.datasource = arguments.datasource />
	
	</cffunction>
	
	<cffunction
		name="report_by_user"
		hint="Wygenerowanie raportu dla uzytkownika.">
	
		<cfargument name="userid" type="numeric" default="0" required="true" />
		
		
	
	</cffunction>
		
</cfcomponent>