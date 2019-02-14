<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset table("view_holidayproposalreminders") />
		<cfset setPrimaryKey("userid") />
	
	</cffunction>

</cfcomponent>