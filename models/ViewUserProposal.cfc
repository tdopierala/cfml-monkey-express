<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset table("view_userproposals") />
		<cfset setPrimaryKey("proposalid") />
	
	</cffunction>

</cfcomponent>