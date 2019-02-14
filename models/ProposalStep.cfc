<cfcomponent
	extends="Model">

	<cffunction 
		name="init">
	
		<cfset belongsTo("user") />
		<cfset belongsTo("proposalType") />
		<cfset belongsTo("proposalStatus") />
	
	</cffunction>

</cfcomponent>