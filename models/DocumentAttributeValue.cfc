<cfcomponent extends="Model">

	<cffunction name="init">

		<cfset belongsTo("document")>
		<cfset belongsTo("documentInstance")>
		<cfset belongsTo("documentAttribute")>
		<cfset belongsTo("attribute")>
	
	</cffunction>

</cfcomponent>