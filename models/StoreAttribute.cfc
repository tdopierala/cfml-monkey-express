<cfcomponent 
	extends="Model">

	<cffunction name="init">
	
		<cfset table("store_storeattributes") />
		<cfset belongsTo("attribute") />
	
	</cffunction>

</cfcomponent>