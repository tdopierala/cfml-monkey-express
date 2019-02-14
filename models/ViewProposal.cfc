<cfcomponent
	extends="Model">

	<cffunction
		name="init">
	
		<cfset table("view_proposals") />
		<cfset setPrimaryKey("proposalid") />
		
		<cfset belongsTo(name="user",foreignKey="userperformproposal") />
		<cfset belongsTo(name="proposalStatus",foreignKey="stepacceptproposal") />
	
	</cffunction>

</cfcomponent>