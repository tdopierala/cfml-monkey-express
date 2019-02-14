<cfcomponent extends="Model">
	
	<cffunction name="init">
	
		<cfset belongsTo("user")>
		<cfset belongsTo("objectInstance")>
	
	</cffunction>
	
</cfcomponent>