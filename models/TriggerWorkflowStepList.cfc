<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset table("trigger_workflowsteplists") />
		<cfset setPrimaryKey("id") />
	
	</cffunction>

</cfcomponent>