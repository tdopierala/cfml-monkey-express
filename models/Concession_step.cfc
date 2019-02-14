<cfcomponent 
	extends="Model">
		
	<cffunction 
		name="init">
			
		<!---<cfset table("concession_stepnames") />--->
		<cfset belongsTo(name="User", modelName="User") />
		
	</cffunction>
	
</cfcomponent>