<cfcomponent extends="Model">

	<cffunction name="init">
	
		<cfset table('view_invoicenames') />
		<cfset setPrimaryKey(property="id")>
		
	</cffunction>

</cfcomponent>