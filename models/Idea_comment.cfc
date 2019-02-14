<cfcomponent extends="Model">
	
	<cffunction name="init" >
	
		<cfset belongsTo(name="user", foreignKey="userid") />
		
		<cfset validatesPresenceOf(properties="text", message="Komentarz nie może być pusty.") />
		
	</cffunction>
	
</cfcomponent>