<cfcomponent extends="Model">

	<cffunction name="init">
		
		<cfset belongsTo("message") />
		<cfset belongsTo("group") />
		
	</cffunction>

</cfcomponent>