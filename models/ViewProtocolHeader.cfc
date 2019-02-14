<cfcomponent 
	extends="Model">
	
	<cffunction 
		name="init">
	
		<cfset table("view_protocolheaders") />
		<cfset setPrimaryKey("protocolid") />
	
	</cffunction>

</cfcomponent>