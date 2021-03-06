<cfcomponent extends="Model">
	
	<cffunction name="init" >
		
		<cfset table("idea_texts") />
		
		<cfset belongsTo(name="user", foreignKey="userid") />
		<cfset belongsTo(name="idea", foreignKey="ideaid") />
		
		<cfset validatesPresenceOf(properties="text", message="Treść pomysłu nie może być pusta.") />
		
	</cffunction>
	
</cfcomponent>