<cfcomponent extends="Model">
	
	<cffunction name="init">
		
		<cfset table("idea_files") />
		<cfset belongsTo(name="idea_text", foreignKey="textid") />
		
	</cffunction> 
	
</cfcomponent>