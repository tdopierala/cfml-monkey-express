<cfcomponent extends="Model">

	<cffunction name="init">
	
		<cfset belongsTo("user")>
		<cfset belongsTo("feedDefinition")>
	
	</cffunction>

</cfcomponent>