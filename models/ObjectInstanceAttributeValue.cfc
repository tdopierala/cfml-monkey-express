<cfcomponent extends="Model">

	<cffunction name="init">
	
		<cfset belongsTo("object")>
		<cfset belongsTo("attribute")>
		<cfset belongsTo("objectInstance")>
		<cfset belongsTo("objectAttribute")>
	
	</cffunction>

</cfcomponent>