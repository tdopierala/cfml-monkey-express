<cfcomponent extends="Model">

	<cffunction name="init">
	
		<cfset table('view_users') />
		<cfset setPrimaryKey(property="id")>
		
	</cffunction>

</cfcomponent>