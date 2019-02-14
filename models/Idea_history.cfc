<cfcomponent extends="Model">
	
	<cffunction name="init">
	
		<cfset belongsTo(name="user", foreignKey="userid") />
		<cfset belongsTo(name="idea_historiesname", foreignKey="activity") />
		<cfset belongsTo(name="idea_status", foreignKey="target", joinType="left") />
		
	</cffunction> 
	
</cfcomponent>