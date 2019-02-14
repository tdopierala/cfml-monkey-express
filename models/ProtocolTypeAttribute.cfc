<cfcomponent extends="Model">

	<cffunction name="init">
	
		<cfset belongsTo("attribute") />
		<cfset belongsTo("protocol") />
	
	</cffunction>

</cfcomponent>